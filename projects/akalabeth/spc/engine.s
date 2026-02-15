; engine.s — SPC700 audio engine for Akalabeth
; Assembled with ca65 --cpu none (spc-ca65.inc provides the instruction set)
;
; ARAM layout (contiguous):
;   $0000-$00FF  Direct page (variables)
;   $0100-$01FF  Stack (unused — no CALL/RET)
;   $0200+       Code + data + directory + BRR
;
; Command protocol (counter-based):
;   APUIO0 ($F4): command counter — change triggers command processing
;   APUIO1 ($F5): command byte (CMD_PLAY=$01, CMD_STOP=$02)
;   APUIO2 ($F6): SFX ID (0-10)
;   SPC echoes counter back to $F4 to acknowledge
;
; NOTE: All DSP writes are inlined (no subroutine calls).
; spc-ca65.inc CALL/RET was found to crash on hardware during Phase 22
; debugging. Inlining adds ~20 bytes but avoids the issue entirely.

.include "spc-ca65.inc"

; --- APU I/O ports ---
APUIO0 = $F4
APUIO1 = $F5
APUIO2 = $F6
APUIO3 = $F7

; --- DSP register address/data ---
DSPADDR = $F2
DSPDATA = $F3

; --- Inline DSP write macro ---
; Input: Y = register number, A = value
; Replaces call !WriteDSP — avoids CALL/RET entirely
.macro WRITE_DSP
    mov DSPADDR, y
    mov DSPDATA, a
.endmacro

; --- DSP register offsets (voice N = base + N*$10) ---
DSP_VOL_L  = $00
DSP_VOL_R  = $01
DSP_PITCH_L = $02
DSP_PITCH_H = $03
DSP_SRCN   = $04
DSP_ADSR1  = $05
DSP_ADSR2  = $06
DSP_GAIN   = $07

; --- DSP global registers ---
DSP_MVOL_L = $0C
DSP_MVOL_R = $1C
DSP_EVOL_L = $2C
DSP_EVOL_R = $3C
DSP_KON    = $4C
DSP_KOFF   = $5C
DSP_FLG    = $6C
DSP_ENDX   = $7C
DSP_PMON   = $2D
DSP_NON    = $3D
DSP_EON    = $4D
DSP_DIR    = $5D
DSP_ESA    = $6D
DSP_EDL    = $7D

; --- Commands ---
CMD_PLAY    = $01
CMD_STOP    = $02

; --- Direct page variables ---
LastCounter = $00       ; last command counter seen
CurVoice    = $01       ; round-robin voice index (0-3)
TempA       = $02       ; scratch
DspBase     = $03       ; voice DSP base (replaces push/pop)

; ============================================================================
; CODE segment — entry point at $0200
; ============================================================================
.segment "CODE"

; --- Entry point ---
Init:
    ; DSP init via table — walk register/value pairs
    mov x, #$00
@dsp_loop:
    mov a, !DspInitTable+x
    cmp a, #$FF
    beq @dsp_done
    mov y, a              ; Y = register
    inc x
    mov a, !DspInitTable+x ; A = value
    WRITE_DSP
    inc x
    bra @dsp_loop
@dsp_done:

    ; Unmute (FLG: keep echo disabled, clear mute bit)
    mov y, #DSP_FLG
    mov a, #$20           ; bit5=echo off, bit6=mute off
    WRITE_DSP

    ; Init direct page vars
    mov a, #$00
    mov <LastCounter, a
    mov <CurVoice, a

    ; Signal ready to 65816: write 0 to all output ports
    mov APUIO0, a
    mov APUIO1, a
    mov APUIO2, a
    mov APUIO3, a

; --- Main loop: poll for commands ---
MainLoop:
    mov a, APUIO0
    cmp a, <LastCounter
    beq MainLoop            ; no new command

    ; New command — save counter
    mov <TempA, a

    ; Read command byte
    mov a, APUIO1

    cmp a, #CMD_PLAY
    beq DoPlay

    cmp a, #CMD_STOP
    beq DoStop

    ; Unknown command — just acknowledge
    bra Acknowledge

; --- CMD_PLAY: play SFX ---
DoPlay:
    ; Get SFX ID from APUIO2
    mov a, APUIO2

    ; Clamp to 0-10
    cmp a, #11
    bcc @id_ok
    mov a, #$00
