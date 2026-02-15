; engine.s — SPC700 audio engine for Akalabeth (Phase 23)
; Assembled with ca65 --cpu none (spc-ca65.inc provides the instruction set)
;
; ARAM layout (contiguous):
;   $0000-$00FF  Direct page (variables)
;   $0100-$01FF  Stack (unused — no CALL/RET)
;   $0200+       Code + data + directory + BRR
;
; Command protocol (counter-based):
;   APUIO0 ($F4): command counter — change triggers command processing
;   APUIO1 ($F5): command byte (CMD_PLAY=$01, CMD_STOP=$02, CMD_AMBIENCE=$03)
;   APUIO2 ($F6): SFX ID (0-10) or ambience type (0-2)
;   SPC echoes counter back to $F4 to acknowledge
;
; Features:
;   - 4 BRR waveforms: square, triangle, sawtooth, noise-burst
;   - Per-SFX config: sample, ADSR, volume, pitch
;   - Round-robin SFX voices 0-3
;   - Ambient drone on voice 4 (CMD_AMBIENCE)
;   - Echo on magic SFX (voice-specific EON)
;
; NOTE: All DSP writes are inlined (no subroutine calls).
; spc-ca65.inc CALL/RET was found to crash during Phase 22 debugging.

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
DSP_EFB    = $0D
DSP_FIR0   = $0F
DSP_FIR1   = $1F
DSP_FIR2   = $2F
DSP_FIR3   = $3F
DSP_FIR4   = $4F
DSP_FIR5   = $5F
DSP_FIR6   = $6F
DSP_FIR7   = $7F

; --- Commands ---
CMD_PLAY      = $01
CMD_STOP      = $02
CMD_AMBIENCE  = $03

; --- Direct page variables ---
LastCounter = $00       ; last command counter seen
CurVoice    = $01       ; round-robin voice index (0-3)
TempA       = $02       ; scratch
DspBase     = $03       ; voice DSP base
ShadowNON   = $04       ; current NON register value
ShadowEON   = $05       ; current EON register value
AmbType     = $06       ; current ambience type (0=off, 1=overworld, 2=dungeon)
SfxId       = $07       ; current SFX ID being processed

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

    ; Unmute (FLG: echo disabled, mute off)
    mov y, #DSP_FLG
    mov a, #$20           ; bit5=echo off, bit6=mute off
    WRITE_DSP

    ; Init direct page vars
    mov a, #$00
    mov <LastCounter, a
    mov <CurVoice, a
    mov <ShadowNON, a
    mov <ShadowEON, a
    mov <AmbType, a

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

    ; Read command byte — use JMP dispatch to avoid branch range issues
    mov a, APUIO1

    cmp a, #CMD_PLAY
    beq DoPlay

    cmp a, #CMD_STOP
    beq DoStop

    cmp a, #CMD_AMBIENCE
    beq @go_ambience

    ; Unknown command — just acknowledge
    bra Acknowledge

@go_ambience:
    jmp !DoAmbience

; --- CMD_STOP: key off all voices ---
DoStop:
    mov y, #DSP_KOFF
    mov a, #$1F          ; voices 0-4 (SFX + ambient)
    WRITE_DSP

    ; Clear ambience state
    mov a, #$00
    mov <AmbType, a

    ; Clear noise and echo
    mov <ShadowNON, a
    mov y, #DSP_NON
    WRITE_DSP
    mov a, #$00
    mov <ShadowEON, a
    mov y, #DSP_EON
    WRITE_DSP

    ; Disable echo output
    mov y, #DSP_EVOL_L
    mov a, #$00
    WRITE_DSP
    mov y, #DSP_EVOL_R
    mov a, #$00
    WRITE_DSP

    bra Acknowledge

; --- Acknowledge: echo counter back ---
Acknowledge:
    mov a, <TempA
    mov <LastCounter, a
    mov APUIO0, a        ; echo counter to 65816
    jmp !MainLoop

; --- CMD_PLAY: play SFX using per-SFX config table ---
DoPlay:
    ; Get SFX ID from APUIO2
    mov a, APUIO2

    ; Clamp to 0-10
    cmp a, #11
    bcc @id_ok
    mov a, #$00
