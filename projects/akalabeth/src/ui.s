; ui.s — Akalabeth UI system
; Stats bar, message log, text engine on BG3

.include "macros.s"

.export UiInit, UiDrawStats, UiShowTitle, UiShowShop, UiShowCastle
.export UiShowChargenSeed, UiShowChargenStats, UiShowChargenClass
.export UiShowGameOver, UiShowVictory
.export UiClearBg3, Bg3Tilemap
.export UiTickMessage, UiSetMessage
.export UiMsgInit, UiMsgAppendStr, UiMsgAppendNum, UiMsgAppendMonName, UiMsgShow
.export str_msg_hit, str_msg_miss, str_msg_killed, str_msg_quest
.export str_msg_mon_hit, str_msg_mon_miss, str_msg_dmg
.export str_msg_thief, str_msg_rapier, str_msg_axe, str_msg_shield, str_msg_bow
.export str_msg_gremlin, str_msg_chest, str_msg_gold, str_msg_trap
.export str_msg_up, str_msg_down
.export str_msg_backfire, str_msg_toad, str_msg_magkill, str_msg_magstair
.export str_msg_crumble, str_msg_died
.exportzp StatsDirty, UI_TempPtr

.importzp PlayerHP, PlayerFood, PlayerGold, PlayerQuest
.importzp PlayerRapier, PlayerAxe, PlayerShield, PlayerBow, PlayerAmulet
.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS
.importzp PlayerClass, DiffLevel, ChargenSeed, ShopCursor
.import GfxUploadFont

; ============================================================================
; Constants
; ============================================================================

; BG3 tilemap entry: tile_number | (palette << 10)
; FontAttr ZP variable: palette attribute byte for text rendering
; $04=white(pal1), $08=green(pal2), $0C=yellow(pal3), $10=cyan(pal4), $14=red(pal5), $18=gold(pal6)

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
FontAttr:       .res 1      ; Current BG3 text palette attribute
UI_TempA:       .res 1
UI_TempB:       .res 1
UI_TempPtr:     .res 2      ; Pointer to string for PrintString
UI_DivQuot:     .res 2      ; 16-bit value for PrintNum16
MsgTimer:       .res 1      ; Countdown frames (120 = 2 sec display)
MsgBufPos:      .res 1      ; Current write position in MsgBuf

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
Bg3Tilemap:     .res 2048   ; 32x32 BG3 tilemap buffer
NumBuf:         .res 6      ; Decimal conversion buffer (5 digits + null)
MsgBuf:         .res 32     ; Composed message text buffer

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
    lda #$04                ; Default font: white (BG3 palette 1)
    sta FontAttr
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
    lda FontAttr
    sta Bg3Tilemap+1,x      ; Palette/priority
    inx
    inx
    iny
    cpy #30                 ; Safety limit
    bne @loop

@done:
    SET_AXY8                ; Restore 8-bit registers for callers
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
    SET_AXY8                ; Callers may have 16-bit XY; ensure 8-bit for ldx/ldy immediates
    lda #$04                ; White (BG3 palette 1)
    sta FontAttr

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
    SET_AXY8
    rts
.endproc

