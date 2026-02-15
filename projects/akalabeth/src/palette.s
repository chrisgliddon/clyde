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
    lda HdmaGradient
    bne @skip                       ; HDMA gradient supersedes

    ; Enable color math with subtle blue oscillation
    stz SHADOW_CGWSEL               ; color math always, fixed color
    lda #$21                        ; add to BG1 + backdrop
    sta SHADOW_CGADSUB
    ; Triangle wave from NmiCount: phase 0-31
    lda NmiCount
    and #$1F
    cmp #$10
    bcc @rising
    eor #$1F                        ; mirror: 31→0, 30→1, ...
@rising:
    ; A = 0-15, scale to 2-5 range
    lsr
    lsr                             ; 0-3
    clc
    adc #$02                        ; 2-5
    ora #$20                        ; blue channel flag
    sta SHADOW_COLDATA
    lda #$40
    sta SHADOW_COLDATA+1            ; green = 0
    lda #$80
    sta SHADOW_COLDATA+2            ; red = 0
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
    bne @skip
    lda HdmaGradient
    bne @skip                       ; HDMA gradient supersedes

    stz SHADOW_CGWSEL               ; color math always, fixed color
    lda #$21                        ; add to BG1 + backdrop
    sta SHADOW_CGADSUB
    ; Red: oscillate 3-10 using low 3 bits of NmiCount
    lda NmiCount
    and #$07
    clc
    adc #$03                        ; 3-10
    ora #$80                        ; red channel flag
    sta SHADOW_COLDATA+2
    ; Green: subtle warmth 1-4
    lda NmiCount
    lsr
    and #$03                        ; 0-3
    clc
    adc #$01                        ; 1-4
    ora #$40                        ; green channel flag
    sta SHADOW_COLDATA+1
    lda #$20                        ; blue = 0
    sta SHADOW_COLDATA
@skip:
    rts
.endproc
