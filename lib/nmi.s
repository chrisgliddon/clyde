; nmi.s — Production NMI handler with PPU shadow copy and DMA queue
; Pattern from BS Zelda (shadow registers) and Gargoyles Quest (flag-driven DMA)
;
; Design: NMI copies PPU shadow registers → hardware, flushes DMA queue,
; then signals main loop via FrameReady flag.
;
; Usage: Game logic writes to SHADOW_* and sets DMA dirty flags.
;        NMI handles the hardware writes during VBlank.

.include "macros.s"

.export NmiHandler, IrqHandler
.exportzp FrameReady, NmiCount

; Import joypad (called from main loop, not NMI)
.import ReadJoypad
.import SpriteFlushOam

; ============================================================================
; Zero Page variables
; ============================================================================

.segment "ZEROPAGE"

FrameReady:     .res 1      ; Set by NMI, cleared by main loop
NmiCount:       .res 2      ; 16-bit frame counter (wraps at 65535)

; ============================================================================
; DMA Queue
; Entries: up to 8 slots, 7 bytes each.
; Format: [DMAP, BBAD, SrcL, SrcH, SrcBank, SizeL, SizeH]
; Set DmaCount to number of entries. NMI flushes and resets to 0.
; ============================================================================

.export DmaQueue, DmaCount

.segment "BSS"

DmaQueue:   .res 7 * 8      ; 8 entries × 7 bytes = 56 bytes
DmaCount:   .res 1          ; Number of queued entries (0 = empty)

; ============================================================================
; NmiHandler — VBlank interrupt handler
; Copies PPU shadows → hardware, flushes DMA queue, increments frame counter.
; ============================================================================

.segment "CODE"

.proc NmiHandler
    pha
    phx
    phy
    phd
    php

    SET_AXY8

    ; Acknowledge NMI (reading $4210 clears the NMI flag)
    lda RDNMI

    ; --- Copy PPU shadow registers → hardware ---
    ; Static registers (single-write)
    lda SHADOW_OBSEL
    sta OBSEL
    lda SHADOW_BGMODE
    sta BGMODE
    lda SHADOW_MOSAIC
    sta MOSAIC
    lda SHADOW_BG1SC
    sta BG1SC
    lda SHADOW_BG2SC
    sta BG2SC
    lda SHADOW_BG3SC
    sta BG3SC
    lda SHADOW_BG4SC
    sta BG4SC
    lda SHADOW_BG12NBA
    sta BG12NBA
    lda SHADOW_BG34NBA
    sta BG34NBA

    ; Scroll registers — write twice each (lo then hi, hardware latches on 2nd write)
    lda SHADOW_BG1HOFS
    sta BG1HOFS
    lda SHADOW_BG1HOFS+1
    sta BG1HOFS
    lda SHADOW_BG1VOFS
    sta BG1VOFS
    lda SHADOW_BG1VOFS+1
    sta BG1VOFS
    lda SHADOW_BG2HOFS
    sta BG2HOFS
    lda SHADOW_BG2HOFS+1
    sta BG2HOFS
    lda SHADOW_BG2VOFS
    sta BG2VOFS
    lda SHADOW_BG2VOFS+1
    sta BG2VOFS
    lda SHADOW_BG3HOFS
    sta BG3HOFS
    lda SHADOW_BG3HOFS+1
    sta BG3HOFS
    lda SHADOW_BG3VOFS
    sta BG3VOFS
    lda SHADOW_BG3VOFS+1
    sta BG3VOFS

    ; Layer enables, window mask, and color math
    lda SHADOW_TM
    sta TM
    lda SHADOW_TS
    sta TS
    lda SHADOW_TMW
    sta TMW
    lda SHADOW_CGWSEL
    sta CGWSEL
    lda SHADOW_CGADSUB
    sta CGADSUB

    ; Fixed color data (3 writes: blue, green, red channels)
    lda SHADOW_COLDATA
    sta COLDATA
    lda SHADOW_COLDATA+1
    sta COLDATA
    lda SHADOW_COLDATA+2
    sta COLDATA

    ; Brightness (INIDISP) — written last among PPU regs
    lda SHADOW_INIDISP
    sta INIDISP

    ; --- Flush DMA queue ---
    lda DmaCount
    beq @no_dma

    SET_XY16
    ldx #$0000              ; X = queue offset

@dma_loop:
    SET_A8
    lda DmaQueue+0,x
    sta DMAP0               ; DMA control
    lda DmaQueue+1,x
    sta BBAD0               ; B-bus dest register
    lda DmaQueue+2,x
    sta A1T0L               ; Source addr low
    lda DmaQueue+3,x
    sta A1T0H               ; Source addr high
    lda DmaQueue+4,x
    sta A1B0                ; Source bank
    lda DmaQueue+5,x
    sta DAS0L               ; Transfer size low
    lda DmaQueue+6,x
    sta DAS0H               ; Transfer size high
    lda #$01
    sta MDMAEN              ; Trigger DMA channel 0

    ; Advance to next entry
    txa
    clc
    adc #7
    tax

    ; Decrement count
    dec DmaCount
    bne @dma_loop

    SET_XY8
@no_dma:

    ; --- OAM flush ---
    jsr SpriteFlushOam

    ; --- HDMA ---
    lda SHADOW_HDMAEN
    sta HDMAEN

    ; --- Frame counter ---
    SET_A16
    lda NmiCount
    inc
    sta NmiCount

    ; --- Signal main loop ---
    SET_A8
    lda #$01
    sta FrameReady

    plp
    pld
    ply
    plx
    pla
    rti
.endproc

; ============================================================================
; IrqHandler — V-count IRQ at scanline 16 (HUD boundary)
; Disables BG1 window masking so BG1 is visible below the HUD.
; NMI re-enables TMW each frame for the next HUD area.
; ============================================================================

.proc IrqHandler
    pha
    sep #$20                ; Force A8
    lda TIMEUP              ; Acknowledge IRQ (read clears flag)
    stz TMW                 ; Disable BG1 windowing for game area
    pla
    rti
.endproc