; ============================================================================
; UiShowTitle — display title screen text on BG3
; ============================================================================
.proc UiShowTitle
    SET_AXY8
    jsr UiClearBg3

    ; Configure PPU for text-only display (via shadow registers)
    lda #$01                ; Mode 1
    sta SHADOW_BGMODE
    lda #$30                ; BG3 tilemap at $3000
    sta SHADOW_BG3SC
    lda #$01                ; BG3 char base = word $1000
    sta SHADOW_BG34NBA
    lda #$04                ; Enable BG3 only
    sta SHADOW_TM

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
    SET_AXY8
    lda #$08                ; Green (BG3 palette 2)
    sta FontAttr
    jsr UiClearBg3

    ; Title
    lda #<str_shop_title
    sta UI_TempPtr
    lda #>str_shop_title
    sta UI_TempPtr+1
    ldx #$04
    ldy #$01
    jsr PrintString

    ; Column headers: PRICE  DMG  ITEM        OWN
    lda #<str_shop_hdr
    sta UI_TempPtr
    lda #>str_shop_hdr
    sta UI_TempPtr+1
    ldx #$02
    ldy #$03
    jsr PrintString

    ; Item rows (starting at row 5, col 2)
    ; Row 0: 1/10  ---  FOOD          nnn
    lda #<str_si_food
    sta UI_TempPtr
    lda #>str_si_food
    sta UI_TempPtr+1
    ldx #$02
    ldy #$05
    jsr PrintString

    ; Row 1: 8     1-10 RAPIER        n
    lda #<str_si_rapier
    sta UI_TempPtr
    lda #>str_si_rapier
    sta UI_TempPtr+1
    ldx #$02
    ldy #$07
    jsr PrintString

    ; Row 2: 5     1-5  AXE           n
    lda #<str_si_axe
    sta UI_TempPtr
    lda #>str_si_axe
    sta UI_TempPtr+1
    ldx #$02
    ldy #$09
    jsr PrintString

    ; Row 3: 6     1    SHIELD        n
    lda #<str_si_shield
    sta UI_TempPtr
    lda #>str_si_shield
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0B
    jsr PrintString

    ; Row 4: 3     1-4  BOW           n
    lda #<str_si_bow
    sta UI_TempPtr
    lda #>str_si_bow
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0D
    jsr PrintString

    ; Row 5: 15    ???  MAGIC AMULET  n
    lda #<str_si_amulet
    sta UI_TempPtr
    lda #>str_si_amulet
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0F
    jsr PrintString

    ; Show owned counts at col 26
    SET_A16
    lda PlayerFood
    sta UI_DivQuot
    SET_A8
    ldx #$1A
    ldy #$05
    jsr PrintNum16

    lda PlayerRapier
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$1A
    ldy #$07
    jsr PrintNum16

    lda PlayerAxe
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$1A
    ldy #$09
    jsr PrintNum16

    lda PlayerShield
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$1A
    ldy #$0B
    jsr PrintNum16

    lda PlayerBow
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$1A
    ldy #$0D
    jsr PrintNum16

    lda PlayerAmulet
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$1A
    ldy #$0F
    jsr PrintNum16

    ; Draw cursor ">" at selected row
    ; Cursor row = ShopCursor * 2 + 5
    lda ShopCursor
    asl
    clc
    adc #$05
    tay
    ldx #$01
    lda #<str_cursor
    sta UI_TempPtr
    lda #>str_cursor
    sta UI_TempPtr+1
    jsr PrintString

    ; Gold at bottom
    lda #<str_gp
    sta UI_TempPtr
    lda #>str_gp
    sta UI_TempPtr+1
    ldx #$02
    ldy #$12
    jsr PrintString

    SET_A16
    lda PlayerGold
    sta UI_DivQuot
    SET_A8
    ldx #$05
    ldy #$12
    jsr PrintNum16

    ; Controls hint
    lda #<str_shop_ctrl
    sta UI_TempPtr
    lda #>str_shop_ctrl
    sta UI_TempPtr+1
    ldx #$02
    ldy #$14
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowCastle — display castle/quest screen on BG3
; ============================================================================
.proc UiShowCastle
    SET_AXY8
    lda #$0C                ; Yellow (BG3 palette 3)
    sta FontAttr
    jsr UiClearBg3

    ; Title
    lda #<str_castle_title
    sta UI_TempPtr
    lda #>str_castle_title
    sta UI_TempPtr+1
    ldx #$04
    ldy #$02
    jsr PrintString

    ; Check if quest completed
    lda PlayerQuest
    bpl :+
    jmp @show_complete
