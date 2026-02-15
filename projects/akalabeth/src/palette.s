; palette.s — Palette effects engine
; Screen-wide color effects via COLDATA fixed color math
; Integrates with HDMA gradients: disables HDMA during flash/heal,
; re-enables on restore.

.include "macros.s"

.export PalFxTick, PalFxFlash, PalFxHeal
.export PalFxWaterCycle, PalFxTorchFlicker
.exportzp PalFxType, PalFxTimer

.importzp NmiCount
.importzp HdmaGradient

; ============================================================================
; Zero Page
; ============================================================================

.segment "ZEROPAGE"

PalFxType:      .res 1      ; 0=none, 1=flash(red), 2=heal(green)
PalFxTimer:     .res 1      ; Countdown frames for active effect

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; PalFxFlash — trigger red damage flash (8 frames)
; ============================================================================
.proc PalFxFlash
    SET_A8
    lda #$01
    sta PalFxType
    lda #$08
    sta PalFxTimer
    rts
.endproc

; ============================================================================
; PalFxHeal — trigger green heal pulse (8 frames)
; ============================================================================
.proc PalFxHeal
    SET_A8
    lda #$02
    sta PalFxType
    lda #$08
    sta PalFxTimer
    rts
.endproc

; ============================================================================
; PalFxTick — process active palette effect each frame
; Updates SHADOW_CGWSEL, SHADOW_CGADSUB, SHADOW_COLDATA.
; Disables HDMA channel 1 during active effects, re-enables on restore.
; Call every frame from main loop before ambient effects.
; ============================================================================
.proc PalFxTick
    SET_A8
    lda PalFxType
    beq @restore
    cmp #$01
    beq @do_flash
    cmp #$02
    beq @do_heal
    jmp @restore

@do_flash:
    ; Disable HDMA channel 1 during flash
    lda SHADOW_HDMAEN
    and #$FD
    sta SHADOW_HDMAEN
    ; Enable color math: add fixed color
    stz SHADOW_CGWSEL               ; color math always, fixed color
    lda #$31                        ; add to BG1 + OBJ + backdrop
    sta SHADOW_CGADSUB
    ; Red intensity = timer * 4 (decays 32→0)
    lda PalFxTimer
    asl
    asl
    ora #$80                        ; red channel flag
    sta SHADOW_COLDATA+2
    lda #$40                        ; green = 0
    sta SHADOW_COLDATA+1
    lda #$20                        ; blue = 0
    sta SHADOW_COLDATA
    dec PalFxTimer
    bne @done
    stz PalFxType
    jmp @restore

@do_heal:
    ; Disable HDMA channel 1 during heal
    lda SHADOW_HDMAEN
    and #$FD
    sta SHADOW_HDMAEN
    stz SHADOW_CGWSEL
    lda #$31
    sta SHADOW_CGADSUB
    ; Green intensity = timer * 4
    lda PalFxTimer
    asl
    asl
    ora #$40                        ; green channel flag
    sta SHADOW_COLDATA+1
    lda #$80                        ; red = 0
    sta SHADOW_COLDATA+2
    lda #$20                        ; blue = 0
    sta SHADOW_COLDATA
    dec PalFxTimer
    bne @done
    stz PalFxType
    jmp @restore

@restore:
    ; Check if HDMA gradient is active
    lda HdmaGradient
    bne @restore_hdma
    ; No HDMA: disable color math
    lda #$30                        ; color math = never
    sta SHADOW_CGWSEL
    stz SHADOW_CGADSUB
    lda #$20
    sta SHADOW_COLDATA              ; blue channel, intensity 0
    lda #$40
    sta SHADOW_COLDATA+1            ; green channel, intensity 0
    lda #$80
    sta SHADOW_COLDATA+2            ; red channel, intensity 0
    jmp @done
@restore_hdma:
    ; Re-enable HDMA channel 1
    lda SHADOW_HDMAEN
    ora #$02
    sta SHADOW_HDMAEN
    ; Restore gradient color math (add to BG1 + backdrop)
    stz SHADOW_CGWSEL
    lda #$21
    sta SHADOW_CGADSUB
@done:
    rts
.endproc

; ============================================================================
; PalFxWaterCycle — subtle blue shimmer for overworld
; Call each frame during overworld state (after PalFxTick).
; Skipped if a flash/heal effect or HDMA gradient is active.
; ============================================================================
.proc PalFxWaterCycle
    SET_A8
    lda PalFxType
    bne @skip                       ; active effect overrides ambient

    ; Cycle water palette CGRAM colors (palette 2, colors 1-3)
    ; Triangle wave from NmiCount: phase 0-31
    lda NmiCount
    and #$1F
    cmp #$10
    bcc @rising
    eor #$1F                        ; mirror: 31→0, 30→1, ...
@rising:
    ; A = 0-15, use low 2 bits to pick alternate blue shades
    lsr
    lsr                             ; 0-3
    tax
    ; Write palette 2 color 1 (CGRAM word $21 = byte $42)
    lda #$42                        ; CGRAM byte address for pal2 color1
    sta CGADD
    lda WaterShimmerLo,x
    sta CGDATA
    lda WaterShimmerHi,x
    sta CGDATA
@skip:
    rts
.endproc

; ============================================================================
; PalFxTorchFlicker — warm orange flicker for dungeons
; Call each frame during dungeon state (after PalFxTick).
; Skipped if a flash/heal effect or HDMA gradient is active.
; ============================================================================
.proc PalFxTorchFlicker
    SET_A8
    lda PalFxType
    bne @skip_torch
    lda HdmaGradient
    bne @skip_torch                 ; HDMA gradient supersedes

    stz SHADOW_CGWSEL               ; color math always, fixed color
    lda #$21                        ; add to BG1 + backdrop
    sta SHADOW_CGADSUB
    ; Red: oscillate 1-5 using low 2 bits of NmiCount (softer)
    lda NmiCount
    and #$03
    clc
    adc #$01                        ; 1-4
    ora #$80                        ; red channel flag
    sta SHADOW_COLDATA+2
    ; Green: subtle warmth 0-2
    lda NmiCount
    lsr
    and #$01                        ; 0-1
    clc
    adc #$00                        ; 0-1
    ora #$40                        ; green channel flag
    sta SHADOW_COLDATA+1
    lda #$20                        ; blue = 0
    sta SHADOW_COLDATA
@skip_torch:
    rts
.endproc

; ============================================================================
; RODATA — Water shimmer lookup (4 blue shade variations)
; ============================================================================

.segment "RODATA"

; Low/high bytes of 4 water blue shades for CGRAM cycling
; Shades cycle between slightly different blues
WaterShimmerLo: .byte <$5100, <$4900, <$5900, <$4900
WaterShimmerHi: .byte >$5100, >$4900, >$5900, >$4900
