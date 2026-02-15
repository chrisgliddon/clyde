; dungeon.s — Akalabeth dungeon system
; 10x10 grid per floor, first-person view, navigation, traps, chests, stairs

.include "macros.s"

.export DungeonInit, DungeonUpdate, DungeonRender
.export DungeonGrid, MonAlive, MonX, MonY, MonHP, MonType
.exportzp DungPlayerX, DungPlayerY, DungFloor, DungFacing

.importzp JoyPress, GameState, MapDirty
.importzp PlayerHP, PlayerFood, PlayerGold
.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS, PlayerQuest
.importzp PlayerRapier, PlayerAxe, PlayerShield, PlayerBow, PlayerAmulet
.importzp PlayerClass, DiffLevel, StatsDirty
.importzp UI_TempPtr
.import JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT, JOY_A, JOY_B, JOY_SELECT
.import TilemapBuffer, GfxUploadDungeon, GfxUploadOverworld
.import FadeOut, FadeIn
.import PlaySfx
.import PalFxFlash, PalFxTorchFlicker
.import HdmaSetDungeon, HdmaDisable
.include "sfx_ids.inc"
.import UiSetMessage, UiMsgInit, UiMsgAppendStr, UiMsgAppendNum
.import UiMsgAppendMonName, UiMsgShow
.import str_msg_hit, str_msg_miss, str_msg_killed, str_msg_quest
.import str_msg_mon_hit, str_msg_mon_miss, str_msg_dmg
.import str_msg_thief, str_msg_rapier, str_msg_axe, str_msg_shield, str_msg_bow
.import str_msg_gremlin, str_msg_chest, str_msg_gold, str_msg_trap
.import str_msg_up, str_msg_down
.import str_msg_backfire, str_msg_toad, str_msg_magkill, str_msg_magstair
.import str_msg_crumble, str_msg_died

; ============================================================================
; Constants
; ============================================================================

DUNG_W          = 11
DUNG_H          = 11
DUNG_SIZE       = DUNG_W * DUNG_H   ; 121 bytes per floor
MAX_FLOORS      = 10

; Dungeon tile types
DTILE_FLOOR     = $00
DTILE_WALL      = $01
DTILE_DOOR      = $02
DTILE_STAIRS_UP = $03
DTILE_STAIRS_DN = $04
DTILE_CHEST     = $05
DTILE_MONSTER   = $06
DTILE_TRAP      = $07

; Facing directions
FACE_NORTH      = $00
FACE_EAST       = $01
FACE_SOUTH      = $02
FACE_WEST       = $03

; Game states
STATE_OVERWORLD = $01
STATE_COMBAT    = $03

; Game states
STATE_GAMEOVER  = $06

; Dungeon gfx tile indices (matching gfx.s DungeonTiles order)
DGTILE_EMPTY    = $00       ; Black/floor
DGTILE_WALL     = $01       ; Brick wall
DGTILE_WALLHI   = $02       ; Light wall
DGTILE_DOOR     = $03       ; Door arch
DGTILE_FLOOR    = $04       ; Floor pattern
DGTILE_STAIRS   = $05       ; Stairs
DGTILE_CHEST    = $06       ; Chest
DGTILE_MONSTER_BASE = $08   ; First monster tile (10 tiles: $08-$11)

MAX_MONSTERS    = 10

; Hardware multiply registers
WRMPYA_D        = $4202
WRMPYB_D        = $4203
RDMPYL_D        = $4216

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
DungPlayerX:    .res 1
DungPlayerY:    .res 1
DungFloor:      .res 1      ; Current floor (0-9)
DungFacing:     .res 1      ; 0=N, 1=E, 2=S, 3=W
RngSeed:        .res 2      ; 16-bit PRNG state
DG_TempA:       .res 1
DG_TempB:       .res 1
DG_Offset:      .res 2
DungMoveCount:  .res 1      ; Food consumption counter
DG_MonIdx:      .res 1      ; Monster loop index
DG_TempC:       .res 1      ; Extra temp
DG_LuckKills:   .res 1      ; Accumulated luck from kills (award HP on exit)

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
DungeonGrid:    .res DUNG_SIZE
MonAlive:       .res MAX_MONSTERS
MonX:           .res MAX_MONSTERS
MonY:           .res MAX_MONSTERS
MonHP:          .res MAX_MONSTERS
MonType:        .res MAX_MONSTERS

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; PrngNext — 16-bit LFSR, returns random byte in A (8-bit)
; ============================================================================
.proc PrngNext
    SET_A16
    lda RngSeed
    asl
    bcc @no_xor
    eor #$002D
@no_xor:
    sta RngSeed
    SET_A8
    lda RngSeed
    rts
.endproc

; ============================================================================
; CalcDungOffset — compute grid offset from row (A) and col (DG_TempB)
; Returns X (16-bit). Requires 8-bit A, 16-bit XY.
; ============================================================================
.proc CalcDungOffset
    ; offset = row * 11 + col
    ; row * 11 = row * 5 * 2 + row
    sta DG_TempA
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda DG_Offset
    and #$00FF
    sta DG_Offset            ; row
    asl
    asl                     ; row*4
    clc
    adc DG_Offset            ; row*5
    asl                     ; row*10
    clc
    adc DG_Offset            ; row*11
    sta DG_Offset
    SET_A8
    lda DG_TempB
    SET_A16
    and #$00FF
    clc
    adc DG_Offset
    tax
    SET_A8
    rts
.endproc

; ============================================================================
; DungeonInit — enter dungeon, generate floor 0
; ============================================================================
.proc DungeonInit
    SET_AXY8
    SET_XY16

    stz DungFloor
    lda #FACE_SOUTH         ; Face into dungeon
    sta DungFacing

    ; Place player at stairs up (1,1)
    lda #$01
    sta DungPlayerX
    sta DungPlayerY

    stz DungMoveCount
    stz DG_LuckKills

    jsr GenerateFloor
    jsr PlaceMonsters
    jsr FadeOut
    jsr GfxUploadDungeon
    jsr HdmaSetDungeon
    jsr FadeIn
    jsr DungeonRender
    lda #$01
    sta MapDirty
    rts
.endproc

; ============================================================================
; GenerateFloor — grid-based dungeon matching original Akalabeth algorithm
; 11x11 grid: perimeter walls, even rows/cols form wall grid creating rooms,
; passage cells randomly opened as floor/door/trap/chest
; ============================================================================
.proc GenerateFloor
    SET_AXY8
    SET_XY16

    ; Seed PRNG from floor
    lda DungFloor
    clc
    adc #$A5
    sta RngSeed
    lda DungFloor
    eor #$5A
    sta RngSeed+1

    ; --- Fill all with floor ---
    ldx #$0000
    lda #DTILE_FLOOR
@fill:
    sta DungeonGrid,x
    inx
    cpx #DUNG_SIZE
    bne @fill

    ; --- Perimeter walls (row 0, row 10, col 0, col 10) ---
    ldx #$0000
@border_tb:
    lda #DTILE_WALL
    sta DungeonGrid,x                      ; Row 0
    sta DungeonGrid + 10 * DUNG_W,x        ; Row 10
    inx
    cpx #DUNG_W
    bne @border_tb

    ldx #$0000
