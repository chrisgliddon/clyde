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

DUNG_W          = 10
DUNG_H          = 10
DUNG_SIZE       = DUNG_W * DUNG_H   ; 100 bytes per floor
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
    ; offset = row * 10 + col
    ; row * 10 = row * 8 + row * 2
    sta DG_TempA
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda DG_Offset
    and #$00FF
    asl                     ; *2
    sta DG_Offset
    asl
    asl                     ; *8
    clc
    adc DG_Offset            ; *10
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
; GenerateFloor — procedural generation seeded by floor number
; Perimeter walls, carve interior, place features
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

    ; Fill with walls
    ldx #$0000
    lda #DTILE_WALL
@fill:
    sta DungeonGrid,x
    inx
    cpx #DUNG_SIZE
    bne @fill

    ; Carve interior (rows 1-8, cols 1-8)
    lda #$01
    sta DG_TempA            ; row
@row:
    lda #$01
    sta DG_TempB            ; col
@col:
    jsr PrngNext
    and #$03
    beq @keep_wall          ; 25% chance to keep wall

    ; Carve floor
    lda DG_TempA            ; row
    jsr CalcDungOffset      ; X = row*10 + col
    lda #DTILE_FLOOR
    sta DungeonGrid,x

@keep_wall:
    inc DG_TempB
    lda DG_TempB
    cmp #DUNG_W - 1         ; cols 1..8
    bne @col

    inc DG_TempA
    lda DG_TempA
    cmp #DUNG_H - 1         ; rows 1..8
    bne @row

    ; --- Place stairs up at (1,1) ---
    lda #DTILE_STAIRS_UP
    sta DungeonGrid + 1 * DUNG_W + 1
    ; Also ensure path around stairs is open
    lda #DTILE_FLOOR
    sta DungeonGrid + 1 * DUNG_W + 2
    sta DungeonGrid + 2 * DUNG_W + 1

    ; --- Place stairs down ---
    ; Even floors: stairs down at (8,8). Odd: (8,2).
    lda DungFloor
    and #$01
    bne @odd_stairs
    lda #DTILE_STAIRS_DN
    sta DungeonGrid + 8 * DUNG_W + 8
    lda #DTILE_FLOOR
    sta DungeonGrid + 7 * DUNG_W + 8
    sta DungeonGrid + 8 * DUNG_W + 7
    jmp @place_features
@odd_stairs:
    lda #DTILE_STAIRS_DN
    sta DungeonGrid + 8 * DUNG_W + 2
    lda #DTILE_FLOOR
    sta DungeonGrid + 7 * DUNG_W + 2
    sta DungeonGrid + 8 * DUNG_W + 3

@place_features:
    ; Scatter traps, chests, and open some doors
    ldy #$00                ; feature counter
@feat_loop:
    jsr PrngNext
    and #$7F                ; 0-127 → offset into grid
    cmp #DUNG_SIZE
    bcs @feat_skip          ; Out of range

    tax
    lda DungeonGrid,x
    cmp #DTILE_FLOOR
    bne @feat_skip          ; Only place on floor tiles

    jsr PrngNext
    and #$07                ; 0-7
    cmp #$03
    bcc @place_trap         ; 0-2: trap (37%)
    cmp #$05
    bcc @place_chest        ; 3-4: chest (25%)
    jmp @feat_skip          ; 5-7: leave as floor

@place_trap:
    lda #DTILE_TRAP
    sta DungeonGrid,x
    jmp @feat_skip
@place_chest:
    lda #DTILE_CHEST
    sta DungeonGrid,x

@feat_skip:
    iny
    cpy #12                 ; Place up to 12 features
    bne @feat_loop

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
    ; Damage player: 5-20 HP
    lda #DTILE_FLOOR
    sta DungeonGrid,x       ; Remove trap
    jsr PrngNext
    and #$0F                ; 0-15
    clc
    adc #$05                ; 5-20
    sta DG_Offset
    stz DG_Offset+1
    SET_A16
    lda PlayerHP
    sec
    sbc DG_Offset
    bcs :+
    lda #$0000