:
    ; Active quest: "THY TASK: KILL A(N)"
    lda #<str_thy_task
    sta UI_TempPtr
    lda #>str_thy_task
    sta UI_TempPtr+1
    ldx #$02
    ldy #$06
    jsr PrintString

    ; Show monster name at row 8
    lda PlayerQuest
    and #$0F
    cmp #$00
    bne :+
    lda #<str_mn_skeleton
    sta UI_TempPtr
    lda #>str_mn_skeleton
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$01
    bne :+
    lda #<str_mn_thief
    sta UI_TempPtr
    lda #>str_mn_thief
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$02
    bne :+
    lda #<str_mn_rat
    sta UI_TempPtr
    lda #>str_mn_rat
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$03
    bne :+
    lda #<str_mn_orc
    sta UI_TempPtr
    lda #>str_mn_orc
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$04
    bne :+
    lda #<str_mn_viper
    sta UI_TempPtr
    lda #>str_mn_viper
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$05
    bne :+
    lda #<str_mn_carrion
    sta UI_TempPtr
    lda #>str_mn_carrion
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$06
    bne :+
    lda #<str_mn_gremlin
    sta UI_TempPtr
    lda #>str_mn_gremlin
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$07
    bne :+
    lda #<str_mn_mimic
    sta UI_TempPtr
    lda #>str_mn_mimic
    sta UI_TempPtr+1
    jmp @print_mon
:   cmp #$08
    bne :+
    lda #<str_mn_daemon
    sta UI_TempPtr
    lda #>str_mn_daemon
    sta UI_TempPtr+1
    jmp @print_mon
:   ; Default: Balrog
    lda #<str_mn_balrog
    sta UI_TempPtr
    lda #>str_mn_balrog
    sta UI_TempPtr+1

@print_mon:
    ldx #$06
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
    ; "THOU HAST ACCOMPLISHED THY QUEST!"
    lda #<str_quest_done
    sta UI_TempPtr
    lda #>str_quest_done
    sta UI_TempPtr+1
    ldx #$02
    ldy #$06
    jsr PrintString

    lda #<str_castle_a
    sta UI_TempPtr
    lda #>str_castle_a
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0A
    jsr PrintString

@done_castle:
    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowGameOver — mourning screen
