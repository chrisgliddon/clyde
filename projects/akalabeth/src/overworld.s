; overworld.s — Akalabeth overworld system
; 20x20 tile grid, player movement, BG1 rendering

.include "macros.s"

.export OverworldInit, OverworldUpdate, OverworldRender
.export TilemapBuffer
.exportzp PlayerX, PlayerY, MapDirty

.importzp JoyPress, GameState
.importzp PlayerFood, PlayerHP
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

JOY_UP          = $08
JOY_DOWN        = $04
JOY_LEFT        = $02
JOY_RIGHT       = $01

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

    lda JoyPress+1
    sta OW_Offset            ; Save for bit tests

    bit #JOY_UP
    bne @move_up
    bit #JOY_DOWN
    bne @move_down
    bit #JOY_LEFT
    bne @move_left
    bit #JOY_RIGHT
    bne @move_right
    rts

@move_up:
    lda PlayerY
    beq @ret
    dec a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_down:
    lda PlayerY
    cmp #MAP_H - 1
    beq @ret
    inc a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_left:
    lda PlayerX
    beq @ret
    lda PlayerY
    sta OW_TempA
    lda PlayerX
    dec a
    sta OW_TempB
    jmp @try_move

@move_right:
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
    lda #STATE_SHOP
    sta GameState
    rts

@blocked:
    rts
.endproc

; ============================================================================
; OverworldRender — build 32x32 BG1 tilemap from 20x20 map + player marker
; Center 20x20 in 32x32 at offset (6,6).
; Each tilemap entry = 2 bytes: low=tile#, high=attributes.
; ============================================================================
.proc OverworldRender
    SET_AXY16

    ; Clear tilemap to tile 0
    ldx #$0000
    lda #$0000
@clear:
    sta TilemapBuffer,x
    inx
    inx
    cpx #2048
    bne @clear

    ; Now fill in the 20x20 map region
    ; For each map cell (row, col): tilemap byte offset = ((row+6)*32 + (col+6)) * 2
    SET_AXY8
    SET_XY16
    stz OW_TempA            ; row counter (0-19)

@row_loop:
    stz OW_TempB            ; col counter (0-19)

@col_loop:
    ; --- Read map tile ---
    ; map offset = row * 20 + col
    lda OW_TempA
    pha                     ; Save row on stack
    jsr CalcMapOffset       ; X = row*20 + col (uses OW_TempA and OW_TempB)
    lda OverworldMap,x      ; A = tile type
    pha                     ; Save tile on stack

    ; --- Calculate tilemap destination ---
    ; dest word index = (row+6)*32 + (col+6)
    ; dest byte offset = word_index * 2
    lda OW_TempA            ; row
    clc
    adc #6
    sta OW_Offset
    stz OW_Offset+1
    SET_A16
    lda OW_Offset
    asl
    asl
    asl
    asl
    asl                     ; (row+6) * 32
    sta OW_Offset
    SET_A8
    lda OW_TempB            ; col
    clc
    adc #6
    SET_A16
    and #$00FF
    clc
    adc OW_Offset            ; + (col+6)
    asl                     ; * 2 = byte offset
    tax

    ; --- Write tilemap entry ---
    SET_A8
    pla                     ; Restore tile type
    sta TilemapBuffer,x     ; Low byte = tile number
    lda #$00                ; High byte = palette 0, no flip
    sta TilemapBuffer+1,x

    ; --- Restore row, advance col ---
    pla                     ; Restore row counter
    sta OW_TempA

    inc OW_TempB
    lda OW_TempB
    cmp #MAP_W
    bne @col_loop

    inc OW_TempA
    lda OW_TempA
    cmp #MAP_H
    bne @row_loop

    ; --- Stamp player marker ---
    lda PlayerY
    clc
    adc #6
    sta OW_Offset
    stz OW_Offset+1
    SET_A16
    lda OW_Offset
    asl
    asl
    asl
    asl
    asl                     ; (PlayerY+6) * 32
    sta OW_Offset
    SET_A8
    lda PlayerX
    clc
    adc #6
    SET_A16
    and #$00FF
    clc
    adc OW_Offset
    asl
    tax
    SET_A8
    lda #TILE_PLAYER
    sta TilemapBuffer,x
    lda #$00
    sta TilemapBuffer+1,x

    rts
.endproc
