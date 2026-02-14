; dungeon.s — Akalabeth dungeon system
; 10x10 grid per floor, first-person view, navigation, traps, chests, stairs

.include "macros.s"

.export DungeonInit, DungeonUpdate, DungeonRender

.importzp JoyPress, GameState, MapDirty
.importzp PlayerHP, PlayerFood, PlayerGold
.import JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT, JOY_B
.import TilemapBuffer, GfxUploadDungeon, GfxUploadOverworld

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

; Dungeon gfx tile indices (matching gfx.s DungeonTiles order)
DGTILE_EMPTY    = $00       ; Black/floor
DGTILE_WALL     = $01       ; Brick wall
DGTILE_WALLHI   = $02       ; Light wall
DGTILE_DOOR     = $03       ; Door arch
DGTILE_FLOOR    = $04       ; Floor pattern
DGTILE_STAIRS   = $05       ; Stairs
DGTILE_CHEST    = $06       ; Chest

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

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
DungeonGrid:    .res DUNG_SIZE

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

    jsr GenerateFloor
    jsr GfxUploadDungeon
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
    bit #JOY_B
    bne @do_stairs
    SET_A8
    rts

@do_stairs:
    SET_A8
    jmp @use_stairs

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
    beq @go_up
    cmp #DTILE_STAIRS_DN
    beq @go_down
    cmp #DTILE_CHEST
    beq @open_chest
    cmp #DTILE_TRAP
    beq @hit_trap
    jmp @render_exit

@hit_trap:
    ; Original: trap drops player to next dungeon level
    lda #DTILE_FLOOR
    sta DungeonGrid,x       ; Remove trap
    lda DungFloor
    cmp #MAX_FLOORS - 1
    bne :+
    jmp @render_exit        ; Can't go deeper
:   inc DungFloor
    jsr GenerateFloor
    jmp @place_at_up_stairs

@open_chest:
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
    jmp @render_exit

@go_up:
    lda DungFloor
    beq @exit_dungeon       ; Floor 0 stairs up = exit
    dec DungFloor
    jsr GenerateFloor
    ; Place player at down-stairs of new (upper) floor
    jmp @place_at_dn_stairs

@go_down:
    lda DungFloor
    cmp #MAX_FLOORS - 1
    beq @render_exit        ; Can't go deeper
    inc DungFloor
    jsr GenerateFloor
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
    jsr GfxUploadOverworld
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    rts

@blocked:
@render_exit:
    jsr DungeonRender
    lda #$01
    sta MapDirty
    rts

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
    stz TilemapBuffer+1,x
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