; ============================================================================
.proc UiShowGameOver
    SET_AXY8
    lda #$14                ; Red (BG3 palette 5)
    sta FontAttr
    jsr UiClearBg3

    lda #<str_go_mourn
    sta UI_TempPtr
    lda #>str_go_mourn
    sta UI_TempPtr+1
    ldx #$02
    ldy #$06
    jsr PrintString

    lda #<str_go_line2
    sta UI_TempPtr
    lda #>str_go_line2
    sta UI_TempPtr+1
    ldx #$02
    ldy #$08
    jsr PrintString

    lda #<str_go_restart
    sta UI_TempPtr
    lda #>str_go_restart
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0C
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowVictory — knighthood screen
; ============================================================================
.proc UiShowVictory
    SET_AXY8
    lda #$18                ; Gold (BG3 palette 6)
    sta FontAttr
    jsr UiClearBg3

    lda #<str_vic_line1
    sta UI_TempPtr
    lda #>str_vic_line1
    sta UI_TempPtr+1
    ldx #$02
    ldy #$04
    jsr PrintString

    lda #<str_vic_line2
    sta UI_TempPtr
    lda #>str_vic_line2
    sta UI_TempPtr+1
    ldx #$02
    ldy #$06
    jsr PrintString

    lda #<str_vic_line3
    sta UI_TempPtr
    lda #>str_vic_line3
    sta UI_TempPtr+1
    ldx #$02
    ldy #$08
    jsr PrintString

    lda #<str_go_restart
    sta UI_TempPtr
    lda #>str_go_restart
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0E
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowChargenSeed — lucky number + difficulty entry screen
; ============================================================================
.proc UiShowChargenSeed
    SET_AXY8
    lda #$10                ; Cyan (BG3 palette 4)
    sta FontAttr
    jsr UiClearBg3

    lda #<str_cg_lucky
    sta UI_TempPtr
    lda #>str_cg_lucky
    sta UI_TempPtr+1
    ldx #$02
    ldy #$06
    jsr PrintString

    ; Show current seed value at col 6, row 8
    SET_A16
    lda ChargenSeed
    sta UI_DivQuot
    SET_A8
    ldx #$06
    ldy #$08
    jsr PrintNum16

    lda #<str_cg_level
    sta UI_TempPtr
    lda #>str_cg_level
    sta UI_TempPtr+1
    ldx #$02
    ldy #$0C
    jsr PrintString

    ; Show difficulty level at col 19, row 12
    lda DiffLevel
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$13
    ldy #$0C
    jsr PrintNum16

    lda #<str_cg_a_confirm
    sta UI_TempPtr
    lda #>str_cg_a_confirm
    sta UI_TempPtr+1
    ldx #$06
    ldy #$10
    jsr PrintString

    lda #<str_cg_updn
    sta UI_TempPtr
    lda #>str_cg_updn
    sta UI_TempPtr+1
    ldx #$06
    ldy #$12
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowChargenStats — stat display with accept/reroll
; ============================================================================
.proc UiShowChargenStats
    SET_AXY8
    lda #$10                ; Cyan (BG3 palette 4)
    sta FontAttr
    jsr UiClearBg3

    ; HIT POINTS
    lda #<str_cg_hp
    sta UI_TempPtr
    lda #>str_cg_hp
    sta UI_TempPtr+1
    ldx #$04
    ldy #$04
    jsr PrintString
    SET_A16
    lda PlayerHP
    sta UI_DivQuot
    SET_A8
    ldx #$14
    ldy #$04
    jsr PrintNum16

    ; STRENGTH
    lda #<str_cg_str
    sta UI_TempPtr
    lda #>str_cg_str
    sta UI_TempPtr+1
    ldx #$04
    ldy #$06
    jsr PrintString
    lda PlayerSTR
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$14
    ldy #$06
    jsr PrintNum16

    ; DEXTERITY
    lda #<str_cg_dex
    sta UI_TempPtr
    lda #>str_cg_dex
    sta UI_TempPtr+1
    ldx #$04
    ldy #$08
    jsr PrintString
    lda PlayerDEX
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$14
    ldy #$08
    jsr PrintNum16

    ; STAMINA
    lda #<str_cg_sta
    sta UI_TempPtr
    lda #>str_cg_sta
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0A
    jsr PrintString
    lda PlayerSTA
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$14
    ldy #$0A
    jsr PrintNum16

    ; WISDOM
    lda #<str_cg_wis
    sta UI_TempPtr
    lda #>str_cg_wis
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0C
    jsr PrintString
    lda PlayerWIS
    sta UI_DivQuot
    stz UI_DivQuot+1
    ldx #$14
    ldy #$0C
    jsr PrintNum16

    ; GOLD
    lda #<str_cg_gold
    sta UI_TempPtr
    lda #>str_cg_gold
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0E
    jsr PrintString
    SET_A16
    lda PlayerGold
    sta UI_DivQuot
    SET_A8
    ldx #$14
    ldy #$0E
    jsr PrintNum16

    ; Controls
    lda #<str_cg_accept
    sta UI_TempPtr
    lda #>str_cg_accept
    sta UI_TempPtr+1
    ldx #$04
    ldy #$12
    jsr PrintString

    lda #<str_cg_reroll
    sta UI_TempPtr
    lda #>str_cg_reroll
    sta UI_TempPtr+1
    ldx #$04
    ldy #$14
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; UiShowChargenClass — Fighter or Mage choice
; ============================================================================
.proc UiShowChargenClass
    SET_AXY8
    lda #$10                ; Cyan (BG3 palette 4)
    sta FontAttr
    jsr UiClearBg3

    lda #<str_cg_class_q
    sta UI_TempPtr
    lda #>str_cg_class_q
    sta UI_TempPtr+1
    ldx #$02
    ldy #$08
    jsr PrintString

    ; Show current selection with cursor
    lda PlayerClass
    beq @show_fighter

    ; Mage selected
    lda #<str_cg_fighter
    sta UI_TempPtr
    lda #>str_cg_fighter
    sta UI_TempPtr+1
    ldx #$06
    ldy #$0C
    jsr PrintString

    lda #<str_cg_mage_sel
    sta UI_TempPtr
    lda #>str_cg_mage_sel
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0E
    jsr PrintString
    jmp @show_controls

