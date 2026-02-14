; init.s — SNES cold boot initialization
; Verified against Harvest Moon (bank_80.asm:417-461) and Gargoyles Quest (GG_MAIN.658:897-1028)
; Standard boot sequence: native mode → clear registers → clear RAM → force blank

.include "macros.s"

.export InitSNES

.segment "CODE"

; ============================================================================
; InitSNES — SNES hardware initialization
; Call this from your ResetHandler before doing anything else.
; Clobbers: all registers
; ============================================================================
.proc InitSNES
    sei                     ; Disable interrupts
    clc
    xce                     ; Switch to native (65816) mode

    SET_AXY16
    ldx #$1FFF             ; Stack at top of low RAM
    txs
    lda #$0000
    tcd                     ; Direct page = $0000

    SET_AXY8

    ; --- Force blank (display off) ---
    lda #$80
    sta INIDISP

    ; --- Disable NMI, IRQ, HDMA, DMA ---
    stz NMITIMEN
    stz MDMAEN
    stz HDMAEN

    ; --- Clear PPU registers ---
    stz OBSEL
    stz OAMADDL
    stz OAMADDH
    stz BGMODE
    stz MOSAIC
    stz BG1SC
    stz BG2SC
    stz BG3SC
    stz BG4SC
    stz BG12NBA
    stz BG34NBA

    ; Scroll registers (write twice: low byte then high byte)
    stz BG1HOFS
    stz BG1HOFS
    stz BG1VOFS
    stz BG1VOFS
    stz BG2HOFS
    stz BG2HOFS
    stz BG2VOFS
    stz BG2VOFS
    stz BG3HOFS
    stz BG3HOFS
    stz BG3VOFS
    stz BG3VOFS
    stz BG4HOFS
    stz BG4HOFS
    stz BG4VOFS
    stz BG4VOFS

    ; VRAM control
    lda #$80                ; Increment after writing $2119
    sta VMAIN
    stz VMADDL
    stz VMADDH

    ; Mode 7 — identity matrix
    stz M7SEL
    stz M7A                 ; M7A low = 0
    lda #$01
    sta M7A                 ; M7A high = 1
    stz M7B
    stz M7B
    stz M7C
    stz M7C
    stz M7D                 ; M7D low = 0
    lda #$01
    sta M7D                 ; M7D high = 1 (identity)
    stz M7X
    stz M7X
    stz M7Y
    stz M7Y

    ; Palette
    stz CGADD
    stz CGDATA
    stz CGDATA

    ; Window registers
    stz W12SEL
    stz W34SEL
    stz WOBJSEL
    stz WH0
    stz WH1
    stz WH2
    stz WH3
    stz WBGLOG
    stz WOBJLOG

    ; Screen layers
    stz TM
    stz TS
    stz TMW
    stz TSW

    ; Color math
    lda #$30
    sta CGWSEL
    stz CGADSUB
    lda #$E0
    sta COLDATA
    stz SETINI

    ; I/O + timing
    lda #$FF
    sta WRIO
    stz WRMPYA
    stz WRMPYB
    stz WRDIVL
    stz WRDIVH
    stz WRDIVB
    stz HTIMEL
    stz HTIMEH
    stz VTIMEL
    stz VTIMEH
    stz MEMSEL

    ; --- Clear VRAM via DMA (64KB) ---
    stz VMADDL              ; VRAM address = $0000
    stz VMADDH
    lda #$80
    sta VMAIN               ; Increment mode

    stz $0000               ; Zero byte source at $0000
    lda #$09                ; Fixed source, write to $2118+$2119
    sta DMAP0
    lda #$18                ; B-bus = VMDATAL
    sta BBAD0
    stz A1T0L               ; Source = $00:0000
    stz A1T0H
    stz A1B0
    stz DAS0L               ; Size = $0000 (= 64KB)
    stz DAS0H
    lda #$01                ; Enable DMA channel 0
    sta MDMAEN

    ; --- Clear OAM (544 bytes) ---
    stz OAMADDL
    stz OAMADDH
    lda #$08                ; Fixed source, write to $2104
    sta DMAP0
    lda #$04                ; B-bus = OAMDATA
    sta BBAD0
    stz A1T0L
    stz A1T0H
    stz A1B0
    lda #$20                ; 544 bytes = $0220
    sta DAS0L
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; --- Clear CGRAM (512 bytes) ---
    stz CGADD
    lda #$08                ; Fixed source, write to $2122
    sta DMAP0
    lda #$22                ; B-bus = CGDATA
    sta BBAD0
    stz A1T0L
    stz A1T0H
    stz A1B0
    stz DAS0L               ; 512 bytes = $0200
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; --- Clear low RAM ($0000-$1FFF) ---
    SET_AXY16
    lda #$0000
    ldx #$0000
@clear_ram:
    sta $00,x
    inx
    inx
    cpx #$1FFE
    bne @clear_ram

    SET_AXY8

    ; --- Wait for VBlank ---
    lda RDNMI               ; Clear NMI flag
@wait_vblank:
    lda HVBJOY
    bpl @wait_vblank        ; Wait until bit 7 set (in VBlank)

    rts
.endproc