:   sta PlayerHP
    SET_A8
    jmp @render_exit

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
    ; Place player at stairs down of previous floor
    lda DungFloor
    and #$01
    bne @up_odd
    lda #$08
    sta DungPlayerX
    sta DungPlayerY
    jmp @render_exit
@up_odd:
    lda #$02
    sta DungPlayerX
    lda #$08
    sta DungPlayerY
    jmp @render_exit

@go_down:
    lda DungFloor
    cmp #MAX_FLOORS - 1
    beq @render_exit        ; Can't go deeper
    inc DungFloor
    jsr GenerateFloor
    ; Place at stairs up
    lda #$01
    sta DungPlayerX
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
    beq @go_up
    cmp #DTILE_STAIRS_DN
    beq @go_down
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

    ; Draw floor pattern on bottom half (rows 16-27)
    lda #16
    sta DG_TempA            ; Start row
@floor_row:
    lda #4                  ; Left edge of corridor
    sta DG_TempB
@floor_col:
    ; Tilemap byte offset = (row*32 + col) * 2
    lda DG_TempA
    stz DG_Offset+1
    sta DG_Offset
    SET_A16
    lda DG_Offset
    asl
    asl
    asl
    asl
    asl                     ; *32
    sta DG_Offset
    SET_A8
    lda DG_TempB
    SET_A16
    and #$00FF
    clc
    adc DG_Offset
    asl
    tax
    SET_A8
    lda #DGTILE_FLOOR       ; Floor pattern tile
    sta TilemapBuffer,x
    stz TilemapBuffer+1,x

    inc DG_TempB
    lda DG_TempB
    cmp #28                 ; Right edge
    bne @floor_col

    inc DG_TempA
    lda DG_TempA
    cmp #28
    bne @floor_row

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

; DrawBackWallClose: full-width back wall (depth 1)
; Rows 4-23, cols 2-29
.proc DrawBackWallClose
    SET_A8
    SET_XY16
    ldy #4                  ; Start row
@row:
    ldx #2                  ; Start col
@col:
    lda #DGTILE_WALL
    jsr WriteTile
    inx
    cpx #30
    bne @col
    iny
    cpy #24
    bne @row
    rts
.endproc

; DrawBackWallMid: medium back wall (depth 2)
; Rows 6-21, cols 6-25
.proc DrawBackWallMid
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #6
@col:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #26
    bne @col
    iny
    cpy #22
    bne @row
    rts
.endproc

; DrawBackWallFar: small back wall (depth 3)
; Rows 8-19, cols 10-21
.proc DrawBackWallFar
    SET_A8
    SET_XY16
    ldy #8
@row:
    ldx #10
@col:
    lda #DGTILE_WALLHI
    jsr WriteTile
    inx
    cpx #22
    bne @col
    iny
    cpy #20
    bne @row
    rts
.endproc

; DrawLeftWallD1: left wall strip at depth 1 (cols 2-3, rows 4-23)
.proc DrawLeftWallD1
    SET_A8
    SET_XY16
    ldy #4
@row:
    ldx #2
    lda #DGTILE_WALL
    jsr WriteTile
    ldx #3
    lda #DGTILE_WALL
    jsr WriteTile
    iny
    cpy #24
    bne @row
    rts
.endproc

; DrawRightWallD1: right wall strip at depth 1 (cols 28-29, rows 4-23)
.proc DrawRightWallD1
    SET_A8
    SET_XY16
    ldy #4
@row:
    ldx #28
    lda #DGTILE_WALL
    jsr WriteTile
    ldx #29
    lda #DGTILE_WALL
    jsr WriteTile
    iny
    cpy #24
    bne @row
    rts
.endproc

; DrawLeftWallD2: left wall at depth 2 (cols 6-7, rows 6-21)
.proc DrawLeftWallD2
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #6
    lda #DGTILE_WALLHI
    jsr WriteTile
    ldx #7
    lda #DGTILE_WALLHI
    jsr WriteTile
    iny
    cpy #22
    bne @row
    rts
.endproc

; DrawRightWallD2: right wall at depth 2 (cols 24-25, rows 6-21)
.proc DrawRightWallD2
    SET_A8
    SET_XY16
    ldy #6
@row:
    ldx #24
    lda #DGTILE_WALLHI
    jsr WriteTile
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