@id_ok:
    mov <SfxId, a

    ; Look up config: 8 bytes per entry
    ; Multiply ID * 8: shift left 3
    asl a
    asl a
    asl a
    mov x, a              ; X = offset into SfxConfigTable

    ; Get voice number (0-3), compute DSP base = voice * $10
    mov a, <CurVoice
    xcn a                ; swap nibbles: 0→$00, 1→$10, 2→$20, 3→$30
    mov <DspBase, a

    ; --- SRCN (sample index) ---
    mov a, <DspBase
    or a, #DSP_SRCN
    mov y, a
    mov a, !SfxConfigTable+x  ; byte 0 = sample index
    WRITE_DSP

    ; --- ADSR1 ---
    mov a, <DspBase
    or a, #DSP_ADSR1
    mov y, a
    inc x
    mov a, !SfxConfigTable+x  ; byte 1 = ADSR1
    WRITE_DSP

    ; --- ADSR2 ---
    mov a, <DspBase
    or a, #DSP_ADSR2
    mov y, a
    inc x
    mov a, !SfxConfigTable+x  ; byte 2 = ADSR2
    WRITE_DSP

    ; --- VOL_L ---
    mov a, <DspBase
    ; DSP_VOL_L = $00, so base alone is the register
    mov y, a
    inc x
    mov a, !SfxConfigTable+x  ; byte 3 = volume
    WRITE_DSP

    ; --- VOL_R ---
    mov a, <DspBase
    or a, #DSP_VOL_R
    mov y, a
    mov a, !SfxConfigTable+x  ; same volume for R
    WRITE_DSP

    ; --- PITCH_L ---
    mov a, <DspBase
    or a, #DSP_PITCH_L
    mov y, a
    inc x
    mov a, !SfxConfigTable+x  ; byte 4 = pitch low
    WRITE_DSP

    ; --- PITCH_H ---
    mov a, <DspBase
    or a, #DSP_PITCH_H
    mov y, a
    inc x
    mov a, !SfxConfigTable+x  ; byte 5 = pitch high
    WRITE_DSP

    ; --- Flags byte (byte 6): bit0=noise, bit1=echo ---
    inc x
    mov a, !SfxConfigTable+x  ; byte 6 = flags

    ; Handle noise flag (bit 0)
    and a, #$01
    beq @no_noise
    ; Set noise: OR current voice bit into ShadowNON
    mov a, <CurVoice
    mov y, a
    mov a, !KonBits+y
    or a, <ShadowNON
    mov <ShadowNON, a
    mov y, #DSP_NON
    WRITE_DSP
    bra @check_echo
@no_noise:
    ; Clear noise for this voice: AND out the voice bit
    mov a, <CurVoice
    mov y, a
    mov a, !KonBitsInv+y
    and a, <ShadowNON
    mov <ShadowNON, a
    mov y, #DSP_NON
    WRITE_DSP

@check_echo:
    ; Re-read flags
    mov a, !SfxConfigTable+x  ; byte 6 again
    and a, #$02
    beq @no_echo
    ; Enable echo for this voice
    mov a, <CurVoice
    mov y, a
    mov a, !KonBits+y
    or a, <ShadowEON
    mov <ShadowEON, a
    mov y, #DSP_EON
    WRITE_DSP
    ; Enable echo output
    mov y, #DSP_EVOL_L
    mov a, #$20
    WRITE_DSP
    mov y, #DSP_EVOL_R
    mov a, #$20
    WRITE_DSP
    ; Enable echo in FLG (clear bit 5)
    mov y, #DSP_FLG
    mov a, #$00
    WRITE_DSP
    bra @do_kon
@no_echo:
    ; Clear echo for this voice
    mov a, <CurVoice
    mov y, a
    mov a, !KonBitsInv+y
    and a, <ShadowEON
    mov <ShadowEON, a
    mov y, #DSP_EON
    WRITE_DSP

@do_kon:
    ; KON — trigger voice
    mov a, <CurVoice
    mov y, a
    mov a, !KonBits+y
    mov y, #DSP_KON
    WRITE_DSP

    ; Advance round-robin voice (0-3)
    mov a, <CurVoice
    inc a
    and a, #$03
    mov <CurVoice, a

    jmp !Acknowledge

