; hwmath.s — Hardware math utilities (division, multiplication)

.include "macros.s"

.export HwDivide16x8

; Read-only result registers
RDDIVL      = $4214     ; Division quotient low
RDDIVH      = $4215     ; Division quotient high
RDMPYL_HW   = $4216     ; Division remainder low

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; HwDivide16x8 — unsigned 16-bit ÷ 8-bit via hardware
; Input:  A (16-bit) = dividend, Y (8-bit) = divisor
; Output: A (16-bit) = quotient, Y (8-bit) = remainder
; Assumes: A16 on entry. Returns A16.
; Clobbers: none besides A, Y
; ============================================================================
.proc HwDivide16x8
    sta WRDIVL              ; 16-bit write to $4204/$4205
    SET_A8
    sty WRDIVB              ; 8-bit divisor → triggers division
    ; Wait 16 machine cycles (8 nops = 16 cycles)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ; Read results
    ldy RDMPYL_HW           ; 8-bit remainder
    SET_A16
    lda RDDIVL              ; 16-bit quotient
    rts
.endproc
