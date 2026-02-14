; overworld.s — Akalabeth overworld system
; 20x20 tile grid, player movement, BG1 rendering

.include "macros.s"

.export OverworldInit, OverworldUpdate, OverworldRender
.export TilemapBuffer
.exportzp PlayerX, PlayerY, MapDirty

.importzp JoyPress, GameState, ShopCursor
.importzp PlayerFood, PlayerHP
.import JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT
.import DungeonInit

; ============================================================================
; Constants
; ============================================================================

MAP_W           = 20
MAP_H           = 20
MAP_SIZE        = MAP_W * MAP_H     ; 400 bytes

TILE_GRASS      = $00
TILE_MOUNTAIN   = $01
TILE_WATER      = $02
TILE_TOWN       = $03
TILE_CASTLE     = $04
TILE_DUNGEON    = $05
TILE_FOREST     = $06
TILE_PLAYER     = $07

STATE_OVERWORLD = $01
STATE_DUNGEON   = $02
STATE_SHOP      = $04
STATE_CASTLE    = $05

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
PlayerX:        .res 1
PlayerY:        .res 1
MapDirty:       .res 1
OW_TempA:       .res 1      ; Candidate Y / general temp
OW_TempB:       .res 1      ; Candidate X / general temp
OW_Offset:      .res 2      ; 16-bit calculated offset

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
OverworldMap:   .res MAP_SIZE   ; 400 bytes
TilemapBuffer:  .res 2048       ; 32x32 tilemap (16-bit entries)

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; CalcMapOffset — compute 16-bit map offset from Y-pos in A, X-pos in OW_TempB
; Result in X (16-bit). Clobbers A. Assumes 8-bit A on entry.
; ============================================================================
.proc CalcMapOffset
    ; A (8-bit) = Y position. OW_TempB = X position.
    ; Returns: X (16-bit) = Y*20 + X.  Clobbers A, OW_Offset.
    ; Assumes 8-bit A, 16-bit XY on entry. Returns same.
    stz OW_Offset+1
    sta OW_Offset
    SET_A16
    lda OW_Offset
    asl
    asl
    sta OW_Offset            ; Y*4
    asl
    asl                     ; Y*16
    clc
    adc OW_Offset            ; Y*20
    sta OW_Offset
    SET_A8
    lda OW_TempB
    SET_A16
    and #$00FF
    clc
    adc OW_Offset
    tax
    SET_A8
    rts
.endproc

; ============================================================================
; OverworldInit — generate map, place player
; ============================================================================
.proc OverworldInit
    SET_AXY8

    ; Place player next to castle
    lda #(MAP_W / 2) - 1
    sta PlayerX
    lda #MAP_H / 2
    sta PlayerY

    ; Fill map with grass (8-bit loop, one byte at a time)
    SET_XY16
    ldx #$0000
    lda #TILE_GRASS
@fill:
    sta OverworldMap,x
    inx
    cpx #MAP_SIZE
    bne @fill

    ; Border = mountains (top and bottom rows)
    ldx #$0000
@border_tb:
    lda #TILE_MOUNTAIN
    sta OverworldMap,x                      ; Top row
    sta OverworldMap + (MAP_H-1)*MAP_W,x    ; Bottom row
    inx
    cpx #MAP_W
    bne @border_tb

    ; Left and right columns
    ldx #$0000
