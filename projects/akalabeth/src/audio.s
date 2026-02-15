; audio.s — Akalabeth audio interface (counter-based command protocol)
; Provides AudioInit, PlaySfx for game code.
; All calls must happen from main loop (never NMI).
;
; Protocol:
;   APUIO0 ($2140): command counter — change triggers SPC to process
;   APUIO1 ($2141): command byte (CMD_PLAY=$01, CMD_STOP=$02)
;   APUIO2 ($2142): SFX ID
;   SPC echoes counter to APUIO0 to acknowledge

.include "macros.s"

; ============================================================================
; Exports
; ============================================================================

.export AudioInit, PlaySfx

; ============================================================================
; Imports
; ============================================================================

.import SpcBootApu
.importzp AudioEnabled

.include "sfx_ids.inc"

; ============================================================================
; Command constants (must match spc/engine.s)
; ============================================================================

CMD_PLAY    = $01
CMD_STOP    = $02

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
CmdCounter: .res 1          ; command counter (sent to SPC via APUIO0)

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; AudioInit — upload SPC driver to ARAM, wait for ready signal
; Call once after InitSNES (during force blank). Clobbers: A, X, Y
; ============================================================================
.proc AudioInit
    SET_AXY8
    jsr SpcBootApu

    ; Wait for SPC engine to signal ready (APUIO0 == 0)
@wait_ready:
    lda APUIO0
    bne @wait_ready

    ; Clear 65816's output port so SPC doesn't see stale SpcExecute value
    stz APUIO0

    ; Initialize counter (must match SPC's LastCounter = 0)
    stz CmdCounter

    ; Mark audio as enabled
    lda #$01
    sta AudioEnabled
    rts
.endproc

; ============================================================================
; PlaySfx — play a sound effect
; Input: A = SFX ID (SFX_HIT, SFX_MISS, etc.)
; Clobbers: A. Preserves: X, Y
; ============================================================================
.proc PlaySfx
    SET_A8
    ; Check if audio is enabled
    pha
    lda AudioEnabled
    beq @skip

    ; Write SFX ID to APUIO2
    pla
    sta APUIO2

    ; Write command byte to APUIO1
    lda #CMD_PLAY
    sta APUIO1

    ; Increment counter (skip 0 — 0 means "no command")
    lda CmdCounter
    inc a
    bne :+
    inc a               ; skip 0
:   sta CmdCounter

    ; Write counter to APUIO0 — this triggers the SPC to process
    sta APUIO0

    ; Wait for SPC to echo counter back (acknowledgement)
@wait_ack:
    cmp APUIO0
    bne @wait_ack

    rts
@skip:
    pla
    rts
.endproc

; ============================================================================
; AudioStopAll — silence all sounds
; Clobbers: A
; ============================================================================
.proc AudioStopAll
    SET_A8
    lda AudioEnabled
    beq @done

    ; Write stop command
    lda #CMD_STOP
    sta APUIO1

    ; Increment counter
    lda CmdCounter
    inc a
    bne :+
    inc a
:   sta CmdCounter
    sta APUIO0

    ; Wait for ack
@wait_ack:
    cmp APUIO0
    bne @wait_ack
@done:
    rts
.endproc