; --- CMD_AMBIENCE: set ambient drone on voice 4 ---
DoAmbience:
    mov a, APUIO2         ; 0=off, 1=overworld, 2=dungeon

    ; If same as current, just ack
    cmp a, <AmbType
    beq @amb_done
    mov <AmbType, a

    ; If 0, key off voice 4
    cmp a, #$00
    bne @amb_start
    mov y, #DSP_KOFF
    mov a, #$10           ; voice 4 bit
    WRITE_DSP
    bra @amb_done

@amb_start:
    ; Voice 4 base = $40
    ; SRCN: overworld=2 (sawtooth), dungeon=1 (triangle)
    mov y, #$44           ; voice 4 SRCN
    cmp a, #$01
    bne @amb_dung
    mov a, #$02           ; sawtooth for overworld
    bra @amb_srcn
@amb_dung:
    mov a, #$01           ; triangle for dungeon
@amb_srcn:
    WRITE_DSP

    ; ADSR1: slow attack, no decay (sustain forever)
    mov y, #$45           ; voice 4 ADSR1
    mov a, #$8A           ; ADSR on, attack=10(~40ms), decay=0
    WRITE_DSP

    ; ADSR2: sustain level=7, sustain rate=0 (never decay)
    mov y, #$46           ; voice 4 ADSR2
    mov a, #$E0
    WRITE_DSP

    ; Volume — quiet
    mov y, #$40           ; voice 4 VOL_L
    mov a, #$18
    WRITE_DSP
    mov y, #$41           ; voice 4 VOL_R
    mov a, #$18
    WRITE_DSP

    ; Pitch — very low drone
    mov y, #$42           ; voice 4 PITCH_L
    mov a, #$00
    WRITE_DSP
    mov y, #$43           ; voice 4 PITCH_H
    mov a, #$04           ; $0400 = low pitch
    WRITE_DSP

    ; KON voice 4
    mov y, #DSP_KON
    mov a, #$10
    WRITE_DSP

@amb_done:
    jmp !Acknowledge

; ============================================================================
; DSP init table: pairs of (register, value), terminated by $FF
; ============================================================================
DspInitTable:
    .byte DSP_FLG,    $60     ; mute + echo disable
    .byte DSP_MVOL_L, $7F     ; master volume L
    .byte DSP_MVOL_R, $7F     ; master volume R
    .byte DSP_EVOL_L, $00     ; echo volume L = 0
    .byte DSP_EVOL_R, $00     ; echo volume R = 0
    .byte DSP_DIR,    >SampleDir  ; DIR page
    .byte DSP_KOFF,   $FF     ; key off all voices
    .byte DSP_PMON,   $00     ; no pitch modulation
    .byte DSP_NON,    $00     ; no noise
    .byte DSP_EON,    $00     ; no echo on voices
    .byte DSP_ENDX,   $00     ; clear end flags
    ; Echo config (pre-configure, stays disabled until magic SFX)
    .byte DSP_ESA,    $0E     ; echo buffer at $0E00 (end of ARAM)
    .byte DSP_EDL,    $01     ; echo delay = 1 (2KB buffer)
    .byte DSP_EFB,    $40     ; echo feedback = moderate
    ; FIR filter: simple low-pass
    .byte DSP_FIR0,   $7F     ; tap 0
    .byte DSP_FIR1,   $00     ; tap 1
    .byte DSP_FIR2,   $00     ; tap 2
    .byte DSP_FIR3,   $00     ; tap 3
    .byte DSP_FIR4,   $00     ; tap 4
    .byte DSP_FIR5,   $00     ; tap 5
    .byte DSP_FIR6,   $00     ; tap 6
    .byte DSP_FIR7,   $00     ; tap 7
    .byte $FF                  ; end marker

