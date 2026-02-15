; audio.s — Akalabeth audio interface (SNESGSS command protocol)
; Provides AudioInit, PlaySfx for game code.
; All calls must happen from main loop (never NMI).

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
; SNESGSS Command Constants
; ============================================================================

GSS_NOOP        = $00
GSS_SUBCOMMAND  = $01
GSS_VOLUME      = $02
GSS_SFX_PLAY    = $04
GSS_INITIALIZE  = $01   ; SUBCOMMAND + (INITIALIZE << 4)
GSS_STOP_ALL    = $51   ; SUBCOMMAND + (STOP_ALL_SOUNDS << 4)

; Default SFX volume and pan
SFX_VOL_DEFAULT = $7F   ; ~50% volume
SFX_PAN_CENTER  = $80   ; Center pan

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; AudioInit — upload SPC driver to ARAM, send INITIALIZE command
; Call once after InitSNES (during force blank). Clobbers: A, X, Y
; ============================================================================
.proc AudioInit
    SET_AXY8
    jsr SpcBootApu

    ; Send INITIALIZE command via GSS protocol
    ; Wait for SPC to signal ready (APUIO0 == 0)
@wait_ready:
    lda APUIO0
    bne @wait_ready

    ; Store command params: no params for INITIALIZE
    stz APUIO2
    stz APUIO3

    ; Send command byte to APUIO1, then trigger via APUIO0
    lda #GSS_INITIALIZE
    xba                     ; High byte of 16-bit A = command
    lda #$01                ; Low byte = nonzero trigger (any nonzero)
    SET_A16
    sta APUIO0              ; Write APUIO0 + APUIO1 atomically
    SET_A8

    ; Wait for acknowledgement (APUIO3 changes)
    lda APUIO3
@wait_ack:
    cmp APUIO3
    beq @wait_ack

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

    ; Wait for SPC to be ready for a command (APUIO0 == 0)
@wait:
    lda APUIO0
    bne @wait

    ; Set up SFX_PLAY command:
    ;   APUIO1 = volume
    ;   APUIO2 = effect number
    ;   APUIO3 = pan
    pla
    sta APUIO2              ; Effect number

    lda #SFX_VOL_DEFAULT
    sta APUIO1              ; Volume (written to APUIO1 directly for SFX)

    lda #SFX_PAN_CENTER
    sta APUIO3              ; Pan

    ; Send SFX_PLAY command via APUIO0
    ; GSS protocol: write command to APUIO0, SPC reads and acknowledges
    lda #GSS_SFX_PLAY
    sta APUIO0

    ; Wait for acknowledgement (APUIO0 returns to 0)
@wait_ack:
    lda APUIO0
    bne @wait_ack

    rts
@skip:
    pla
    rts
.endproc

; ============================================================================
; AudioStopAll — silence all sounds (for title screen)
; Clobbers: A
; ============================================================================
.proc AudioStopAll
    SET_A8
    lda AudioEnabled
    beq @done

@wait:
    lda APUIO0
    bne @wait

    stz APUIO2
    stz APUIO3

    lda #GSS_STOP_ALL
    xba
    lda #$01
    SET_A16
    sta APUIO0
    SET_A8

    lda APUIO3
@wait_ack:
    cmp APUIO3
    beq @wait_ack
@done:
    rts
.endproc
