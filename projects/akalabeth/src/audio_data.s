; audio_data.s — SPC700 engine binary + audio data
; The SPC700 engine is assembled separately (spc/engine.s → build/spc700.bin)
; and included here as a binary blob for upload to ARAM.

.include "macros.s"

.export SpcImage, SpcImageSize, SpcEntryAddr

; ============================================================================
; AUDIODATA segment — lives in ROM bank 1 ($018000-$01FFFF)
; ============================================================================

.segment "AUDIODATA"

; SPC700 engine binary (code + directory + BRR data)
; Loaded to ARAM $0200 by SpcBootApu (lib/spc.s)
SpcImage:
    .incbin "../build/spc700.bin"
SpcImageEnd:

; Size and entry point (used by SpcBootApu)
.segment "CODE"
SpcImageSize:   .word SpcImageEnd - SpcImage
SpcEntryAddr:   .word $0200             ; ARAM entry point