; ============================================================================
; Per-SFX config table — 11 entries × 8 bytes each
; Format: sample_idx, ADSR1, ADSR2, volume, pitch_lo, pitch_hi, flags, pad
; Flags: bit0=noise, bit1=echo
; ============================================================================
SfxConfigTable:
    ; SFX_HIT ($00) — sharp attack, square wave, mid-low pitch
    .byte $00, $FF, $A0, $60, $00, $10, $00, $00

    ; SFX_MISS ($01) — noise burst, fast decay
    .byte $00, $EF, $60, $40, $00, $08, $01, $00

    ; SFX_HURT ($02) — low rumble, triangle wave, slow decay
    .byte $01, $DF, $80, $50, $00, $06, $00, $00

    ; SFX_KILL ($03) — bright chime, sawtooth, high pitch
    .byte $02, $FF, $C0, $60, $00, $20, $00, $00

    ; SFX_CHEST ($04) — sparkle, triangle, mid-high
    .byte $01, $FF, $A0, $50, $00, $18, $00, $00

    ; SFX_STAIRS ($05) — thud, square, low, fast decay
    .byte $00, $CF, $40, $50, $00, $04, $00, $00

    ; SFX_TRAP ($06) — alarm, sawtooth, mid pitch
    .byte $02, $FF, $80, $60, $00, $14, $00, $00

    ; SFX_BUY ($07) — coin, triangle, bright
    .byte $01, $FF, $A0, $50, $00, $1C, $00, $00

    ; SFX_QUEST ($08) — fanfare, sawtooth, high bright
    .byte $02, $FF, $E0, $60, $00, $28, $00, $00

    ; SFX_GAMEOVER ($09) — descending, square, very low, long sustain
    .byte $00, $8F, $E0, $60, $00, $03, $00, $00

    ; SFX_MAGIC ($0A) — shimmer, triangle, very high, with echo
    .byte $01, $FF, $E0, $50, $00, $30, $02, $00

; KON bit lookup — voice 0-3
KonBits:
    .byte $01, $02, $04, $08

; Inverted KON bits — for clearing individual voice bits
KonBitsInv:
    .byte $FE, $FD, $FB, $F7

; ============================================================================
; DIRECTORY segment — sample directory (page-aligned)
; 4 entries × 4 bytes = 16 bytes
; ============================================================================
.segment "DIRECTORY"

SampleDir:
    ; Sample 0: Square wave
    .word SquareWaveBRR   ; start address
    .word SquareWaveBRR   ; loop address
    ; Sample 1: Triangle wave
    .word TriangleWaveBRR
    .word TriangleWaveBRR
    ; Sample 2: Sawtooth wave
    .word SawtoothWaveBRR
    .word SawtoothWaveBRR
    ; Sample 3: Noise burst (short, no loop)
    .word NoiseBurstBRR
    .word NoiseBurstBRR

; ============================================================================
; BRRDATA segment — BRR sample data
; Each BRR block = 9 bytes (1 header + 8 data = 16 4-bit samples)
; Header: bits 7-4=shift, 3-2=filter, 1=loop, 0=end
; ============================================================================
.segment "BRRDATA"

; --- Sample 0: Square wave (1 block, looping) ---
SquareWaveBRR:
    .byte $C3              ; shift=12, filter=0, loop+end
    .byte $77, $77, $77, $77  ; +7 +7 +7 +7 +7 +7 +7 +7
    .byte $88, $88, $88, $88  ; -8 -8 -8 -8 -8 -8 -8 -8

; --- Sample 1: Triangle wave (2 blocks, looping) ---
TriangleWaveBRR:
    .byte $B2              ; shift=11, filter=0, loop, NOT end
    .byte $01, $23, $45, $67  ; ramp up: 0,1,2,3,4,5,6,7
    .byte $76, $54, $32, $10  ; ramp down: 7,6,5,4,3,2,1,0
    .byte $B3              ; shift=11, filter=0, loop+end
    .byte $0F, $ED, $CB, $A9  ; ramp down: 0,-1,-2,-3,-4,-5,-6,-7
    .byte $9A, $BC, $DE, $F0  ; ramp up: -7,-6,-5,-4,-3,-2,-1,0

; --- Sample 2: Sawtooth wave (1 block, looping) ---
SawtoothWaveBRR:
    .byte $B3              ; shift=11, filter=0, loop+end
    .byte $01, $23, $45, $67  ; ramp up: 0,1,2,3,4,5,6,7
    .byte $89, $AB, $CD, $EF  ; continues: -8,-7,-6,-5,-4,-3,-2,-1

; --- Sample 3: Noise burst (1 block, no loop) ---
NoiseBurstBRR:
    .byte $C1              ; shift=12, filter=0, end (no loop)
    .byte $73, $A5, $18, $C6  ; pseudo-random values
    .byte $4D, $92, $B7, $3E
