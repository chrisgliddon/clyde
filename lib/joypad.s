; joypad.s — Production joypad handler with edge detection
; Pattern from Gargoyles Quest (GG_JOYHD.658) and BS Zelda (Routine_Macros_BSZ1.asm)
; Provides: JoyRaw (held), JoyPress (new press), JoyPrev (last frame)

.include "macros.s"

.export ReadJoypad
.exportzp JoyRaw, JoyPress, JoyPrev

; ============================================================================
; Button Constants (16-bit, active-high)
; Matches SNES hardware register layout: hi byte from $4219, lo from $4218
; ============================================================================

.export JOY_B, JOY_Y, JOY_SELECT, JOY_START
.export JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT
.export JOY_A, JOY_X, JOY_L, JOY_R

JOY_B       = $8000
JOY_Y       = $4000
JOY_SELECT  = $2000
JOY_START   = $1000
JOY_UP      = $0800
JOY_DOWN    = $0400
JOY_LEFT    = $0200
JOY_RIGHT   = $0100
JOY_A       = $0080
JOY_X       = $0040
JOY_L       = $0020
JOY_R       = $0010

; ============================================================================
; Zero Page variables
; ============================================================================

.segment "ZEROPAGE"

JoyRaw:     .res 2          ; Current frame held buttons (16-bit)
JoyPress:   .res 2          ; Newly pressed this frame only (16-bit)
JoyPrev:    .res 2          ; Previous frame state (16-bit)

; ============================================================================
; ReadJoypad — Call once per frame after VBlank
; Waits for auto-joypad to finish, reads input, computes edge detection.
; Requires: NMITIMEN bit 0 set (auto-joypad enabled)
; Clobbers: A
; ============================================================================

.segment "CODE"

.proc ReadJoypad
    SET_A8
@wait_auto:
    lda HVBJOY              ; $4212 — bit 0 = auto-read in progress
    and #$01
    bne @wait_auto

    SET_A16
    lda JoyRaw
    sta JoyPrev             ; save previous frame

    lda JOY1L               ; read 16-bit: lo=$4218, hi=$4219
    sta JoyRaw

    ; Edge detection: (current XOR previous) AND current = new presses
    eor JoyPrev
    and JoyRaw
    sta JoyPress

    SET_A8
    rts
.endproc
