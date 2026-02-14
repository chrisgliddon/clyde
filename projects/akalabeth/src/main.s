; main.s — Akalabeth: World of Doom (SNES port)
; Entry point: ResetHandler → InitSNES → MainLoop

.include "macros.s"

.define GAME_TITLE "AKALABETH            "

; ============================================================================
; Imports
; ============================================================================

.import InitSNES
.import OverworldInit, OverworldUpdate, OverworldRender
.import DungeonInit, DungeonUpdate, DungeonRender
.import CombatInit, CombatUpdate
.import UiInit, UiDrawStats, UiShowTitle, UiShowShop, UiShowCastle
.import GfxUploadOverworld, GfxUploadFont
.importzp MapDirty, PlayerX, PlayerY
.importzp StatsDirty
.importzp PlayerHP, PlayerFood, PlayerGold, PlayerQuest
.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS

; ============================================================================
; Exports
; ============================================================================

.export ResetHandler, NmiHandler, IrqHandler
.exportzp JoyPress, JoyRaw, FrameReady, GameState

.include "header.inc"

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
FrameReady:     .res 1
GameState:      .res 1
JoyRaw:         .res 2
JoyPress:       .res 2

; ============================================================================
; Constants
; ============================================================================

STATE_TITLE     = $00
STATE_OVERWORLD = $01
STATE_DUNGEON   = $02
STATE_COMBAT    = $03
STATE_SHOP      = $04
STATE_CASTLE    = $05
STATE_GAMEOVER  = $06

JOY_START       = $10       ; Start button (high byte bit 4)
JOY_A           = $80       ; A button
JOY_B           = $40       ; B button

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

.proc ResetHandler
    sei
    clc
    xce                     ; Switch to native 65816 mode
    SET_AXY16
    ldx #$1FFF
    txs                     ; Stack at top of low RAM
    lda #$0000
    tcd                     ; Direct page = $0000
    SET_AXY8
    jsr InitSNES            ; S=$1FFF, return addr at $1FFE-$1FFF (survives RAM clear)
    jmp Main
.endproc

; --- NMI handler ---
.proc NmiHandler
    pha
    phx
    phy
    phd
    php
    SET_AXY8

    lda RDNMI

    ; DMA BG1 tilemap
    lda MapDirty
    beq @skip_bg1
    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$20
    sta VMADDH
    lda #$01
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<TilemapBufAddr
    sta A1T0L
    lda #>TilemapBufAddr
    sta A1T0H
    stz A1B0
    stz DAS0L
    lda #$08
    sta DAS0H
    lda #$01
    sta MDMAEN
    stz MapDirty
@skip_bg1:

    ; DMA BG3 tilemap
    lda StatsDirty
    beq @skip_bg3
    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$30
    sta VMADDH
    lda #$01
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<Bg3TilemapAddr
    sta A1T0L
    lda #>Bg3TilemapAddr
    sta A1T0H
    stz A1B0
    stz DAS0L
    lda #$08
    sta DAS0H
    lda #$01
    sta MDMAEN
    stz StatsDirty
@skip_bg3:

    lda #$01
    sta FrameReady
    plp
    pld
    ply
    plx
    pla
    rti
.endproc

.proc IrqHandler
    rti
.endproc

; ============================================================================
; Main
; ============================================================================
.proc Main
    SET_A8

    ; Init graphics + font (during force blank)
    jsr GfxUploadFont
    jsr UiInit

    ; Show title screen
    jsr UiShowTitle
    lda #$01
    sta StatsDirty

    ; Enable NMI + auto-joypad
    lda #$81
    sta NMITIMEN

    ; Start at title state
    lda #STATE_TITLE
    sta GameState

    ; Display on
    lda #$0F
    sta INIDISP

; --- Main Loop ---
@loop:
    stz FrameReady