@border_lr:
    lda #DTILE_WALL
    sta DungeonGrid,x                      ; Col 0
    sta DungeonGrid + (DUNG_W - 1),x       ; Col 10
    SET_A16
    txa
    clc
    adc #DUNG_W
    tax
    SET_A8
    cpx #DUNG_SIZE
    bcc @border_lr

    ; --- Build room grid: single pass over rows 1-9, cols 1-9 ---
    ; Even×Even = wall intersection (always wall)
    ; Even×Odd or Odd×Even = passage (randomly classify)
    ; Odd×Odd = room interior (stays floor)
    lda #$01
    sta DG_TempA                ; row
@gen_row:
    lda #$01
    sta DG_TempB                ; col
@gen_col:
    ; Save row/col on stack (CalcDungOffset clobbers them)
    lda DG_TempA
    pha
    lda DG_TempB
    pha

    ; Check even/odd pattern
    lda DG_TempA
    and #$01
    sta DG_Offset               ; 0=even row, 1=odd row
    lda DG_TempB
    and #$01
    eor DG_Offset               ; 0=same parity, 1=different
    beq @same_parity

    ; Different parity = passage cell: randomly classify
    lda DG_TempA
    jsr CalcDungOffset
    jsr PrngNext
    jsr ClassifyWallCell
    sta DungeonGrid,x
    jmp @gen_next

@same_parity:
    lda DG_TempA
    and #$01
    bne @gen_next               ; Both odd = room, leave as floor

    ; Both even = grid intersection, always wall
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_WALL
    sta DungeonGrid,x

@gen_next:
    ; Restore row/col from stack
    pla
    sta DG_TempB
    pla
    sta DG_TempA

    inc DG_TempB
    lda DG_TempB
    cmp #10                     ; cols 1-9
    bne @gen_col

    inc DG_TempA
    lda DG_TempA
    cmp #10                     ; rows 1-9
    bne @gen_row

    ; --- Place stairs (matching original layout) ---
    ; Even DungFloor: down at (3,7), up at (7,3)
    ; Odd DungFloor:  down at (7,3), up at (3,7)
    ; Floor 0 special: up at (1,1), clear (7,3)
    lda DungFloor
    and #$01
    bne @odd_floor
    lda #DTILE_STAIRS_DN
    sta DungeonGrid + 3 * DUNG_W + 7
    lda #DTILE_STAIRS_UP
    sta DungeonGrid + 7 * DUNG_W + 3
    jmp @check_floor0
@odd_floor:
    lda #DTILE_STAIRS_DN
    sta DungeonGrid + 7 * DUNG_W + 3
    lda #DTILE_STAIRS_UP
    sta DungeonGrid + 3 * DUNG_W + 7
@check_floor0:
    lda DungFloor
    bne @done
    lda #DTILE_STAIRS_UP
    sta DungeonGrid + 1 * DUNG_W + 1
    lda #DTILE_FLOOR
    sta DungeonGrid + 7 * DUNG_W + 3
@done:
    ; Ensure (2,1) is open for entrance access
    lda #DTILE_FLOOR
    sta DungeonGrid + 2 * DUNG_W + 1

    rts
.endproc

; ============================================================================
; ClassifyWallCell — convert RNG byte in A to a dungeon cell type
; Input: A = random byte (0-255)
; Output: A = DTILE_* value
; ============================================================================
.proc ClassifyWallCell
    cmp #77                 ; 0-76 (30%): keep wall
    bcc @wall
    cmp #167                ; 77-166 (35%): open floor
    bcc @floor
    cmp #218                ; 167-217 (20%): door
    bcc @door
    cmp #231                ; 218-230 (5%): trap
    bcc @trap
    cmp #244                ; 231-243 (5%): chest
    bcc @chest
    ; 244-255: wall
@wall:
    lda #DTILE_WALL
    rts
@floor:
    lda #DTILE_FLOOR
    rts
@door:
    lda #DTILE_DOOR
    rts
@trap:
    lda #DTILE_TRAP
    rts
@chest:
    lda #DTILE_CHEST
    rts
.endproc

; ============================================================================
; DungeonUpdate — handle navigation, interaction
; Forward=up, TurnLeft=left, TurnRight=right, TurnAround=down, B=use stairs
; ============================================================================
.proc DungeonUpdate
    SET_AXY8
    SET_XY16

    ; 16-bit joypad test
    SET_A16
    lda JoyPress
    bit #JOY_UP
    bne @forward
    bit #JOY_LEFT
    bne @turn_left
    bit #JOY_RIGHT
    bne @turn_right
    bit #JOY_DOWN
    bne @turn_around
    bit #JOY_A
    bne @do_attack
    bit #JOY_B
    bne @do_stairs
    bit #JOY_SELECT
    bne @do_amulet
    SET_A8
    rts

@do_attack:
    SET_A8
    jmp @player_attack

@do_stairs:
    SET_A8
    jmp @use_stairs

@do_amulet:
    SET_A8
    jmp @use_amulet

@turn_left:
    SET_A8
    lda DungFacing
    dec a
    and #$03
    sta DungFacing
    jmp @render_exit

@turn_right:
    SET_A8
    lda DungFacing
    inc a
    and #$03
    sta DungFacing
    jmp @render_exit

@turn_around:
    SET_A8
    lda DungFacing
    clc
    adc #$02
    and #$03
    sta DungFacing
    jmp @render_exit

@forward:
    SET_A8
    ; Calculate target cell based on facing
    lda DungPlayerY
    sta DG_TempA
    lda DungPlayerX
    sta DG_TempB

    lda DungFacing
    cmp #FACE_NORTH
    beq @fwd_north
    cmp #FACE_SOUTH
    beq @fwd_south
    cmp #FACE_EAST
    beq @fwd_east
    ; FACE_WEST
    lda DG_TempB
    bne :+
    jmp @blocked
:   dec DG_TempB
    jmp @try_fwd

@fwd_north:
    lda DG_TempA
    bne :+
    jmp @blocked
:   dec DG_TempA
    jmp @try_fwd

@fwd_south:
    lda DG_TempA
    cmp #DUNG_H - 1
    bne :+
    jmp @blocked
:   inc DG_TempA
    jmp @try_fwd

@fwd_east:
    lda DG_TempB
    cmp #DUNG_W - 1
    bne :+
    jmp @blocked
:   inc DG_TempB

@try_fwd:
    lda DG_TempA
    jsr CalcDungOffset
    lda DungeonGrid,x

    cmp #DTILE_WALL
    bne :+
    jmp @blocked
:   cmp #DTILE_MONSTER
    bne :+
    jmp @blocked
:

    ; Move player
    lda DG_TempA
    sta DungPlayerY
    lda DG_TempB
    sta DungPlayerX

    ; Food consumption: every 10 moves
    inc DungMoveCount
    lda DungMoveCount
    cmp #10
    bcc @check_special
    stz DungMoveCount
    SET_A16
    lda PlayerFood
    beq @food_empty
    dec a
    sta PlayerFood
    SET_A8
    jmp @check_special
@food_empty:
    lda PlayerHP
    beq @no_hp
    dec a
    sta PlayerHP
@no_hp:
    SET_A8

@check_special:
    ; Check what's on this tile
    lda DG_TempA
    jsr CalcDungOffset
    lda DungeonGrid,x

    cmp #DTILE_STAIRS_UP
    bne :+
    jmp @go_up
