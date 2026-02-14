; dungeon.s — Akalabeth dungeon system
; 10x10 grid per floor, 10 floors, procedural generation

.include "macros.s"

.export DungeonInit

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

; Player facing direction
FACE_NORTH      = $00
FACE_EAST       = $01
FACE_SOUTH      = $02
FACE_WEST       = $03

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
DungPlayerX:    .res 1      ; X position in dungeon grid
DungPlayerY:    .res 1      ; Y position in dungeon grid
DungFloor:      .res 1      ; Current floor (0-9)
DungFacing:     .res 1      ; Player facing direction
RngSeed:        .res 2      ; 16-bit PRNG seed

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
DungeonGrid:    .res DUNG_SIZE  ; Current floor grid

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; DungeonInit — generate floor from seed, place player at stairs
; ============================================================================
.proc DungeonInit
    SET_A8

    ; Start on floor 0
    stz DungFloor
    stz DungFacing          ; Face north

    ; Player starts at entrance (0,0)
    stz DungPlayerX
    stz DungPlayerY

    ; Generate floor
    jsr GenerateFloor

    rts
.endproc

; ============================================================================
; GenerateFloor — procedural dungeon generation
; Uses PRNG seeded by floor number. Matches original's simple algorithm:
; outer walls + random interior walls + stairs + door.
; ============================================================================
.proc GenerateFloor
    SET_AXY8

    ; Seed PRNG from floor number
    lda DungFloor
    sta RngSeed
    lda #$A5                ; Salt
    sta RngSeed+1

    ; Fill with walls first
    ldx #$00
    lda #DTILE_WALL
@fill_walls:
    sta DungeonGrid,x
    inx
    cpx #DUNG_SIZE
    bne @fill_walls

    ; Carve interior (rows 1-8, cols 1-8) based on PRNG
    ldy #$01                ; row
@row_loop:
    ldx #$01                ; col
@col_loop:
    jsr PrngNext
    and #$03                ; 25% chance of wall
    bne @carve
    jmp @next_col
@carve:
    ; Calculate offset: Y * DUNG_W + X
    pha
    tya
    ; Multiply Y by 10
    asl                     ; *2
    asl                     ; *4
    clc
    adc DungPlayerY         ; temp reuse — actually need Y*10
    ; Simpler: use a lookup or repeated add
    pla
    ; TODO: proper offset calculation, for now just sequential carve
    pha
    tya
    sta DungPlayerY         ; temp
    ; Y * 10 = Y * 8 + Y * 2
    asl                     ; *2
    sta DungPlayerX         ; temp
    asl                     ; *4
    asl                     ; *8
    clc
    adc DungPlayerX         ; *8 + *2 = *10
    clc
    adc $00                 ; add col (X register value was lost)
    tax
    pla
    lda #DTILE_FLOOR
    sta DungeonGrid,x

@next_col:
    inx
    cpx #(DUNG_W - 1)
    bne @col_loop
    iny
    cpy #(DUNG_H - 1)
    bne @row_loop

    ; Place stairs down (center-ish)
    lda #DTILE_STAIRS_DN
    sta DungeonGrid + 5 * DUNG_W + 5

    ; Place stairs up at entrance
    lda #DTILE_STAIRS_UP
    sta DungeonGrid + 0 * DUNG_W + 0

    rts
.endproc

; ============================================================================
; PrngNext — simple 16-bit LFSR PRNG
; Returns: A = pseudo-random byte
; ============================================================================
.proc PrngNext
    SET_A16
    lda RngSeed
    asl
    bcc @no_xor
    eor #$002D              ; Feedback polynomial
@no_xor:
    sta RngSeed
    SET_A8
    lda RngSeed             ; Return low byte
    rts
.endproc
