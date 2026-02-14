; ui.s — Akalabeth UI system
; Stats bar, message log, text engine on BG3

.include "macros.s"

.export UiInit, UiDrawStats, UiShowTitle, UiShowShop, UiShowCastle
.export Bg3Tilemap
.exportzp StatsDirty

.importzp PlayerHP, PlayerFood, PlayerGold, PlayerWeapon, PlayerQuest
.import GfxUploadFont

; ============================================================================
; Constants
; ============================================================================

; BG3 tilemap entry: tile_number | (palette << 10)
; Palette 1 for font colors → high byte bit 2 set = $04
FONT_ATTR       = $04       ; High byte: palette 1

MSG_ROW         = 26        ; Tilemap row for messages (near bottom)
STATS_ROW       = 0         ; Tilemap row for stats bar

; Hardware divider result registers
RDDIVL          = $4214     ; Quotient low
RDDIVH          = $4215     ; Quotient high
RDMPYL          = $4216     ; Remainder low
RDMPYH          = $4217     ; Remainder high

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
StatsDirty:     .res 1
UI_TempA:       .res 1
UI_TempB:       .res 1
UI_TempPtr:     .res 2      ; Pointer to string for PrintString
UI_DivQuot:     .res 2      ; 16-bit value for PrintNum16

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
Bg3Tilemap:     .res 2048   ; 32x32 BG3 tilemap buffer
NumBuf:         .res 6      ; Decimal conversion buffer (5 digits + null)

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; UiInit — clear BG3 tilemap buffer
; ============================================================================
.proc UiInit
    SET_AXY16
    ldx #$0000
    lda #$0000
@clear:
    sta Bg3Tilemap,x
    inx
    inx
    cpx #2048
    bne @clear
    SET_A8
    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; PrintString — write null-terminated string to BG3 tilemap at row/col
; Input: X = col (0-31), Y = row (0-31), UI_TempPtr = pointer to string
; Clobbers: A, X, Y
; ============================================================================
.proc PrintString
    SET_AXY8

    ; Save col and row
    stx UI_TempA            ; col
    sty UI_TempB            ; row

    ; Calculate byte offset: (row * 32 + col) * 2
    lda UI_TempB            ; row
    sta UI_DivQuot
    stz UI_DivQuot+1
    SET_A16
    lda UI_DivQuot
    asl
    asl
    asl
    asl
    asl                     ; * 32
    sta UI_DivQuot
    SET_A8
    lda UI_TempA            ; col
    SET_A16
    and #$00FF
    clc
    adc UI_DivQuot          ; word index
    asl                     ; * 2 = byte offset
    SET_XY16
    tax                     ; X = offset into Bg3Tilemap

    SET_A8
    ldy #$00                ; String source index

@loop:
    lda (UI_TempPtr),y
    beq @done               ; Null terminator
    sec
    sbc #$20                ; ASCII $20 → tile 0
    sta Bg3Tilemap,x        ; Tile number
    lda #FONT_ATTR
    sta Bg3Tilemap+1,x      ; Palette/priority
    inx
    inx
    iny
    cpy #30                 ; Safety limit
    bne @loop

@done:
    rts
.endproc

; ============================================================================
; PrintNum16 — convert 16-bit value to decimal, print at row/col
; Input: UI_DivQuot = 16-bit value, X = col, Y = row
; ============================================================================
.proc PrintNum16
    SET_XY8
    stx UI_TempA            ; Save col
    sty UI_TempB            ; Save row
    SET_A8

    ; Fill NumBuf with spaces then null-terminate
    lda #' '
    sta NumBuf
    sta NumBuf+1
    sta NumBuf+2
    sta NumBuf+3
    sta NumBuf+4
    stz NumBuf+5            ; Null terminator

    ldx #$04                ; Write position (rightmost digit)

    ; Special case: value == 0
    SET_A16
    lda UI_DivQuot
    bne @div_loop
    SET_A8
    lda #'0'
    sta NumBuf,x
    jmp @print