@border_lr:
    lda #TILE_MOUNTAIN
    sta OverworldMap,x                      ; Left
    sta OverworldMap + (MAP_W - 1),x        ; Right
    ; X += MAP_W (16-bit)
    SET_A16
    txa
    clc
    adc #MAP_W
    tax
    SET_A8
    cpx #MAP_SIZE
    bcc @border_lr

    ; Place features
    lda #TILE_CASTLE
    sta OverworldMap + 10 * MAP_W + 10

    lda #TILE_TOWN
    sta OverworldMap + 3 * MAP_W + 5
    sta OverworldMap + 14 * MAP_W + 3

    lda #TILE_DUNGEON
    sta OverworldMap + 6 * MAP_W + 15
    sta OverworldMap + 15 * MAP_W + 12

    lda #TILE_MOUNTAIN
    sta OverworldMap + 7 * MAP_W + 8
    sta OverworldMap + 7 * MAP_W + 9
    sta OverworldMap + 8 * MAP_W + 8
    sta OverworldMap + 4 * MAP_W + 12
    sta OverworldMap + 5 * MAP_W + 12

    lda #TILE_WATER
    sta OverworldMap + 11 * MAP_W + 4
    sta OverworldMap + 11 * MAP_W + 5
    sta OverworldMap + 12 * MAP_W + 4
    sta OverworldMap + 12 * MAP_W + 5

    lda #TILE_FOREST
    sta OverworldMap + 3 * MAP_W + 15
    sta OverworldMap + 3 * MAP_W + 16
    sta OverworldMap + 9 * MAP_W + 3
    sta OverworldMap + 9 * MAP_W + 4

    lda #$01
    sta MapDirty

    rts
.endproc

; ============================================================================
; OverworldUpdate — handle D-pad movement, collision, food
; ============================================================================
.proc OverworldUpdate
    SET_AXY8
    SET_XY16

    ; 16-bit joypad test
    SET_A16
    lda JoyPress
    bit #JOY_UP
    bne @move_up
    bit #JOY_DOWN
    bne @move_down
    bit #JOY_LEFT
    bne @move_left
    bit #JOY_RIGHT
    bne @move_right
    SET_A8
    rts

@move_up:
    SET_A8
    lda PlayerY
    beq @ret
    dec a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_down:
    SET_A8
    lda PlayerY
    cmp #MAP_H - 1
    beq @ret
    inc a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_left:
    SET_A8
    lda PlayerX
    beq @ret
    lda PlayerY
    sta OW_TempA
    lda PlayerX
    dec a
    sta OW_TempB
    jmp @try_move

@move_right:
    SET_A8
    lda PlayerX
    cmp #MAP_W - 1
    beq @ret
    lda PlayerY
    sta OW_TempA
    lda PlayerX
    inc a
    sta OW_TempB
    jmp @try_move

@ret:
    rts

@try_move:
    ; Calculate map offset (16-bit X) for candidate position
    lda OW_TempA            ; Y position
    jsr CalcMapOffset       ; X = Y*20 + OW_TempB

    lda OverworldMap,x      ; Tile at candidate pos

    cmp #TILE_MOUNTAIN
    beq @blocked
    cmp #TILE_WATER
    beq @blocked

    ; Accept move
    lda OW_TempA
    sta PlayerY
    lda OW_TempB
    sta PlayerX
    lda #$01
    sta MapDirty

    ; Consume food
    SET_A16
    lda PlayerFood
    beq @no_food
    dec a
    sta PlayerFood
    SET_A8
    jmp @check_tile

@no_food:
    lda PlayerHP
    beq @starve
    dec a
    sta PlayerHP
@starve:
    SET_A8

@check_tile:
    ; Get tile at new position
    lda OW_TempA
    jsr CalcMapOffset

    lda OverworldMap,x
    cmp #TILE_DUNGEON
    beq @enter_dungeon
    cmp #TILE_CASTLE
    beq @enter_castle
    cmp #TILE_TOWN
    beq @enter_town
    rts

@enter_dungeon:
    lda #STATE_DUNGEON
    sta GameState
    jsr DungeonInit
    rts
@enter_castle:
    lda #STATE_CASTLE
    sta GameState
    rts
@enter_town:
    stz ShopCursor
    lda #STATE_SHOP
    sta GameState
    rts

@blocked:
    rts
.endproc

; ============================================================================
; OverworldRender — 3x3 local view on BG1 (matches original game)
; Shows tiles surrounding player in a 3x3 grid of 8x8-tile cells.
; Player crosshair stamped at center cell.
; ============================================================================
.proc OverworldRender
    ; --- Clear tilemap to black (tile 0) ---
    SET_AXY16
    ldx #$0000
    lda #$0000
