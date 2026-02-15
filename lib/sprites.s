; sprites.s — OAM sprite buffer and DMA upload
; Pattern: double-buffer OAM in RAM, DMA to PPU during VBlank

.include "macros.s"

.export SpriteInit, SpriteSetEntry, SpriteFlushOam, SpriteClearAll
.exportzp OamDirty, SprX, SprY, SprTile, SprAttr, SprSize

; ============================================================================
; Zero Page
; ============================================================================

.segment "ZEROPAGE"

OamDirty:   .res 1          ; Nonzero = NMI should DMA OAM buffer
SprX:       .res 1          ; Param: X position (low 8 bits)
SprY:       .res 1          ; Param: Y position
SprTile:    .res 1          ; Param: tile number
SprAttr:    .res 1          ; Param: vhoopppN attribute byte
SprSize:    .res 1          ; Param: 0=small, 1=large

; ============================================================================
; BSS — OAM shadow buffers (must be contiguous for single 544B DMA)
; ============================================================================

.segment "BSS"

.export OamBuf: abs, OamHiBuf: abs

OamBuf:     .res 512        ; 128 entries x 4 bytes
OamHiBuf:   .res 32         ; 128 entries x 2 bits = 32 bytes

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; SpriteInit / SpriteClearAll — hide all 128 sprites (Y=$F0 = off-screen)
; Clobbers: A, X
; ============================================================================
.proc SpriteInit
    ; fall through
.endproc

.proc SpriteClearAll
    SET_AXY8
    SET_XY16
    ldx #$0000
@loop:
    stz OamBuf,x            ; X pos = 0
    lda #$F0
    sta OamBuf+1,x          ; Y pos = off-screen
    stz OamBuf+2,x          ; tile = 0
    stz OamBuf+3,x          ; attr = 0
    inx
    inx
    inx
    inx
    cpx #512
    bne @loop

    ; Clear high table
    ldx #$0000
@clr_hi:
    stz OamHiBuf,x
    inx
    cpx #32
    bne @clr_hi

    lda #$01
    sta OamDirty
    rts
.endproc

; ============================================================================
; SpriteSetEntry — set one OAM entry from ZP parameters
; A (8-bit) = sprite index (0-127)
; ZP inputs: SprX, SprY, SprTile, SprAttr, SprSize
; Clobbers: A, X, Y
; ============================================================================
.proc SpriteSetEntry
    SET_AXY8
    and #$7F
    pha                         ; save index

    ; --- Main OAM entry: offset = index * 4 ---
    SET_XY16
    SET_A16
    and #$007F
    asl
    asl
    tax                         ; X = buffer offset (16-bit)
    SET_A8

    lda SprX
    sta OamBuf,x
    lda SprY
    sta OamBuf+1,x
    lda SprTile
    sta OamBuf+2,x
    lda SprAttr
    sta OamBuf+3,x

    ; --- High table: byte = index/4, bit pos = (index%4)*2 ---
    SET_XY8
    pla                         ; A = index
    pha
    lsr
    lsr
    tax                         ; X = byte offset in OamHiBuf

    pla                         ; A = index
    and #$03
    tay                         ; Y = sub-index (0-3)

    ; Build 2-bit value: bit1=size, bit0=0 (X bit8 unused)
    lda SprSize
    and #$01
    asl                         ; value = 0 or 2

    ; Shift to correct bit position via fall-through
    cpy #$00
    beq @write
    cpy #$01
    beq @s2
    cpy #$02
    beq @s4
    ; sub-index 3: shift 6 total
    asl
    asl
@s4:
    asl
    asl
@s2:
    asl
    asl
@write:
    pha                         ; save shifted value
    lda OamHiBuf,x
    and HiMask,y                ; clear old 2 bits
    sta OamHiBuf,x
    pla
    ora OamHiBuf,x
    sta OamHiBuf,x

    lda #$01
    sta OamDirty
    rts
.endproc

; ============================================================================
; SpriteFlushOam — DMA 544-byte OAM buffer to PPU
; Called from NMI handler. Assumes A8 on entry.
; ============================================================================
.proc SpriteFlushOam
    lda OamDirty
    beq @skip

    ; Set OAM address to 0
    stz OAMADDL
    stz OAMADDH

    ; DMA 544 bytes (512 main + 32 high table) to OAMDATA
    lda #DMA_1REG_1W            ; $00: 1 register, incrementing source
    sta DMAP0
    lda #$04                    ; B-bus = OAMDATA ($2104)
    sta BBAD0
    lda #<OamBuf
    sta A1T0L
    lda #>OamBuf
    sta A1T0H
    stz A1B0                    ; bank 0 (RAM)
    lda #$20                    ; $0220 = 544 bytes
    sta DAS0L
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN                  ; trigger DMA channel 0

    stz OamDirty
@skip:
    rts
.endproc

; ============================================================================
; RODATA
; ============================================================================

.segment "RODATA"

; Masks to clear 2 bits at each sub-index position in high table byte
HiMask: .byte $FC, $F3, $CF, $3F
