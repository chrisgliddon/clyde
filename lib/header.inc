; header.inc — Parameterized SNES ROM header for LoROM
; Usage: .define GAME_TITLE "YOUR TITLE           " (21 bytes)
;        then .include "header.inc"
; Requires: ResetHandler, NmiHandler, IrqHandler exported in same unit
; Reference: https://snes.nesdev.org/wiki/ROM_header

; ============================================================================
; Interrupt vectors (native + emulation mode)
; Mapped to $FFE0-$FFFF in LoROM
; ============================================================================

.segment "VECTORS"
    ; Native mode vectors ($FFE0-$FFEF)
    .addr $0000             ; $FFE0 — unused
    .addr $0000             ; $FFE2 — unused
    .addr $0000             ; $FFE4 — COP
    .addr $0000             ; $FFE6 — BRK
    .addr $0000             ; $FFE8 — ABORT
    .addr NmiHandler        ; $FFEA — NMI (VBlank)
    .addr $0000             ; $FFEC — unused
    .addr IrqHandler        ; $FFEE — IRQ

    ; Emulation mode vectors ($FFF0-$FFFF)
    .addr $0000             ; $FFF0 — unused
    .addr $0000             ; $FFF2 — unused
    .addr $0000             ; $FFF4 — COP
    .addr $0000             ; $FFF6 — unused
    .addr $0000             ; $FFF8 — ABORT
    .addr $0000             ; $FFFA — NMI
    .addr ResetHandler      ; $FFFC — RESET
    .addr $0000             ; $FFFE — IRQ/BRK

; ============================================================================
; ROM header at $7FC0 (LoROM)
; ============================================================================

.segment "HEADER"
    ; Game title — exactly 21 bytes, padded with spaces
    .byte GAME_TITLE

    .byte $20               ; Map mode: LoROM
    .byte $00               ; Cartridge type: ROM only
    .byte $07               ; ROM size: 128KB (2^7 = 128K)
    .byte $00               ; RAM size: 0KB
    .byte $01               ; Country: North America
    .byte $00               ; Developer ID
    .byte $00               ; ROM version
    .word $0000             ; Checksum complement (filled by tool/emulator)
    .word $0000             ; Checksum (filled by tool/emulator)