@clear:
    sta TilemapBuffer,x
    inx
    inx
    cpx #2048
    bne @clear

    ; --- Draw 9 cells ---
    SET_A8                  ; A=8-bit, XY still 16-bit
    lda #$00
    sta OW_TempA            ; cell counter (0-8)

@cell_loop:
    SET_XY8
    ldy OW_TempA            ; Y = cell index

    ; mapY = PlayerY + CellDY[cell]
    lda CellDY,y
    clc
    adc PlayerY
    cmp #MAP_H
    bcs @oob
    pha                     ; push mapY (8-bit)

    ; mapX = PlayerX + CellDX[cell]
    lda CellDX,y
    clc
    adc PlayerX
    cmp #MAP_W
    bcs @oob_pop

    ; --- In bounds: compute map offset = mapY*20 + mapX ---
    sta OW_TempB            ; mapX
    pla                     ; A = mapY
    stz OW_Offset+1
    sta OW_Offset
    SET_A16
    lda OW_Offset
    asl
    asl
    sta OW_Offset           ; mapY * 4
    asl
    asl                     ; mapY * 16
    clc
    adc OW_Offset           ; mapY * 20
    sta OW_Offset
    SET_A8
    lda OW_TempB
    SET_A16
    and #$00FF
    clc
    adc OW_Offset           ; mapY*20 + mapX
    SET_XY16
    tax
    SET_A8
    lda OverworldMap,x
    jmp @got_tile

@oob_pop:
    pla                     ; discard mapY
@oob:
    lda #TILE_MOUNTAIN      ; border = mountain

@got_tile:
    ; A = tile type
    pha                     ; save tile

    ; --- Get tilemap offset from CellOfs word table ---
    lda OW_TempA            ; cell index
    asl                     ; * 2 for word index
    SET_XY16
    tay                     ; Y = cell*2 (zero-extended to 16-bit)
    SET_A16
    lda CellOfs,y           ; 16-bit tilemap byte offset
    tax                     ; X = tilemap offset
    SET_A8

    pla                     ; A = tile type

    ; --- Write 2x2 tile block ---
    sta TilemapBuffer,x
    stz TilemapBuffer+1,x
    sta TilemapBuffer+2,x
    stz TilemapBuffer+3,x
    sta TilemapBuffer+64,x  ; next row = +32 words = +64 bytes
    stz TilemapBuffer+65,x
    sta TilemapBuffer+66,x
    stz TilemapBuffer+67,x

    ; --- Next cell ---
    inc OW_TempA
    lda OW_TempA
    cmp #$09
    bcc @cell_loop

    ; --- Player crosshair at center cell ---
    SET_XY16
    ldx #734                ; cell 4 tilemap offset
    lda #TILE_PLAYER
    sta TilemapBuffer,x
    stz TilemapBuffer+1,x
    sta TilemapBuffer+2,x
    stz TilemapBuffer+3,x
    sta TilemapBuffer+64,x
    stz TilemapBuffer+65,x
    sta TilemapBuffer+66,x
    stz TilemapBuffer+67,x

    rts
.endproc

; ============================================================================
; RODATA
; ============================================================================

.segment "RODATA"

; 3x3 cell layout: dy/dx offsets from player position
CellDY: .byte $FF, $FF, $FF, $00, $00, $00, $01, $01, $01
CellDX: .byte $FF, $00, $01, $FF, $00, $01, $FF, $00, $01

; Tilemap byte offsets for center of each 8x8-tile cell
; Cell grid starts at tilemap (row=0, col=4), each cell = 8x8 tiles
; Center of cell (cy,cx) at row=cy*8+3, col=4+cx*8+3 = cx*8+7
; Byte offset = (row*32 + col) * 2
CellOfs: .word 206, 222, 238, 718, 734, 750, 1230, 1246, 1262