@wait:
    wai
    lda FrameReady
    beq @wait
    jsr ReadJoypad

    lda GameState
    beq @do_title           ; STATE_TITLE = 0
    cmp #STATE_OVERWORLD
    beq @do_overworld
    cmp #STATE_DUNGEON
    beq @do_dungeon
    cmp #STATE_COMBAT
    beq @do_combat
    cmp #STATE_SHOP
    beq @do_shop
    cmp #STATE_CASTLE
    bne :+
    jmp @do_castle
:   cmp #STATE_GAMEOVER
    bne :+
    jmp @do_gameover
:   jmp @loop

@do_title:
    ; Wait for Start button
    lda JoyPress+1
    and #JOY_START
    beq @loop_jmp
    ; Start new game
    jsr CombatInit
    jsr OverworldInit
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #$01
    sta MapDirty
    lda #STATE_OVERWORLD
    sta GameState
@loop_jmp:
    jmp @loop

@do_overworld:
    jsr OverworldUpdate
    lda MapDirty
    beq :+
    jsr OverworldRender
    lda #$01
    sta MapDirty
:   jsr UiDrawStats
    jmp @loop

@do_dungeon:
    jsr DungeonUpdate
    jsr UiDrawStats
    jmp @loop

@do_combat:
    jsr CombatUpdate
    jsr UiDrawStats
    jmp @loop

@do_shop:
    jsr UiShowShop
    ; A=buy, B=leave
    lda JoyPress+1
    bit #JOY_B
    bne @leave_shop
    bit #JOY_A
    bne @buy_food
    jmp @loop

@leave_shop:
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jmp @loop

@buy_food:
    ; Buy 10 food for 1 gold
    SET_A16
    lda PlayerGold
    beq :+                  ; No gold
    dec a
    sta PlayerGold
    lda PlayerFood
    clc
    adc #10
    sta PlayerFood
:   SET_A8
    lda #$01
    sta StatsDirty
    jmp @loop

@do_castle:
    jsr UiShowCastle
    lda JoyPress+1
    bit #JOY_B
    bne @leave_castle
    bit #JOY_A
    bne @accept_quest
    jmp @loop

@leave_castle:
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jmp @loop

@accept_quest:
    ; Check if current quest completed (bit 7 set)
    lda PlayerQuest
    bmi @advance_quest
    jmp @loop               ; Quest not done yet

@advance_quest:
    ; Clear completion bit, advance to next quest
    lda PlayerQuest
    and #$7F                ; Clear bit 7
    inc a                   ; Next quest
    cmp #10                 ; Quest 10 = victory!
    bcs @victory
    sta PlayerQuest
    ; Reward: +5 HP, +2 STR
    SET_A16
    lda PlayerHP
    clc
    adc #5
    sta PlayerHP
    SET_A8
    lda PlayerSTR
    clc
    adc #2
    sta PlayerSTR
    lda #$01
    sta StatsDirty
    jmp @loop

@victory:
    ; TODO: full victory screen
    ; For now, just restart
    lda #STATE_TITLE
    sta GameState
    jsr UiShowTitle
    lda #$01
    sta StatsDirty
    jmp @loop

@do_gameover:
    ; Press Start to restart
    lda JoyPress+1
    and #JOY_START
    beq :+
    lda #STATE_TITLE
    sta GameState
    jsr UiShowTitle
    lda #$01
    sta StatsDirty
:   jmp @loop
.endproc

; ============================================================================
; ReadJoypad
; ============================================================================
.proc ReadJoypad
    SET_A8
@wait_auto:
    lda HVBJOY
    and #$01
    bne @wait_auto
    SET_A16
    lda JoyRaw
    eor #$FFFF
    sta JoyPress
    lda JOY1L
    sta JoyRaw
    and JoyPress
    sta JoyPress
    SET_A8
    rts
.endproc

; ============================================================================
; BSS address labels for NMI DMA
; ============================================================================
.import TilemapBuffer: abs, Bg3Tilemap: abs
TilemapBufAddr = TilemapBuffer
Bg3TilemapAddr = Bg3Tilemap