@id_ok:
    ; Look up pitch from SfxPitchTable (2 bytes per entry)
    asl a               ; A = ID * 2
    mov x, a

    ; Get voice number (0-3), compute DSP base = voice * $10
    mov a, <CurVoice
    xcn a                ; swap nibbles: 0→$00, 1→$10, 2→$20, 3→$30
    mov <DspBase, a      ; save to direct page (no stack needed)

    ; --- Set voice registers ---
    ; VOL_L
    mov y, a             ; Y = DSP base + $00 = VOL_L
    mov a, #$60          ; volume
    WRITE_DSP

    ; VOL_R
    mov a, <DspBase
    or a, #DSP_VOL_R
    mov y, a
    mov a, #$60
    WRITE_DSP

    ; PITCH_L
    mov a, <DspBase
    or a, #DSP_PITCH_L
    mov y, a
    mov a, !SfxPitchTable+x
    WRITE_DSP

    ; PITCH_H
    mov a, <DspBase
    or a, #DSP_PITCH_H
    mov y, a
    inc x
    mov a, !SfxPitchTable+x
    WRITE_DSP

    ; SRCN (sample 0 for all SFX)
    mov a, <DspBase
    or a, #DSP_SRCN
    mov y, a
    mov a, #$00          ; sample index 0
    WRITE_DSP

    ; ADSR1 — enable ADSR, attack=15, decay=7
    mov a, <DspBase
    or a, #DSP_ADSR1
    mov y, a
    mov a, #$FF
    WRITE_DSP

    ; ADSR2 — sustain level=7, sustain rate=0
    mov a, <DspBase
    or a, #DSP_ADSR2
    mov y, a
    mov a, #$E0
    WRITE_DSP

    ; KON — trigger voice
    mov a, <CurVoice
    mov y, a
    mov a, !KonBits+y
    mov y, #DSP_KON
    WRITE_DSP

    ; Advance round-robin voice
    mov a, <CurVoice
    inc a
    and a, #$03          ; wrap 0-3
    mov <CurVoice, a

    bra Acknowledge

; --- CMD_STOP: key off all voices ---
DoStop:
    mov y, #DSP_KOFF
    mov a, #$0F          ; voices 0-3
    WRITE_DSP
    ; Fall through to Acknowledge

; --- Acknowledge: echo counter back ---
Acknowledge:
    mov a, <TempA
    mov <LastCounter, a
    mov APUIO0, a        ; echo counter to 65816
    jmp !MainLoop

; ============================================================================
; DSP init table: pairs of (register, value), terminated by $FF
; ============================================================================
DspInitTable:
    .byte DSP_FLG,    $60     ; mute + echo disable
    .byte DSP_MVOL_L, $7F     ; master volume L
    .byte DSP_MVOL_R, $7F     ; master volume R
    .byte DSP_EVOL_L, $00     ; echo volume L = 0
    .byte DSP_EVOL_R, $00     ; echo volume R = 0
    .byte DSP_DIR,    >SampleDir  ; DIR page (high byte of directory address)
    .byte DSP_KOFF,   $FF     ; key off all voices
    .byte DSP_PMON,   $00     ; no pitch modulation
    .byte DSP_NON,    $00     ; no noise
    .byte DSP_EON,    $00     ; no echo on voices
    .byte DSP_ENDX,   $00     ; clear end flags
    .byte $FF                  ; end marker

; ============================================================================
; SFX pitch table — 11 entries (low, high) for each SFX ID
; ============================================================================
SfxPitchTable:
    .word $1000           ; SFX_HIT      — mid-low
    .word $0800           ; SFX_MISS     — low
    .word $0600           ; SFX_HURT     — low rumble
    .word $2000           ; SFX_KILL     — high
    .word $1800           ; SFX_CHEST    — mid-high
    .word $0400           ; SFX_STAIRS   — low thud
    .word $1400           ; SFX_TRAP     — mid
    .word $1C00           ; SFX_BUY      — bright
    .word $2800           ; SFX_QUEST    — high bright
    .word $0300           ; SFX_GAMEOVER — very low
    .word $3000           ; SFX_MAGIC    — very high

; KON bit lookup — voice 0-3
KonBits:
    .byte $01, $02, $04, $08

; ============================================================================
; DIRECTORY segment — sample directory (page-aligned)
; ============================================================================
.segment "DIRECTORY"

SampleDir:
    .word SquareWaveBRR   ; start address
    .word SquareWaveBRR   ; loop address

; ============================================================================
; BRRDATA segment — BRR sample data
; One 9-byte BRR block: square wave
; ============================================================================
.segment "BRRDATA"

SquareWaveBRR:
    .byte $C3              ; header: shift=12, filter=0, loop+end flags
    .byte $77, $77, $77, $77  ; +7 +7 +7 +7 +7 +7 +7 +7
    .byte $88, $88, $88, $88  ; -8 -8 -8 -8 -8 -8 -8 -8