@show_fighter:
    lda #<str_cg_fighter_sel
    sta UI_TempPtr
    lda #>str_cg_fighter_sel
    sta UI_TempPtr+1
    ldx #$04
    ldy #$0C
    jsr PrintString

    lda #<str_cg_mage
    sta UI_TempPtr
    lda #>str_cg_mage
    sta UI_TempPtr+1
    ldx #$06
    ldy #$0E
    jsr PrintString

@show_controls:
    lda #<str_cg_lr_change
    sta UI_TempPtr
    lda #>str_cg_lr_change
    sta UI_TempPtr+1
    ldx #$04
    ldy #$12
    jsr PrintString

    lda #<str_cg_a_confirm
    sta UI_TempPtr
    lda #>str_cg_a_confirm
    sta UI_TempPtr+1
    ldx #$04
    ldy #$14
    jsr PrintString

    lda #$01
    sta StatsDirty
    rts
.endproc

; ============================================================================
; Message System — compose and display messages on BG3 row 26
; ============================================================================

; UiMsgInit — clear MsgBuf and reset write position
.proc UiMsgInit
    SET_AXY8
    ldx #$00
    lda #$00
@clear:
    sta MsgBuf,x
    inx
    cpx #32
    bne @clear
    stz MsgBufPos
    rts
.endproc

; UiMsgAppendStr — append null-terminated string from UI_TempPtr to MsgBuf
.proc UiMsgAppendStr
    SET_AXY8
    ldy #$00
    ldx MsgBufPos
@loop:
    lda (UI_TempPtr),y
    beq @done
    cpx #30                 ; Safety: leave room for null
    bcs @done
    sta MsgBuf,x
    inx
    iny
    bra @loop
@done:
    stx MsgBufPos
    rts
.endproc

; UiMsgAppendNum — append 8-bit decimal number from A to MsgBuf
; Skips leading zeros. Input: A = value (8-bit)
.proc UiMsgAppendNum
    SET_AXY8
    sta UI_TempA
    stz UI_TempB              ; Leading-zero flag

    ; Handle 0
    cmp #$00
    bne @nonzero
    ldx MsgBufPos
    lda #'0'
    sta MsgBuf,x
    inc MsgBufPos
    rts

@nonzero:
    ; Hundreds: val / 100
    sta WRDIVL
    stz WRDIVH
    lda #100
    sta WRDIVB
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lda RDDIVL              ; Quotient = hundreds digit
    beq @tens
    clc
    adc #'0'
    ldx MsgBufPos
    sta MsgBuf,x
    inc MsgBufPos
    lda #$01
    sta UI_TempB             ; Had hundreds digit
@tens:
    lda RDMPYL              ; Remainder from hundreds division
    sta WRDIVL
    stz WRDIVH
    lda #10
    sta WRDIVB
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lda RDDIVL              ; Quotient = tens digit
    bne @write_tens
    lda UI_TempB
    beq @ones               ; Skip leading zero if no hundreds
    lda #$00                ; Tens is 0 but we had hundreds
@write_tens:
    clc
    adc #'0'
    ldx MsgBufPos
    sta MsgBuf,x
    inc MsgBufPos
@ones:
    lda RDMPYL              ; Remainder = ones digit
    clc
    adc #'0'
    ldx MsgBufPos
    sta MsgBuf,x
    inc MsgBufPos
    rts
.endproc

; UiMsgAppendMonName — append monster name from index in X (0-9)
; Uses MonsterNamePtrs lookup table
.proc UiMsgAppendMonName
    SET_AXY8
    txa
    asl                     ; * 2 for pointer table
    tax
    lda MonsterNamePtrs,x
    sta UI_TempPtr
    lda MonsterNamePtrs+1,x
    sta UI_TempPtr+1
    jsr UiMsgAppendStr
    rts