:   cmp #DTILE_STAIRS_DN
    bne :+
    jmp @go_down
:   cmp #DTILE_CHEST
    bne :+
    jmp @open_chest
:   cmp #DTILE_TRAP
    bne :+
    jmp @hit_trap
:   ; Normal floor — run monster AI then render
    jsr MonsterAI
    jmp @render_exit

@hit_trap:
    ; Original: trap drops player to next dungeon level
    lda #SFX_TRAP
    jsr PlaySfx
    lda #DTILE_FLOOR
    sta DungeonGrid,x       ; Remove trap
    lda DungFloor
    cmp #MAX_FLOORS - 1
    bne :+
    jmp @render_exit        ; Can't go deeper
:   inc DungFloor
    ; Message: "TRAP! FLOOR N"
    jsr UiMsgInit
    lda #<str_msg_trap
    sta UI_TempPtr
    lda #>str_msg_trap
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    lda DungFloor
    clc
    adc #$01                ; 1-based floor display
    jsr UiMsgAppendNum
    jsr UiMsgShow
    jsr GenerateFloor
    jsr PlaceMonsters
    jmp @place_at_up_stairs

@open_chest:
    lda #SFX_CHEST
    jsr PlaySfx
    lda #DTILE_FLOOR
    sta DungeonGrid,x       ; Remove chest
    ; Award gold: 10-40
    jsr PrngNext
    and #$1F                ; 0-31
    clc
    adc #10                 ; 10-41
    sta DG_TempA
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda PlayerGold
    clc
    adc DG_Offset
    sta PlayerGold
    SET_A8
    ; Message: "FOUND N GOLD!"
    jsr UiMsgInit
    lda #<str_msg_chest
    sta UI_TempPtr
    lda #>str_msg_chest
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    lda DG_TempA
    jsr UiMsgAppendNum
    lda #<str_msg_gold
    sta UI_TempPtr
    lda #>str_msg_gold
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    jsr UiMsgShow
    lda #$01
    sta StatsDirty
    jmp @render_exit

@go_up:
    lda #SFX_STAIRS
    jsr PlaySfx
    lda DungFloor
    beq @exit_dungeon       ; Floor 0 stairs up = exit
    dec DungFloor
    ; Message: "CLIMBED UP"
    lda #<str_msg_up
    sta UI_TempPtr
    lda #>str_msg_up
    sta UI_TempPtr+1
    jsr UiSetMessage
    jsr GenerateFloor
    jsr PlaceMonsters
    ; Place player at down-stairs of new (upper) floor
    jmp @place_at_dn_stairs

@go_down:
    lda DungFloor
    cmp #MAX_FLOORS - 1
    bne :+
    jmp @render_exit        ; Can't go deeper
:   lda #SFX_STAIRS
    jsr PlaySfx
    inc DungFloor
    ; Message: "DESCENDED"
    lda #<str_msg_down
    sta UI_TempPtr
    lda #>str_msg_down
    sta UI_TempPtr+1
    jsr UiSetMessage
    jsr GenerateFloor
    jsr PlaceMonsters
    ; Place player at up-stairs of new (lower) floor
    jmp @place_at_up_stairs

@place_at_up_stairs:
    ; Even floor: up at (7,3). Odd: up at (3,7). Floor 0: up at (1,1).
    lda DungFloor
    beq @up_floor0
    and #$01
    bne @up_odd
    lda #$03
    sta DungPlayerX
    lda #$07
    sta DungPlayerY
    jmp @render_exit
@up_odd:
    lda #$07
    sta DungPlayerX
    lda #$03
    sta DungPlayerY
    jmp @render_exit
@up_floor0:
    lda #$01
    sta DungPlayerX
    sta DungPlayerY
    jmp @render_exit

@place_at_dn_stairs:
    ; Even floor: down at (3,7). Odd: down at (7,3).
    lda DungFloor
    and #$01
    bne @dn_odd
    lda #$07
    sta DungPlayerX
    lda #$03
    sta DungPlayerY
    jmp @render_exit
@dn_odd:
    lda #$03
    sta DungPlayerX
    lda #$07
    sta DungPlayerY
    jmp @render_exit

@exit_dungeon:
    ; Award luck kills as HP
    lda DG_LuckKills
    beq @no_luck
    sta DG_TempC
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda PlayerHP
    clc
    adc DG_Offset
    sta PlayerHP
    SET_A8
    stz DG_LuckKills
@no_luck:
    ; Just set state — GfxUploadOverworld handled by main loop
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    sta StatsDirty
    rts

@blocked:
@render_exit:
    jsr DungeonRender
    lda #$01
    sta MapDirty
    rts

@player_attack:
    ; Calculate target cell in facing direction
    lda DungPlayerY
    sta DG_TempA
    lda DungPlayerX
    sta DG_TempB
    jsr StepForward
    jsr CheckCell
    cmp #DTILE_MONSTER
    beq :+
    jmp @atk_miss_no_mon