@div_loop:
    SET_A16
    lda UI_DivQuot
    beq @print

    ; SNES hardware divider: write dividend then divisor
    SET_A8
    lda UI_DivQuot
    sta WRDIVL
    lda UI_DivQuot+1
    sta WRDIVH
    lda #10
    sta WRDIVB              ; Triggers division

    ; Must wait 16 machine cycles after writing WRDIVB
    nop                     ; 2 cycles each × 8 = 16 cycles
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    ; Remainder at $4216 = digit
    lda RDMPYL
    clc
    adc #'0'
    sta NumBuf,x
    dex

    ; Quotient at $4214-$4215 → new dividend
    lda RDDIVL
    sta UI_DivQuot
    lda RDDIVH
    sta UI_DivQuot+1

    jmp @div_loop

@print:
    SET_A8
    ; Find first non-space character to left-justify
    ; Actually, just print from NumBuf as-is (right-justified with spaces)
    lda #<NumBuf
    sta UI_TempPtr
    lda #>NumBuf
    sta UI_TempPtr+1
    ldx UI_TempA            ; Restore col
    ldy UI_TempB            ; Restore row
    jsr PrintString

    rts
.endproc

; ============================================================================
; UiDrawStats — compose stats bar on BG3
; Format: "HP:nnn FD:nnn GP:nnn"
; ============================================================================
.proc UiDrawStats
    SET_A8

    lda StatsDirty
    beq @done

    ; Clear stats row first (write spaces)
    lda #<str_blank
    sta UI_TempPtr
    lda #>str_blank
    sta UI_TempPtr+1
    ldx #$00
    ldy #STATS_ROW
    jsr PrintString

    ; "HP:" at col 1
    lda #<str_hp
    sta UI_TempPtr
    lda #>str_hp
    sta UI_TempPtr+1
    ldx #$01
    ldy #STATS_ROW
    jsr PrintString

    ; HP value at col 4
    SET_A16
    lda PlayerHP
    sta UI_DivQuot
    SET_A8
    ldx #$04
    ldy #STATS_ROW
    jsr PrintNum16

    ; "FD:" at col 10
    lda #<str_fd
    sta UI_TempPtr
    lda #>str_fd
    sta UI_TempPtr+1
    ldx #$0A
    ldy #STATS_ROW
    jsr PrintString

    ; Food value at col 13
    SET_A16
    lda PlayerFood
    sta UI_DivQuot
    SET_A8
    ldx #$0D
    ldy #STATS_ROW
    jsr PrintNum16

    ; "GP:" at col 19
    lda #<str_gp
    sta UI_TempPtr
    lda #>str_gp
    sta UI_TempPtr+1
    ldx #$13
    ldy #STATS_ROW
    jsr PrintString

    ; Gold value at col 22
    SET_A16
    lda PlayerGold
    sta UI_DivQuot
    SET_A8
    ldx #$16
    ldy #STATS_ROW
    jsr PrintNum16

    lda #$01
    sta StatsDirty          ; Signal NMI to DMA

@done:
    rts
.endproc

; ============================================================================
; UiClearBg3 — clear entire BG3 tilemap buffer
; ============================================================================
.proc UiClearBg3
    SET_AXY16
    ldx #$0000
    lda #$0000
@clear:
    sta Bg3Tilemap,x
    inx
    inx
    cpx #2048
    bne @clear
    SET_A8
    rts
.endproc