.endproc

; UiMsgShow — null-terminate MsgBuf, clear row 26, print, set timer
.proc UiMsgShow
    SET_AXY8
    lda #$04                ; White (BG3 palette 1) for messages
    sta FontAttr
    ldx MsgBufPos
    stz MsgBuf,x            ; Null-terminate

    ; Clear row 26 in Bg3Tilemap (32 tiles = 64 bytes)
    SET_AXY16
    ldx #MSG_ROW * 32 * 2   ; Byte offset for row 26
    lda #$0000
    ldy #$0000
@clr:
    sta Bg3Tilemap,x
    inx
    inx
    iny
    cpy #32
    bne @clr

    ; Print MsgBuf at row 26, col 1
    SET_AXY8
    lda #<MsgBuf
    sta UI_TempPtr
    lda #>MsgBuf
    sta UI_TempPtr+1
    ldx #$01
    ldy #MSG_ROW
    jsr PrintString

    lda #120                ; 2 seconds at 60fps
    sta MsgTimer
    lda #$01
    sta StatsDirty
    rts
.endproc

; UiSetMessage — convenience: init + append string from UI_TempPtr + show
; Input: UI_TempPtr = string address
.proc UiSetMessage
    SET_AXY8
    ; Save UI_TempPtr (UiMsgInit doesn't clobber it, but be safe)
    lda UI_TempPtr
    pha
    lda UI_TempPtr+1
    pha
    jsr UiMsgInit
    pla
    sta UI_TempPtr+1
    pla
    sta UI_TempPtr
    jsr UiMsgAppendStr
    jsr UiMsgShow
    rts
.endproc

; UiTickMessage — called each frame; decrements timer, clears msg when expired
.proc UiTickMessage
    SET_AXY8
    lda MsgTimer
    beq @done
    dec a
    sta MsgTimer
    bne @done
    ; Timer hit zero — clear row 26
    SET_AXY16
    ldx #MSG_ROW * 32 * 2
    lda #$0000
    ldy #$0000
@clr:
    sta Bg3Tilemap,x
    inx
    inx
    iny
    cpy #32
    bne @clr
    SET_AXY8
    lda #$01
    sta StatsDirty
@done:
    rts
.endproc

; RDDIVL/RDMPYL already defined in macros.s constants
; WRDIVL/WRDIVH/WRDIVB already defined in macros.s constants

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
    .byte "--- ADVENTURE SHOPPE ---", $00
str_shop_hdr:
    .byte "PRICE DMG  ITEM", $00
str_si_food:
    .byte "1/10  ---  FOOD", $00
str_si_rapier:
    .byte "8     1-10 RAPIER", $00
str_si_axe:
    .byte "5     1-5  AXE", $00
str_si_shield:
    .byte "6     1    SHIELD", $00
str_si_bow:
    .byte "3     1-4  BOW & ARROWS", $00
str_si_amulet:
    .byte "15    ???  MAGIC AMULET", $00
str_shop_ctrl:
    .byte "A:BUY  B:LEAVE", $00
str_cursor:
    .byte ">", $00

str_castle_title:
    .byte "--- LORD BRITISH ---", $00
str_thy_task:
    .byte "THY TASK: KILL A(N)", $00
str_quest_done:
    .byte "THOU HAST ACCOMPLISHED", $00
str_castle_a:
    .byte "A: ACCEPT NEXT QUEST", $00
str_castle_b:
    .byte "B: LEAVE", $00

; Monster names (null-terminated)
str_mn_skeleton:
    .byte "SKELETON", $00
str_mn_thief:
    .byte "THIEF", $00
str_mn_rat:
    .byte "GIANT RAT", $00
str_mn_orc:
    .byte "ORC", $00
str_mn_viper:
    .byte "VIPER", $00
str_mn_carrion:
    .byte "CARRION CRAWLER", $00
str_mn_gremlin:
    .byte "GREMLIN", $00
str_mn_mimic:
    .byte "MIMIC", $00
str_mn_daemon:
    .byte "DAEMON", $00
str_mn_balrog:
    .byte "BALROG", $00

; Game over strings
str_go_mourn:
    .byte "WE MOURN THE PASSING", $00
str_go_line2:
    .byte "OF THE ADVENTURER", $00
str_go_restart:
    .byte "PRESS START TO RESTART", $00

; Victory strings
str_vic_line1:
    .byte "THOU HAST PROVED", $00
str_vic_line2:
    .byte "THYSELF WORTHY OF", $00
str_vic_line3:
    .byte "KNIGHTHOOD!", $00

; Chargen strings
str_cg_lucky:
    .byte "TYPE THY LUCKY NUMBER", $00
str_cg_level:
    .byte "LEVEL OF PLAY:", $00
str_cg_updn:
    .byte "UP/DN: CHANGE LEVEL", $00
str_cg_hp:
    .byte "HIT POINTS.....", $00
str_cg_str:
    .byte "STRENGTH.......", $00
str_cg_dex:
    .byte "DEXTERITY......", $00
str_cg_sta:
    .byte "STAMINA........", $00
str_cg_wis:
    .byte "WISDOM.........", $00
str_cg_gold:
    .byte "GOLD...........", $00
str_cg_accept:
    .byte "A: ACCEPT", $00
str_cg_reroll:
    .byte "B: REROLL", $00
str_cg_class_q:
    .byte "ART THOU FIGHTER OR MAGE?", $00
str_cg_fighter:
    .byte "  FIGHTER", $00
str_cg_mage:
    .byte "  MAGE", $00
str_cg_fighter_sel:
    .byte "> FIGHTER", $00
str_cg_mage_sel:
    .byte "> MAGE", $00
str_cg_lr_change:
    .byte "L/R: CHANGE", $00
str_cg_a_confirm:
    .byte "A: CONFIRM", $00

; Monster name pointer table (indexed by type 0-9)
MonsterNamePtrs:
    .word str_mn_skeleton
    .word str_mn_thief
    .word str_mn_rat
    .word str_mn_orc
    .word str_mn_viper
    .word str_mn_carrion
    .word str_mn_gremlin
    .word str_mn_mimic
    .word str_mn_daemon
    .word str_mn_balrog

; Message strings
str_msg_hit:      .byte "HIT FOR ", $00
str_msg_miss:     .byte "YOU MISS!", $00
str_msg_killed:   .byte " KILLED!", $00
str_msg_quest:    .byte "QUEST COMPLETE!", $00
str_msg_mon_hit:  .byte " HITS! ", $00
str_msg_mon_miss: .byte " MISSES!", $00
str_msg_dmg:      .byte " DMG", $00
str_msg_thief:    .byte "THIEF STOLE ", $00
str_msg_rapier:   .byte "RAPIER!", $00
str_msg_axe:      .byte "AXE!", $00
str_msg_shield:   .byte "SHIELD!", $00
str_msg_bow:      .byte "BOW!", $00
str_msg_gremlin:  .byte "GREMLIN ATE YOUR FOOD!", $00
str_msg_chest:    .byte "FOUND ", $00
str_msg_gold:     .byte " GOLD!", $00
str_msg_trap:     .byte "TRAP! FLOOR ", $00
str_msg_up:       .byte "CLIMBED UP", $00
str_msg_down:     .byte "DESCENDED", $00
str_msg_backfire: .byte "AMULET BACKFIRES!", $00
str_msg_toad:     .byte "TURNED INTO A TOAD!", $00
str_msg_magkill:  .byte "MAGIC DESTROYS ", $00
str_msg_magstair: .byte "MAGIC STAIRS APPEAR!", $00
str_msg_crumble:  .byte "AMULET CRUMBLES!", $00
str_msg_died:     .byte "YOU HAVE PERISHED!", $00
