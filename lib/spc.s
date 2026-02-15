; spc.s — SPC700 boot loader (IPL ROM protocol)
; Adapted from blargg's SPC boot interface (snesgss-extended)
; Generic SPC upload code — reusable across all projects.
;
; Usage:
;   1. jsr SpcWaitBoot
;   2. jsr SpcBeginUpload (Y = dest addr in ARAM)
;   3. jsr SpcUploadByte  (A = byte) — repeat as needed
;   4. jsr SpcExecute      (Y = exec addr) — starts SPC program
;
; High-level: jsr SpcBootApu uploads SpcImage and starts execution.

.include "macros.s"

.export SpcWaitBoot, SpcBeginUpload, SpcUploadByte, SpcExecute
.export SpcBootApu

; Imports for SPC image (provided by audio_data.s)
.import SpcImage, SpcImageSize, SpcEntryAddr

.segment "CODE"

; ============================================================================
; SpcWaitBoot — wait for IPL ROM ready ($BBAA on APUIO0/1)
; Clobbers: A. Preserves: X, Y
; ============================================================================
.proc SpcWaitBoot
    SET_A8
    ; Clear port in case it already has $CC from a previous transfer
    stz APUIO0
    ; Wait for SPC to signal ready: APUIO0=$AA, APUIO1=$BB
    SET_A16
    lda #$BBAA
@wait:
    cmp APUIO0
    bne @wait
    SET_A8
    rts
.endproc

; ============================================================================
; SpcBeginUpload — start upload to ARAM address in Y
; Sets Y=0 for use as index with SpcUploadByte.
; Clobbers: A, Y. Preserves: X
; ============================================================================
.proc SpcBeginUpload
    SET_A8
    sty APUIO2

    ; First value to APUIO0 must be $CC; subsequent must be nonzero
    ; and >= previous+2. Adding $22 to current value always works.
    lda APUIO0
    clc
    adc #$22
    bne @skip           ; Ensure nonzero (zero = start execution)
    inc a
@skip:
    sta APUIO1          ; Non-zero = "more data" signal
    sta APUIO0

    ; Wait for SPC to echo back
@wait:
    cmp APUIO0
    bne @wait

    ; Reset index
    ldy #0
    rts
.endproc

; ============================================================================
; SpcUploadByte — send byte in A to SPC, increment Y
; Clobbers: A. Preserves: X
; ============================================================================
.proc SpcUploadByte
    sta APUIO1          ; Data byte

    ; Send counter (low byte of Y) as handshake
    tya
    sta APUIO0
    iny

    ; Wait for SPC to echo counter
@wait:
    cmp APUIO0
    bne @wait
    rts
.endproc

; ============================================================================
; SpcExecute — end transfer, start execution at ARAM address in Y
; Clobbers: A. Preserves: X, Y
; ============================================================================
.proc SpcExecute
    SET_A8
    sty APUIO2          ; Execution address
    stz APUIO1          ; Zero = "start execution" signal

    ; Send final handshake (must be > previous counter)
    lda APUIO0
    clc
    adc #$22
    sta APUIO0

    ; Wait for echo
@wait:
    cmp APUIO0
    bne @wait
    rts
.endproc

; ============================================================================
; SpcBootApu — upload entire SPC image from ROM to ARAM, start execution
; Handles multi-page uploads (IPL protocol requires new SpcBeginUpload every
; 256 bytes when the internal counter wraps).
; Call during init (force blank). Clobbers: A, X, Y
; ============================================================================
.proc SpcBootApu
    SET_AXY8
    SET_XY16

    jsr SpcWaitBoot

    ; Begin upload at ARAM $0200 (standard driver load address)
    ldy #$0200
    jsr SpcBeginUpload

    ; Upload SPC image in 256-byte pages
    ldx #0
@loop:
    lda f:SpcImage,x
    jsr SpcUploadByte
    inx
    cpx SpcImageSize
    beq @done

    ; Check if Y wrapped (256-byte page boundary)
    tya
    bne @loop               ; low byte != 0 → same page

    ; Y low byte wrapped to 0 → start new upload block
    ; Compute next ARAM destination = $0200 + X
    phx
    SET_A16
    txa
    clc
    adc #$0200
    tay                     ; Y = next ARAM address
    SET_A8
    jsr SpcBeginUpload
    plx
    jmp @loop

@done:
    ; Start execution
    ldy SpcEntryAddr
    jsr SpcExecute
    rts
.endproc