:   ; Find which monster is at this cell
    jsr FindMonsterAt
    bcc :+
    jmp @atk_miss_no_mon    ; No monster found (shouldn't happen)
:
    ; X = monster index (8-bit). Save it.
    stx DG_MonIdx
    ; Hit check: PrngNext < DEX * 8 → hit
    jsr PrngNext
    sta DG_TempC            ; Random 0-255
    lda PlayerDEX
    asl
    asl
    asl                     ; DEX * 8
    cmp DG_TempC
    bcs :+
    jmp @atk_miss           ; DEX*8 < random → miss
:
    ; Hit! Damage = PrngNext & weapon_mask + 1 + STR/4
    jsr PrngNext
    sta DG_TempC
    ; Best weapon: rapier > axe > bow > shield > hands
    ; Mages can't use rapier or bow
    lda PlayerClass
    bne @atk_skip_rapier    ; Mage → skip rapier
    lda PlayerRapier
    bne @atk_rapier
@atk_skip_rapier:
    lda PlayerAxe
    bne @atk_axe
    lda PlayerClass
    bne @atk_skip_bow       ; Mage → skip bow
    lda PlayerBow
    bne @atk_bow
@atk_skip_bow:
    lda PlayerShield
    bne @atk_shield
    lda DG_TempC
    and #$00                ; 0 damage from hands
    jmp @atk_calc
@atk_rapier:
    lda DG_TempC
    and #$0F                ; 0-15
    jmp @atk_calc
@atk_axe:
    lda DG_TempC
    and #$07                ; 0-7
    jmp @atk_calc
@atk_bow:
    lda DG_TempC
    and #$03                ; 0-3
    jmp @atk_calc
@atk_shield:
    lda DG_TempC
    and #$01                ; 0-1
@atk_calc:
    clc
    adc #$01                ; At least 1 damage
    sta DG_TempC
    lda PlayerSTR
    lsr
    lsr                     ; STR / 4
    clc
    adc DG_TempC            ; Total damage
    ; Apply damage to monster
    SET_XY8
    ldx DG_MonIdx
    cmp MonHP,x
    bcs @kill_mon           ; Damage >= HP → kill
    sta DG_TempC
    lda MonHP,x
    sec
    sbc DG_TempC
    sta MonHP,x
    ; Message: "HIT FOR N"
    lda #SFX_HIT
    jsr PlaySfx
    SET_XY16
    jsr UiMsgInit
    lda #<str_msg_hit
    sta UI_TempPtr
    lda #>str_msg_hit
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    lda DG_TempC
    jsr UiMsgAppendNum
    jsr UiMsgShow
    jsr MonsterAI
    jmp @render_exit
@kill_mon:
    ; Monster killed!
    lda #SFX_KILL
    jsr PlaySfx
    lda #$00
    sta MonAlive,x
    ; Clear from grid
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_FLOOR
    sta DungeonGrid,x
    ; Award gold = (type+1) + (floor+1)
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    clc
    adc DungFloor
    clc
    adc #$02                ; type+1 + floor+1
    sta DG_TempC
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda PlayerGold
    clc
    adc DG_Offset
    sta PlayerGold
    SET_A8
    ; Luck kills: LK += (type+1)*(floor+1)/2
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    clc
    adc #$01
    sta WRMPYA_D            ; type+1
    lda DungFloor
    clc
    adc #$01
    sta WRMPYB_D            ; floor+1
    nop
    nop
    nop
    nop
    lda RDMPYL_D            ; product low byte
    lsr                     ; / 2
    clc
    adc DG_LuckKills
    sta DG_LuckKills
    ; Check quest completion
    ldx DG_MonIdx
    lda MonType,x
    cmp PlayerQuest
    bne @kill_no_quest
    lda PlayerQuest
    ora #$80                ; Set completion flag
    sta PlayerQuest
@kill_no_quest:
    ; Message: "MONSTER KILLED!" (or "QUEST COMPLETE!" if quest)
    SET_XY16
    jsr UiMsgInit
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    tax
    SET_XY16
    jsr UiMsgAppendMonName
    lda #<str_msg_killed
    sta UI_TempPtr
    lda #>str_msg_killed
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    jsr UiMsgShow
    SET_AXY8
    lda #$01
    sta StatsDirty
    SET_XY16
    jmp @render_exit

@atk_miss_no_mon:
@atk_miss:
    lda #SFX_MISS
    jsr PlaySfx
    ; Message: "YOU MISS!"
    lda #<str_msg_miss
    sta UI_TempPtr
    lda #>str_msg_miss
    sta UI_TempPtr+1
    jsr UiSetMessage
    ; Miss — monster AI still runs
    jsr MonsterAI
    jmp @render_exit

@use_stairs:
    ; Check current tile under player
    lda DungPlayerX
    sta DG_TempB
    lda DungPlayerY
    jsr CalcDungOffset
    lda DungeonGrid,x
    cmp #DTILE_STAIRS_UP
    bne :+
    jmp @go_up
:   cmp #DTILE_STAIRS_DN
    bne :+
    jmp @go_down
:   rts

@use_amulet:
    ; Check if player has an amulet
    lda PlayerAmulet
    bne :+
    jmp @render_exit            ; No amulet — do nothing
:
    ; 4% chance of backfire (PrngNext < 10 ≈ 4%)
    jsr PrngNext
    cmp #10
    bcs @amulet_normal

    ; Backfire! Random bad effect
    jsr PrngNext
    and #$01
    beq @backfire_toad
    ; Backfire: HP / 2
    SET_A16
    lda PlayerHP
    lsr
    bne :+
    lda #$0001                  ; At least 1 HP
:   sta PlayerHP
    SET_A8
    lda #<str_msg_backfire
    sta UI_TempPtr
    lda #>str_msg_backfire
    sta UI_TempPtr+1
    jsr UiSetMessage
    jmp @amulet_consume

@backfire_toad:
    ; All stats = 3
    lda #$03
    sta PlayerSTR
    sta PlayerDEX
    sta PlayerSTA
    sta PlayerWIS
    lda #<str_msg_toad
    sta UI_TempPtr
    lda #>str_msg_toad
    sta UI_TempPtr+1
    jsr UiSetMessage
    jmp @amulet_consume

@amulet_normal:
    lda #SFX_MAGIC
    jsr PlaySfx
    ; Mage: random of 3 effects (ladder up, ladder down, magic kill)
    ; Fighter: magic kill only
    ; Random of 3 effects (both classes)
    jsr PrngNext
    sta DG_TempC
    and #$03                    ; 0-3
    cmp #$03
    bcc :+
    lda #$00                    ; Clamp to 0-2
:   beq @amulet_ladder_up
    cmp #$01
    beq @amulet_ladder_dn
    ; 2 = magic kill
    jmp @amulet_magic_kill

@amulet_ladder_up:
    ; Place stairs up at player position
    lda DungPlayerX
    sta DG_TempB
    SET_XY16
    lda DungPlayerY
    jsr CalcDungOffset
    lda #DTILE_STAIRS_UP
    sta DungeonGrid,x
    SET_AXY8
    lda #<str_msg_magstair
    sta UI_TempPtr
    lda #>str_msg_magstair
    sta UI_TempPtr+1
    jsr UiSetMessage
    jmp @amulet_consume

@amulet_ladder_dn:
    ; Place stairs down at player position
    lda DungPlayerX
    sta DG_TempB
    SET_XY16
    lda DungPlayerY
    jsr CalcDungOffset
    lda #DTILE_STAIRS_DN
    sta DungeonGrid,x
    SET_AXY8
    lda #<str_msg_magstair
    sta UI_TempPtr
    lda #>str_msg_magstair
    sta UI_TempPtr+1
    jsr UiSetMessage
    jmp @amulet_consume

@amulet_magic_kill:
    ; Find nearest monster (Manhattan distance), deal 10+floor damage
    SET_AXY8
    lda #$FF
    sta DG_TempC                ; Best distance so far
    sta DG_MonIdx               ; Best monster index ($FF = none)
    ldx #$00
@mk_scan:
    lda MonAlive,x
    beq @mk_next
    ; Calc Manhattan distance
    lda MonY,x
    sec
    sbc DungPlayerY
    bpl :+
    eor #$FF
    clc
    adc #$01
:   sta DG_TempA                ; |dy|
    lda MonX,x
    sec
    sbc DungPlayerX
    bpl :+
    eor #$FF
    clc
    adc #$01
:   clc
    adc DG_TempA                ; distance
    cmp DG_TempC
    bcs @mk_next                ; Not closer
    sta DG_TempC                ; New best distance
    stx DG_MonIdx               ; New best monster
@mk_next:
    inx
    cpx #MAX_MONSTERS
    bne @mk_scan

    ; Did we find a monster?
    lda DG_MonIdx
    cmp #$FF
    bne :+
    jmp @amulet_consume         ; No monsters → wasted
:

    ; Apply 10 + floor damage
    lda #10
    clc
    adc DungFloor
    ldx DG_MonIdx
    cmp MonHP,x
    bcc @mk_wound               ; Damage < HP → wound only

    ; Kill monster — message: "MAGIC DESTROYS MONSTER!"
    ; Save monster type before clearing
    lda MonType,x
    pha
    lda #$00
    sta MonAlive,x
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_FLOOR
    sta DungeonGrid,x
    ; Award gold
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    clc
    adc DungFloor
    clc
    adc #$02                    ; type+1 + floor+1
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda PlayerGold
    clc
    adc DG_Offset
    sta PlayerGold
    SET_A8
    ; Message: "MAGIC DESTROYS MONSTER!"
    SET_XY16
    jsr UiMsgInit
    lda #<str_msg_magkill
    sta UI_TempPtr
    lda #>str_msg_magkill
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    pla                         ; Restore monster type
    tax
    SET_XY16
    jsr UiMsgAppendMonName
    jsr UiMsgShow
    SET_AXY8
    ; Quest check
    ldx DG_MonIdx
    lda MonType,x
    cmp PlayerQuest
    bne @amulet_consume
    lda PlayerQuest
    ora #$80
    sta PlayerQuest
    jmp @amulet_consume

@mk_wound:
    ; Damage but not kill
    sta DG_TempA
    lda MonHP,x
    sec
    sbc DG_TempA
    sta MonHP,x

@amulet_consume:
    ; 25% chance amulet crumbles (PrngNext < 64)
    jsr PrngNext
    cmp #64
    bcs @amulet_done
    dec PlayerAmulet
    lda #<str_msg_crumble
    sta UI_TempPtr
    lda #>str_msg_crumble
    sta UI_TempPtr+1
    jsr UiSetMessage
@amulet_done:
    lda #$01
    sta StatsDirty
    SET_XY16
    jmp @render_exit
.endproc

; ============================================================================
; PlaceMonsters — spawn monsters on the current floor
; Original: type X spawns if X-2 <= floor, 40% chance, random open cell
; HP = (type+1)*2 + (floor+1)*2*difficulty
; ============================================================================
.proc PlaceMonsters
    SET_AXY8

    ; Clear all monster slots
    ldx #$00
@clear:
    stz MonAlive,x
    inx
    cpx #MAX_MONSTERS
    bne @clear

    stz DG_MonIdx

@place_loop:
    ; Check eligibility: type-2 <= floor → type <= floor+2
    lda DG_MonIdx
    sec
    sbc #$02
    bmi @eligible           ; type < 2 → always eligible
    cmp DungFloor
    beq @eligible
    bcc @eligible
    jmp @next_mon           ; type-2 > floor → skip

@eligible:
    ; 40% chance: PrngNext < 102
    jsr PrngNext
    cmp #102
    bcc :+
    jmp @next_mon
:

    ; Find random open cell (try up to 20 times)
    lda #20
    sta DG_TempC
@find_cell:
    SET_XY16
    jsr PrngNext
    sta DG_TempA
    ; Map to 1-9 range: (val % 9) + 1
    lda DG_TempA
    and #$07                ; 0-7
    clc
    adc #$01                ; 1-8 (close enough for 1-9)
    sta DG_TempA            ; row

    jsr PrngNext
    and #$07
    clc
    adc #$01                ; 1-8
    sta DG_TempB            ; col

    ; Check cell is floor
    lda DG_TempA
    jsr CalcDungOffset
    lda DungeonGrid,x
    cmp #DTILE_FLOOR
    bne @retry

    ; Check not player position
    lda DG_TempA
    cmp DungPlayerY
    bne @place_ok
    lda DG_TempB
    cmp DungPlayerX
    beq @retry

@place_ok:
    ; Place monster
    SET_XY8
    ldx DG_MonIdx
    lda #$01
    sta MonAlive,x
    lda DG_TempA
    sta MonY,x
    lda DG_TempB
    sta MonX,x
    lda DG_MonIdx
    sta MonType,x

    ; HP = (type+1)*2 + (floor+1)*2*difficulty
    lda DG_MonIdx
    clc
    adc #$01
    asl                     ; (type+1)*2
    sta DG_TempC

    ; (floor+1) * difficulty via hardware multiply
    lda DungFloor
    clc
    adc #$01
    sta WRMPYA_D
    lda DiffLevel
    sta WRMPYB_D
    nop
    nop
    nop
    nop
    lda RDMPYL_D            ; product low byte
    asl                     ; * 2
    clc
    adc DG_TempC
    ldx DG_MonIdx
    sta MonHP,x

    ; Mark grid
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_MONSTER
    sta DungeonGrid,x
    jmp @next_mon

@retry:
    SET_AXY8
    dec DG_TempC
    beq @next_mon
    jmp @find_cell

@next_mon:
    SET_AXY8
    inc DG_MonIdx
    lda DG_MonIdx
    cmp #MAX_MONSTERS
    beq :+
    jmp @place_loop
:   rts
.endproc

; ============================================================================
; FindMonsterAt — find monster at position DG_TempA (row), DG_TempB (col)
; Returns: X = monster index (8-bit), carry clear if found, set if not
; ============================================================================
.proc FindMonsterAt
    SET_XY8
    ldx #$00
@loop:
    lda MonAlive,x
    beq @next
    lda MonY,x
    cmp DG_TempA
    bne @next
    lda MonX,x
    cmp DG_TempB
    bne @next
    clc                     ; Found
    rts
@next:
    inx
    cpx #MAX_MONSTERS
    bne @loop
    sec                     ; Not found
    rts
.endproc

; ============================================================================
; MonsterAI — move monsters and attack player if adjacent
; Called after player's action each turn
; ============================================================================
.proc MonsterAI
    SET_AXY8

    stz DG_MonIdx

@ai_loop:
    ldx DG_MonIdx
    lda MonAlive,x
    bne :+
    jmp @ai_next
:
    ; Mimic (type 7): don't move
    lda MonType,x
    cmp #$07
    bne :+
    jmp @ai_check_adjacent
:

    ; Calculate direction toward player
    ; DG_TempA = dy direction, DG_TempB = dx direction
    lda MonY,x
    cmp DungPlayerY
    beq @dy_zero
    bcc @dy_pos             ; monY < playerY → move south (+1)
    ; monY > playerY → move north (-1)
    lda #$FF
    sta DG_TempA
    jmp @calc_dx
@dy_pos:
    lda #$01
    sta DG_TempA
    jmp @calc_dx
@dy_zero:
    stz DG_TempA

@calc_dx:
    ldx DG_MonIdx
    lda MonX,x
    cmp DungPlayerX
    beq @dx_zero
    bcc @dx_pos
    lda #$FF
    sta DG_TempB
    jmp @try_move
@dx_pos:
    lda #$01
    sta DG_TempB
    jmp @try_move
@dx_zero:
    stz DG_TempB

@try_move:
    ; Try Y movement first
    lda DG_TempA
    bne :+
    jmp @try_x_move
:   ldx DG_MonIdx
    lda MonY,x
    clc
    adc DG_TempA            ; target Y
    bpl :+
    jmp @try_x_move         ; Out of bounds (negative)
:   cmp #DUNG_H
    bcc :+
    jmp @try_x_move
:
    sta DG_TempC            ; Save target Y
    lda MonX,x
    pha                     ; Save mon X
    sta DG_Offset           ; Use as col
    ; Check target cell
    lda DG_TempC
    sta DG_Offset+1         ; Save target Y
    ; CalcDungOffset expects row in A, col in DG_TempB
    ; But DG_TempB is our dx! Need to use mon's X
    pla                     ; Get mon X back
    sta DG_TempB            ; Set col for CalcDungOffset
    lda DG_TempC            ; target Y as row
    SET_XY16
    jsr CalcDungOffset
    lda DungeonGrid,x
    SET_AXY8
    cmp #DTILE_FLOOR
    bne @try_x_move_restore
    ; Check not player position
    ldx DG_MonIdx
    lda DG_TempC
    cmp DungPlayerY
    bne @do_y_move
    lda MonX,x
    cmp DungPlayerX
    beq @try_x_move_restore ; Would land on player

@do_y_move:
    ; Move monster in Y direction
    ldx DG_MonIdx
    ; Clear old grid cell
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_FLOOR
    sta DungeonGrid,x
    ; Update position
    SET_XY8
    ldx DG_MonIdx
    lda DG_TempC
    sta MonY,x
    ; Mark new grid cell
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_MONSTER
    sta DungeonGrid,x
    SET_AXY8
    jmp @ai_check_adjacent

@try_x_move_restore:
    ; Restore DG_TempB to dx (was clobbered by CalcDungOffset usage)
    ; Actually we lost dx info. Try X movement with recalculated dx.
    ldx DG_MonIdx
    lda MonX,x
    cmp DungPlayerX
    bne :+
    jmp @ai_check_adjacent
:   bcc @recalc_dx_pos
    lda #$FF
    sta DG_TempB
    jmp @do_x_check
@recalc_dx_pos:
    lda #$01
    sta DG_TempB
    jmp @do_x_check

@try_x_move:
    lda DG_TempB
    bne :+
    jmp @ai_check_adjacent
:
@do_x_check:
    ldx DG_MonIdx
    lda MonX,x
    clc
    adc DG_TempB            ; target X
    bpl :+
    jmp @ai_check_adjacent
:   cmp #DUNG_W
    bcc :+
    jmp @ai_check_adjacent
:   sta DG_TempC            ; Save target X

    ; Check target cell
    lda MonY,x
    sta DG_TempA
    lda DG_TempC
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda DungeonGrid,x
    SET_AXY8
    cmp #DTILE_FLOOR
    beq :+
    jmp @ai_check_adjacent
:   ; Check not player position
    ldx DG_MonIdx
    lda MonY,x
    cmp DungPlayerY
    bne @do_x_move
    lda DG_TempC
    cmp DungPlayerX
    bne @do_x_move
    jmp @ai_check_adjacent

@do_x_move:
    ; Clear old grid cell
    ldx DG_MonIdx
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_FLOOR
    sta DungeonGrid,x
    ; Update position
    SET_XY8
    ldx DG_MonIdx
    lda DG_TempC
    sta MonX,x
    ; Mark new grid cell
    lda MonY,x
    sta DG_TempA
    lda MonX,x
    sta DG_TempB
    SET_XY16
    lda DG_TempA
    jsr CalcDungOffset
    lda #DTILE_MONSTER
    sta DungeonGrid,x
    SET_AXY8

@ai_check_adjacent:
    ; Check if monster is adjacent to player (distance = 1 in any cardinal dir)
    SET_AXY8
    ldx DG_MonIdx
    lda MonAlive,x
    bne :+
    jmp @ai_next
:
    ; Check if |monY - playerY| + |monX - playerX| == 1
    lda MonY,x
    sec
    sbc DungPlayerY
    bpl :+
    eor #$FF
    clc
    adc #$01                ; abs(dy)
:   sta DG_TempA            ; |dy|
    lda MonX,x
    sec
    sbc DungPlayerX
    bpl :+
    eor #$FF
    clc
    adc #$01                ; abs(dx)
:   clc
    adc DG_TempA            ; Manhattan distance
    cmp #$01
    beq :+
    jmp @ai_next
:

    ; Adjacent! Monster attacks player.
    ; Thief (type 1): 50% steal random item
    ldx DG_MonIdx
    lda MonType,x
    cmp #$01
    beq :+
    jmp @not_thief
:
    jsr PrngNext
    and #$01
    bne :+
    jmp @mon_normal_attack
:   ; Steal a random item (try to find one the player has)
    jsr PrngNext
    and #$03                ; 0-3 → rapier, axe, shield, bow
    beq @steal_rapier
    cmp #$01
    beq @steal_axe
    cmp #$02
    beq @steal_shield
    ; 3 = bow
    lda PlayerBow
    bne :+
    jmp @mon_normal_attack
:
    dec PlayerBow
    lda #<str_msg_bow
    sta DG_TempA
    lda #>str_msg_bow
    sta DG_TempC
    jmp @steal_msg
@steal_rapier:
    lda PlayerRapier
    bne :+
    jmp @mon_normal_attack
:   dec PlayerRapier
    lda #<str_msg_rapier
    sta DG_TempA
    lda #>str_msg_rapier
    sta DG_TempC
    jmp @steal_msg
@steal_axe:
    lda PlayerAxe
    bne :+
    jmp @mon_normal_attack
:   dec PlayerAxe
    lda #<str_msg_axe
    sta DG_TempA
    lda #>str_msg_axe
    sta DG_TempC
    jmp @steal_msg
@steal_shield:
    lda PlayerShield
    bne :+
    jmp @mon_normal_attack
:   dec PlayerShield
    lda #<str_msg_shield
    sta DG_TempA
    lda #>str_msg_shield
    sta DG_TempC
@steal_msg:
    ; Compose "THIEF STOLE ITEM!"
    jsr UiMsgInit
    lda #<str_msg_thief
    sta UI_TempPtr
    lda #>str_msg_thief
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    lda DG_TempA
    sta UI_TempPtr
    lda DG_TempC
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    jsr UiMsgShow
    lda #$01
    sta StatsDirty
    jmp @ai_next

@not_thief:
    ; Gremlin (type 6): 50% eat half food
    cmp #$06
    bne @mon_normal_attack
    jsr PrngNext
    and #$01
    beq @mon_normal_attack
    SET_A16
    lda PlayerFood
    lsr                     ; / 2
    sta PlayerFood
    SET_A8
    ; Message: "GREMLIN ATE YOUR FOOD!"
    lda #<str_msg_gremlin
    sta UI_TempPtr
    lda #>str_msg_gremlin
    sta UI_TempPtr+1
    jsr UiSetMessage
    lda #$01
    sta StatsDirty
    jmp @ai_next

@mon_normal_attack:
    ; Hit check: PrngNext < (type+1)*8
    jsr PrngNext
    sta DG_TempC
    ldx DG_MonIdx
    lda MonType,x
    clc
    adc #$01                ; type+1
    asl
    asl
    asl                     ; (type+1)*8
    cmp DG_TempC
    bcs :+                  ; Hit → continue
    jmp @mon_miss           ; Miss
:

    ; Hit! Damage = PrngNext & (type+1) + 1
    jsr PrngNext
    ldx DG_MonIdx
    and MonType,x           ; PrngNext & type
    clc
    adc #$01                ; + 1
    clc
    adc DungFloor           ; + floor
    ; Apply to player HP
    sta DG_TempC
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda PlayerHP
    sec
    sbc DG_Offset
    bcs :+
    lda #$0000
:   sta PlayerHP
    SET_A8
    ; SFX: monster hit player
    lda #SFX_HURT
    jsr PlaySfx
    jsr PalFxFlash
    ; Message: "MONSTER HITS! N DMG"
    SET_XY16
    jsr UiMsgInit
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    tax
    SET_XY16
    jsr UiMsgAppendMonName
    lda #<str_msg_mon_hit
    sta UI_TempPtr
    lda #>str_msg_mon_hit
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    SET_AXY8
    lda DG_TempC
    SET_XY16
    jsr UiMsgAppendNum
    lda #<str_msg_dmg
    sta UI_TempPtr
    lda #>str_msg_dmg
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    jsr UiMsgShow
    SET_AXY8
    lda #$01
    sta StatsDirty

    ; Check player death
    SET_A16
    lda PlayerHP
    SET_A8
    bne @ai_next
    ; Player died!
    lda #<str_msg_died
    sta UI_TempPtr
    lda #>str_msg_died
    sta UI_TempPtr+1
    jsr UiSetMessage
    lda #STATE_GAMEOVER
    sta GameState
    jmp @ai_next

@mon_miss:
    ; Message: "MONSTER MISSES!"
    SET_XY16
    jsr UiMsgInit
    SET_XY8
    ldx DG_MonIdx
    lda MonType,x
    tax
    SET_XY16
    jsr UiMsgAppendMonName
    lda #<str_msg_mon_miss
    sta UI_TempPtr
    lda #>str_msg_mon_miss
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    jsr UiMsgShow
    SET_AXY8

@ai_next:
    SET_AXY8
    inc DG_MonIdx
    lda DG_MonIdx
    cmp #MAX_MONSTERS
    beq @ai_done
    jmp @ai_loop
@ai_done:
    rts
.endproc

; ============================================================================
; DungeonRender — build first-person view in TilemapBuffer
; Simple corridor view: check cells ahead at depths 1-4
; Uses dungeon tile graphics for walls/floor/features
; ============================================================================
.proc DungeonRender
    SET_AXY16

    ; Clear tilemap to floor tile
    ldx #$0000
    lda #DGTILE_EMPTY       ; Dark/empty background
@clear:
    sta TilemapBuffer,x
    inx
    inx
    cpx #2048
    bne @clear

    SET_AXY8
    SET_XY16

    ; --- Draw walls based on what's ahead ---
    ; Check depths 1-4 in facing direction
    ; For each depth, check center, left, right cells

    ; Depth 1 (closest): draw back wall if blocked
    lda DungPlayerY
    sta DG_TempA
    lda DungPlayerX
    sta DG_TempB

    ; Step forward once
    jsr StepForward
    ; Check if valid and wall
    jsr CheckCell
    cmp #DTILE_WALL
    beq @draw_close_wall

    ; Depth 1 is open — check for features at this cell
    cmp #DTILE_STAIRS_UP
    beq @draw_stairs_d1
    cmp #DTILE_STAIRS_DN
    beq @draw_stairs_d1
    cmp #DTILE_CHEST
    beq @draw_chest_d1
    cmp #DTILE_DOOR
    beq @draw_door_d1
    cmp #DTILE_MONSTER
    beq @draw_monster_d1

    ; Check left wall at depth 1
    jsr CheckLeftWall
    cmp #DTILE_WALL
    bne @no_left_d1
    jsr DrawLeftWallD1
@no_left_d1:
    jsr CheckRightWall
    cmp #DTILE_WALL
    bne @no_right_d1
    jsr DrawRightWallD1
@no_right_d1:

    ; Step forward again (depth 2)
    jsr StepForward
    jsr CheckCell
    cmp #DTILE_WALL
    beq @draw_mid_wall
    ; Depth 2 open — check features
    cmp #DTILE_STAIRS_UP
    beq @draw_stairs_d2
    cmp #DTILE_STAIRS_DN
    beq @draw_stairs_d2
    cmp #DTILE_MONSTER
    beq @draw_monster_d2

    ; Check side walls at depth 2
    jsr CheckLeftWall
    cmp #DTILE_WALL
    bne @no_left_d2
    jsr DrawLeftWallD2
@no_left_d2:
    jsr CheckRightWall
    cmp #DTILE_WALL
    bne @no_right_d2
    jsr DrawRightWallD2
@no_right_d2:

    ; Depth 3
    jsr StepForward
    jsr CheckCell
    cmp #DTILE_WALL
    beq @draw_far_wall
    jmp @render_done

@draw_close_wall:
    ; Full-width wall at rows 4-24, cols 2-29
    jsr DrawBackWallClose
    jmp @render_done

@draw_mid_wall:
    ; Medium wall at rows 6-22, cols 6-25
    jsr DrawBackWallMid
    jmp @render_done

@draw_far_wall:
    ; Small wall at rows 8-20, cols 10-21
    jsr DrawBackWallFar
    jmp @render_done

@draw_stairs_d1:
    jsr DrawStairsD1
    jmp @render_done
@draw_stairs_d2:
    jsr DrawStairsD2
    jmp @render_done
@draw_chest_d1:
    jsr DrawChestD1
    jmp @render_done
@draw_door_d1:
    jsr DrawDoorD1
    jmp @render_done
@draw_monster_d1:
    jsr FindMonsterAt
    bcs @d1_default
    SET_XY8
    lda MonType,x
    SET_XY16
    clc
    adc #DGTILE_MONSTER_BASE
    sta DG_TempC
    jmp @d1_draw
@d1_default:
    lda #DGTILE_MONSTER_BASE
    sta DG_TempC
@d1_draw:
    jsr DrawMonsterD1
    jmp @render_done
@draw_monster_d2:
    jsr FindMonsterAt
    bcs @d2_default
    SET_XY8
    lda MonType,x
    SET_XY16
    clc
    adc #DGTILE_MONSTER_BASE
    sta DG_TempC
    jmp @d2_draw
@d2_default:
    lda #DGTILE_MONSTER_BASE
    sta DG_TempC
@d2_draw:
    jsr DrawMonsterD2
    jmp @render_done

@render_done:
    rts
.endproc

; ============================================================================
; StepForward — advance DG_TempA/B one step in DungFacing direction
; ============================================================================
.proc StepForward
    SET_A8
    lda DungFacing
    cmp #FACE_NORTH
    beq @north
    cmp #FACE_SOUTH
    beq @south
    cmp #FACE_EAST
    beq @east
    ; west
    dec DG_TempB
    rts
@north:
    dec DG_TempA
    rts
@south:
    inc DG_TempA
    rts
@east:
    inc DG_TempB
    rts
.endproc

; ============================================================================
; CheckCell — get tile at DG_TempA, DG_TempB. Returns tile in A.
; If out of bounds, returns DTILE_WALL.
; ============================================================================
.proc CheckCell
    SET_A8
    lda DG_TempA
    bmi @wall               ; Negative = out of bounds
    cmp #DUNG_H
    bcs @wall
    lda DG_TempB
    bmi @wall
    cmp #DUNG_W
    bcs @wall
    ; In bounds
    lda DG_TempA
    jsr CalcDungOffset
    lda DungeonGrid,x
    rts
@wall:
    lda #DTILE_WALL
    rts
.endproc

; ============================================================================
; CheckLeftWall / CheckRightWall — check cell to the left/right of current pos
; relative to facing. Returns tile in A.
; ============================================================================
.proc CheckLeftWall
    ; Check cell to the left of current DG_TempA/B relative to facing
    ; Save pos
    lda DG_TempA
    pha
    lda DG_TempB
    pha
    ; Step left = rotate facing -1, step, then restore facing
    lda DungFacing
    pha                     ; Save original facing
    dec a
    and #$03
    sta DungFacing
    jsr StepForward         ; Step in the left direction
    pla
    sta DungFacing          ; Restore facing
    jsr CheckCell           ; A = tile at left cell
    pha                     ; Save result
    pla
    sta DG_Offset           ; Temp save result
    ; Restore position
    pla
    sta DG_TempB
    pla
    sta DG_TempA
    lda DG_Offset           ; Return tile
    rts
.endproc

.proc CheckRightWall
    ; Check cell to the right of current DG_TempA/B relative to facing
    lda DG_TempA
    pha
    lda DG_TempB
    pha
    lda DungFacing
    pha
    inc a
    and #$03
    sta DungFacing
    jsr StepForward
    pla
    sta DungFacing
    jsr CheckCell
    sta DG_Offset
    pla
    sta DG_TempB
    pla
    sta DG_TempA
    lda DG_Offset
    rts
.endproc

; ============================================================================
; Wall drawing functions — write wall tiles to tilemap regions
; ============================================================================

; Helper: write a tile at tilemap position (row, col)
; Input: DG_TempA=row, DG_TempB=col on entry are NOT used here.
; Instead we take row in Y register, col in X register (both 8-bit values),
; tile in A. Clobbers DG_Offset.
.proc WriteTile
    phx                     ; Save col (16-bit X)
    pha                     ; Save tile
    ; Byte offset = (row * 32 + col) * 2
    stz DG_Offset+1
    tya
    sta DG_Offset
    SET_A16
    lda DG_Offset
    asl
    asl
    asl
    asl
    asl                     ; * 32
    sta DG_Offset
    SET_A8
    txa
    SET_A16
    and #$00FF
    clc
    adc DG_Offset
    asl                     ; * 2
    tax
    SET_A8
    pla                     ; Restore tile
    sta TilemapBuffer,x
    ; Look up palette attribute for this dungeon tile
    pha                     ; Save tile again
    phx                     ; Save tilemap offset (16-bit)
    SET_XY8
    tax                     ; X = tile index
    lda DungTilePalette,x   ; A = palette attribute
    sta DG_Offset           ; Temp store
    SET_XY16
    plx                     ; Restore tilemap offset
    lda DG_Offset
    sta TilemapBuffer+1,x
    pla                     ; Balance stack (tile)
    plx                     ; Restore col
    rts
.endproc

; DrawBackWallClose: wireframe outline (depth 1)
; Rows 4-23, cols 2-29
.proc DrawBackWallClose
    SET_A8
    SET_XY16
    ; Top edge: row 4, cols 2-29
    ldy #4
    ldx #2
@top:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #30
    bne @top
    ; Bottom edge: row 23, cols 2-29
    ldy #23
    ldx #2
@bot:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #30
    bne @bot
    ; Left edge: rows 5-22, col 2
    ldy #5
@left:
    ldx #2
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #23
    bne @left
    ; Right edge: rows 5-22, col 29
    ldy #5
@right:
    ldx #29
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #23
    bne @right
    rts
.endproc

; DrawBackWallMid: wireframe outline (depth 2)
; Rows 6-21, cols 6-25
.proc DrawBackWallMid
    SET_A8
    SET_XY16
    ; Top edge
    ldy #6
    ldx #6
@top:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #26
    bne @top
    ; Bottom edge
    ldy #21
    ldx #6
@bot:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #26
    bne @bot
    ; Left edge
    ldy #7
@left:
    ldx #6
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #21
    bne @left
    ; Right edge
    ldy #7
@right:
    ldx #25
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #21
    bne @right
    rts
.endproc

; DrawBackWallFar: wireframe outline (depth 3)
; Rows 8-19, cols 10-21
.proc DrawBackWallFar
    SET_A8
    SET_XY16
    ; Top edge
    ldy #8
    ldx #10
@top:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #22
    bne @top
    ; Bottom edge
    ldy #19
    ldx #10
@bot:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #22
    bne @bot
    ; Left edge
    ldy #9
@left:
    ldx #10
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #19
    bne @left
    ; Right edge
    ldy #9
@right:
    ldx #21
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #19
    bne @right
    rts
.endproc

; DrawLeftWallD1: left wall line at depth 1 (col 2, rows 4-23)
.proc DrawLeftWallD1
    SET_A8
    SET_XY16
    ldy #4
@row:
    ldx #2
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #24
    bne @row
    rts
.endproc

; DrawRightWallD1: right wall line at depth 1 (col 29, rows 4-23)
.proc DrawRightWallD1
    SET_A8
    SET_XY16
    ldy #4
@row:
    ldx #29
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #24
    bne @row
    rts
.endproc

; DrawLeftWallD2: left wall line at depth 2 (col 6, rows 6-21)
.proc DrawLeftWallD2
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #6
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #22
    bne @row
    rts
.endproc

; DrawRightWallD2: right wall line at depth 2 (col 25, rows 6-21)
.proc DrawRightWallD2
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #25
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #22
    bne @row
    rts
.endproc

; Feature drawing at depth 1 (center of view)
.proc DrawStairsD1
    SET_A8
    SET_XY16
    ldy #12
@row:
    ldx #13
@col:
    lda #DGTILE_STAIRS
    jsr WriteTile
    inx
    cpx #19
    bne @col
    iny
    cpy #18
    bne @row
    rts
.endproc

.proc DrawStairsD2
    SET_A8
    SET_XY16
    ldy #11
@row:
    ldx #14
@col:
    lda #DGTILE_STAIRS
    jsr WriteTile
    inx
    cpx #18
    bne @col
    iny
    cpy #15
    bne @row
    rts
.endproc

.proc DrawChestD1
    SET_A8
    SET_XY16
    ldy #14
@row:
    ldx #14
@col:
    lda #DGTILE_CHEST
    jsr WriteTile
    inx
    cpx #18
    bne @col
    iny
    cpy #18
    bne @row
    rts
.endproc

.proc DrawDoorD1
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #12
@col:
    lda #DGTILE_DOOR
    jsr WriteTile
    inx
    cpx #20
    bne @col
    iny
    cpy #22
    bne @row
    rts
.endproc

; DrawMonsterD1: monster figure at depth 1 (center, 6x6 tiles)
.proc DrawMonsterD1
    SET_A8
    SET_XY16
    ldy #10
@row:
    ldx #13
@col:
    lda DG_TempC
    jsr WriteTile
    inx
    cpx #19
    bne @col
    iny
    cpy #20
    bne @row
    rts
.endproc

; DrawMonsterD2: monster figure at depth 2 (smaller, 4x4 tiles)
.proc DrawMonsterD2
    SET_A8
    SET_XY16
    ldy #11
@row:
    ldx #14
@col:
    lda DG_TempC
    jsr WriteTile
    inx
    cpx #18
    bne @col
    iny
    cpy #17
    bne @row
    rts
.endproc

; ============================================================================
; RODATA
; ============================================================================

.segment "RODATA"

; Dungeon tile palette attributes — indexed by tile number ($00-$11)
; Palette: 0=white($00), 1=brown($04), 2=yellow($08), 3=red($0C)
DungTilePalette:
    ;       floor  wall   wallhi door   flpat  stairs chest  wedge
    .byte   $00,   $00,   $00,   $04,   $00,   $08,   $08,   $00
    ;       skele  thief  rat    orc    viper  carrion gremln mimic
    .byte   $0C,   $0C,   $0C,   $0C,   $0C,   $0C,   $0C,   $0C
    ;       daemon balrog
    .byte   $0C,   $0C
