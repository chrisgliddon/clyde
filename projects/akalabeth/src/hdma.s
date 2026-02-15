; hdma.s — HDMA gradient backgrounds
; Per-scanline COLDATA via HDMA channel 1 for sky/depth gradients

.include "macros.s"

.export HdmaSetOverworld, HdmaSetDungeon, HdmaDisable
.exportzp HdmaGradient

; ============================================================================
; Zero Page
; ============================================================================

.segment "ZEROPAGE"

HdmaGradient:   .res 1      ; 0=off, 1=overworld sky, 2=dungeon depth

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; HdmaSetOverworld — configure blue sky gradient via HDMA channel 1
; Call during force blank, before FadeIn.
; ============================================================================
.proc HdmaSetOverworld
    SET_A8
    ; Configure HDMA channel 1 → COLDATA ($2132)
    lda #$00                    ; Transfer mode 0: 1 reg, 1 write
    sta DMAP1
    lda #$32                    ; B-bus register: COLDATA
    sta BBAD1
    lda #<SkyGradientTable
    sta A1T1L
    lda #>SkyGradientTable
    sta A1T1H
    stz A1B1                    ; Bank 0 (ROM)
    ; Enable color math: add to BG1 + backdrop
    stz SHADOW_CGWSEL
    lda #$21
    sta SHADOW_CGADSUB
    ; Enable HDMA channel 1
    lda SHADOW_HDMAEN
    ora #$02
    sta SHADOW_HDMAEN
    lda #$01
    sta HdmaGradient
    rts
.endproc

; ============================================================================
; HdmaSetDungeon — configure warm depth gradient via HDMA channel 1
; Call during force blank, before FadeIn.
; ============================================================================
.proc HdmaSetDungeon
    SET_A8
    lda #$00
    sta DMAP1
    lda #$32
    sta BBAD1
    lda #<DungeonGradientTable
    sta A1T1L
    lda #>DungeonGradientTable
    sta A1T1H
    stz A1B1
    stz SHADOW_CGWSEL
    lda #$21
    sta SHADOW_CGADSUB
    lda SHADOW_HDMAEN
    ora #$02
    sta SHADOW_HDMAEN
    lda #$02
    sta HdmaGradient
    rts
.endproc

; ============================================================================
; HdmaDisable — turn off HDMA gradient
; ============================================================================
.proc HdmaDisable
    SET_A8
    lda SHADOW_HDMAEN
    and #$FD                    ; Clear bit 1 (channel 1)
    sta SHADOW_HDMAEN
    stz HdmaGradient
    rts
.endproc

; ============================================================================
; HDMA Tables (RODATA)
; Format: [count | $80 = repeat mode, data_byte] ... [$00 = end]
; Each data byte: COLDATA format (bits 7/6/5 = R/G/B channel, 4-0 = intensity)
; ============================================================================

.segment "RODATA"

; Blue sky gradient: 96 lines of decreasing blue, 128 lines ground (no tint)
SkyGradientTable:
    .byte $90, $2A              ; 16 lines: blue intensity 10
    .byte $90, $29              ; 16 lines: blue intensity 9
    .byte $90, $27              ; 16 lines: blue intensity 7
    .byte $90, $25              ; 16 lines: blue intensity 5
    .byte $90, $23              ; 16 lines: blue intensity 3
    .byte $90, $21              ; 16 lines: blue intensity 1
    .byte $FF, $20              ; 127 lines: blue intensity 0
    .byte $81, $20              ; 1 line: blue intensity 0
    .byte $00                   ; End

; Warm dungeon gradient: red decreasing with depth
DungeonGradientTable:
    .byte $A0, $86              ; 32 lines: red intensity 6
    .byte $A0, $85              ; 32 lines: red intensity 5
    .byte $C0, $83              ; 64 lines: red intensity 3
    .byte $E0, $82              ; 96 lines: red intensity 2
    .byte $00                   ; End