; ============================================================================
; UiShowTitle — display title screen text on BG3
; ============================================================================
.proc UiShowTitle
    SET_A8
    jsr UiClearBg3

    ; Configure PPU for text-only display
    lda #$01                ; Mode 1
    sta BGMODE
    lda #$30                ; BG3 tilemap at $3000
    sta BG3SC
    lda #$01                ; BG3 char base = word $1000
    sta BG34NBA
    lda #$04                ; Enable BG3 only
    sta TM

    ; Title text
    lda #<str_title1
    sta UI_TempPtr
    lda #>str_title1
    sta UI_TempPtr+1
    ldx #$04
    ldy #$08
    jsr PrintString

    lda #<str_title2
    sta UI_TempPtr
    lda #>str_title2
    sta UI_TempPtr+1
    ldx #$05
    ldy #$0A
    jsr PrintString

    lda #<str_press_start
    sta UI_TempPtr
    lda #>str_press_start
    sta UI_TempPtr+1
    ldx #$09
    ldy #$10
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowShop — display shop menu on BG3
; ============================================================================
.proc UiShowShop
    SET_A8

    ; Only redraw if entering (check a flag or just always draw — simple approach)
    jsr UiClearBg3

    lda #<str_shop_title
    sta UI_TempPtr
    lda #>str_shop_title
    sta UI_TempPtr+1
    ldx #$06
    ldy #$04
    jsr PrintString

    lda #<str_shop_food
    sta UI_TempPtr
    lda #>str_shop_food
    sta UI_TempPtr+1
    ldx #$04
    ldy #$08
    jsr PrintString

    lda #<str_shop_a_buy
    sta UI_TempPtr
    lda #>str_shop_a_buy
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0C
    jsr PrintString

    lda #<str_shop_b_leave
    sta UI_TempPtr
    lda #>str_shop_b_leave
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0E
    jsr PrintString

    ; Show gold
    lda #<str_gp
    sta UI_TempPtr
    lda #>str_gp
    sta UI_TempPtr+1
    ldx #$04
    ldy #$12
    jsr PrintString

    SET_A16
    lda PlayerGold
    sta UI_DivQuot
    SET_A8
    ldx #$07
    ldy #$12
    jsr PrintNum16

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowCastle — display castle/quest screen on BG3
; ============================================================================
.proc UiShowCastle
    SET_A8
    jsr UiClearBg3

    lda #<str_castle_title
    sta UI_TempPtr
    lda #>str_castle_title
    sta UI_TempPtr+1
    ldx #$04
    ldy #$04
    jsr PrintString

    ; Check if quest completed
    lda PlayerQuest
    bmi @show_complete

    ; Show current quest: "SEEK THE <monster>"
    lda #<str_seek
    sta UI_TempPtr
    lda #>str_seek
    sta UI_TempPtr+1
    ldx #$04
    ldy #$08
    jsr PrintString

    lda #<str_castle_b
    sta UI_TempPtr
    lda #>str_castle_b
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0E
    jsr PrintString

    jmp @done_castle

@show_complete:
    lda #<str_quest_done
    sta UI_TempPtr
    lda #>str_quest_done
    sta UI_TempPtr+1
    ldx #$04
    ldy #$08
    jsr PrintString

    lda #<str_castle_a
    sta UI_TempPtr
    lda #>str_castle_a
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0C
    jsr PrintString

@done_castle:
    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; RODATA — static strings
; ============================================================================

.segment "RODATA"

str_hp:     .byte "HP:", $00
str_fd:     .byte "FD:", $00
str_gp:     .byte "GP:", $00
str_blank:  .byte "                                ", $00

str_title1:
    .byte "AKALABETH", $00
str_title2:
    .byte "WORLD OF DOOM", $00
str_press_start:
    .byte "PRESS START", $00

str_shop_title:
    .byte "--- SHOPPE ---", $00
str_shop_food:
    .byte "FOOD: 10 PER GOLD", $00
str_shop_a_buy:
    .byte "A: BUY FOOD", $00
str_shop_b_leave:
    .byte "B: LEAVE", $00

str_castle_title:
    .byte "--- LORD BRITISH ---", $00
str_seek:
    .byte "SEEK AND DESTROY!", $00
str_quest_done:
    .byte "QUEST COMPLETE!", $00
str_castle_a:
    .byte "A: NEXT QUEST", $00
str_castle_b:
    .byte "B: LEAVE", $00
