; overworld.s — Akalabeth overworld system
; 20x20 tile grid, player movement, BG1 rendering

.include "macros.s"

.export OverworldInit, OverworldUpdate

.importzp JoyPress

; ============================================================================
; Constants
; ============================================================================

MAP_W           = 20
MAP_H           = 20
MAP_SIZE        = MAP_W * MAP_H     ; 400 bytes

; Tile types (match original Akalabeth)
TILE_GRASS      = $00
TILE_MOUNTAIN   = $01
TILE_WATER      = $02
TILE_TOWN       = $03
TILE_CASTLE     = $04
TILE_DUNGEON    = $05
TILE_FOREST     = $06

; Joypad button masks (high byte of 16-bit joypad word)
JOY_UP          = $08       ; D-pad up (bit 11, in high byte = bit 3)
JOY_DOWN        = $04       ; D-pad down
JOY_LEFT        = $02       ; D-pad left
JOY_RIGHT       = $01       ; D-pad right

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
PlayerX:        .res 1      ; Player X position (0-19)
PlayerY:        .res 1      ; Player Y position (0-19)
MapDirty:       .res 1      ; Nonzero = need to redraw map

; ============================================================================
; BSS — RAM data
; ============================================================================

.segment "BSS"
OverworldMap:   .res MAP_SIZE   ; 20x20 tile grid

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; OverworldInit — generate map, place player
; ============================================================================
.proc OverworldInit
    SET_A8

    ; Place player at center
    lda #MAP_W / 2
    sta PlayerX
    lda #MAP_H / 2
    sta PlayerY

    ; Generate simple map (all grass for now)
    SET_AXY16
    ldx #$0000
    lda #TILE_GRASS
@fill:
    sta OverworldMap,x
    inx
    cpx #MAP_SIZE
    bne @fill

    SET_A8

    ; Place castle at center
    lda #TILE_CASTLE
    sta OverworldMap + (MAP_H / 2) * MAP_W + (MAP_W / 2)

    ; Place a town
    lda #TILE_TOWN
    sta OverworldMap + 3 * MAP_W + 5

    ; Place a dungeon entrance
    lda #TILE_DUNGEON
    sta OverworldMap + 15 * MAP_W + 12

    ; Place some mountains
    lda #TILE_MOUNTAIN
    sta OverworldMap + 7 * MAP_W + 8
    sta OverworldMap + 7 * MAP_W + 9
    sta OverworldMap + 8 * MAP_W + 8

    lda #$01
    sta MapDirty

    rts
.endproc

; ============================================================================
; OverworldUpdate — handle D-pad movement
; ============================================================================
.proc OverworldUpdate
    SET_A8

    ; Check D-pad (high byte of JoyPress)
    lda JoyPress+1

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
    beq @done               ; Already at top
    dec PlayerY
    jmp @moved

@move_down:
    lda PlayerY
    cmp #MAP_H - 1
    beq @done               ; Already at bottom
    inc PlayerY
    jmp @moved

@move_left:
    lda PlayerX
    beq @done
    dec PlayerX
    jmp @moved

@move_right:
    lda PlayerX
    cmp #MAP_W - 1
    beq @done
    inc PlayerX

@moved:
    lda #$01
    sta MapDirty
    ; TODO: check tile under player (town, dungeon, etc.)

@done:
    rts
.endproc
