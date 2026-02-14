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
.import CombatInit, CombatUpdate, RollStats, SeedPrng
.import UiInit, UiDrawStats, UiShowTitle, UiShowShop, UiShowCastle
.import UiShowChargenSeed, UiShowChargenStats, UiShowChargenClass
.import GfxUploadOverworld, GfxUploadFont
.importzp MapDirty, PlayerX, PlayerY
.importzp StatsDirty
.importzp PlayerHP, PlayerFood, PlayerGold, PlayerQuest
.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS
.importzp PlayerClass, DiffLevel

; Production lib
.import NmiHandler, IrqHandler
.import ReadJoypad
.importzp FrameReady, NmiCount
.importzp JoyRaw, JoyPress, JoyPrev
.import JOY_A, JOY_B, JOY_START
.import JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT

; ============================================================================
; Exports
; ============================================================================

.export ResetHandler
.exportzp GameState, ChargenSeed

.include "header.inc"

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
GameState:      .res 1
ChargenSeed:    .res 2          ; Lucky number (auto-increments)

; ============================================================================
; Constants
; ============================================================================

STATE_TITLE         = $00
STATE_OVERWORLD     = $01
STATE_DUNGEON       = $02
STATE_COMBAT        = $03
STATE_SHOP          = $04
STATE_CASTLE        = $05
STATE_GAMEOVER      = $06
STATE_CHARGEN_SEED  = $07
STATE_CHARGEN_STATS = $08
STATE_CHARGEN_CLASS = $09

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
    jsr InitSNES
    ; Keep force blank via shadow until init complete
    lda #FORCE_BLANK
    sta SHADOW_INIDISP
    jmp Main
.endproc

; ============================================================================
; FlushTilemaps — DMA dirty tilemaps to VRAM (call after NMI during VBlank)
; ============================================================================
.proc FlushTilemaps
    SET_A8
    lda MapDirty
    beq @skip_bg1
    ; BG1 tilemap → VRAM $2000
    lda #VMAIN_INC1
    sta VMAIN
    stz VMADDL
    lda #$20
    sta VMADDH
    lda #DMA_2REG_1W
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
    lda StatsDirty
    beq @skip_bg3
    ; BG3 tilemap → VRAM $3000
    lda #VMAIN_INC1
    sta VMAIN
    stz VMADDL
    lda #$30
    sta VMADDH
    lda #DMA_2REG_1W
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
    rts
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

    ; DMA initial tilemaps while still in force blank
    jsr FlushTilemaps

    ; Enable NMI + auto-joypad
    lda #NMITIMEN_NMIJOY
    sta NMITIMEN

    ; Start at title state
    lda #STATE_TITLE
    sta GameState

    ; Display on (next NMI will copy shadow → hardware)
    lda #BRIGHTNESS_MAX
    sta SHADOW_INIDISP

; --- Main Loop ---
@loop:
    SET_A8
    stz FrameReady
@wait:
    wai
    lda FrameReady
    beq @wait

    ; VBlank active: flush tilemaps then read joypad
    jsr FlushTilemaps
    jsr ReadJoypad

    lda GameState
    beq @do_title
    cmp #STATE_CHARGEN_SEED
    beq @do_chargen_seed
    cmp #STATE_CHARGEN_STATS
    bne :+
    jmp @do_chargen_stats
:   cmp #STATE_CHARGEN_CLASS
    bne :+
    jmp @do_chargen_class
:   cmp #STATE_OVERWORLD
    bne :+
    jmp @do_overworld
:   cmp #STATE_DUNGEON
    bne :+
    jmp @do_dungeon
:   cmp #STATE_COMBAT
    bne :+
    jmp @do_combat
:   cmp #STATE_SHOP
    bne :+
    jmp @do_shop
:   cmp #STATE_CASTLE
    bne :+
    jmp @do_castle
:   cmp #STATE_GAMEOVER
    bne :+
    jmp @do_gameover
:   jmp @loop

; --- Title ---
@do_title:
    SET_A16
    lda JoyPress
    bit #JOY_START
    SET_A8
    beq @loop
    ; Enter character creation
    lda #5
    sta DiffLevel
    stz ChargenSeed
    stz ChargenSeed+1
    lda #STATE_CHARGEN_SEED
    sta GameState
    jmp @loop

; --- Chargen: Lucky Number + Difficulty ---
@do_chargen_seed:
    ; Auto-increment seed each frame
    SET_A16
    lda ChargenSeed
    inc a
    sta ChargenSeed
    ; Check buttons
    lda JoyPress
    bit #JOY_A
    bne @confirm_seed
    bit #JOY_UP
    bne @diff_up
    bit #JOY_DOWN
    bne @diff_down
    SET_A8
    jsr UiShowChargenSeed
    jmp @loop
@diff_up:
    SET_A8
    lda DiffLevel
    cmp #10
    beq :+
    inc a
    sta DiffLevel
:   jsr UiShowChargenSeed
    jmp @loop
@diff_down:
    SET_A8
    lda DiffLevel
    cmp #1
    beq :+
    dec a
    sta DiffLevel
:   jsr UiShowChargenSeed
    jmp @loop
@confirm_seed:
    ; Seed PRNG, roll stats, advance to stats screen
    lda ChargenSeed
    jsr SeedPrng
    SET_A8
    jsr RollStats
    lda #STATE_CHARGEN_STATS
    sta GameState
    jsr UiShowChargenStats
    jmp @loop

; --- Chargen: Stats Accept/Reroll ---
@do_chargen_stats:
    SET_A16
    lda JoyPress
    bit #JOY_A
    bne @accept_stats
    bit #JOY_B
    bne @reroll_stats
    SET_A8
    jmp @loop
@accept_stats:
    SET_A8
    stz PlayerClass         ; Default: Fighter
    lda #STATE_CHARGEN_CLASS
    sta GameState
    jmp @loop
@reroll_stats:
    SET_A8
    jsr RollStats
    jsr UiShowChargenStats
    jmp @loop

; --- Chargen: Fighter/Mage Choice ---
@do_chargen_class:
    jsr UiShowChargenClass
    SET_A16
    lda JoyPress
    bit #JOY_LEFT
    bne @toggle_class
    bit #JOY_RIGHT
    bne @toggle_class
    bit #JOY_A
    bne @confirm_class
    SET_A8
    jmp @loop
@toggle_class:
    SET_A8
    lda PlayerClass
    eor #$01
    sta PlayerClass
    jmp @loop
@confirm_class:
    SET_A8
    ; Start the game
    jsr CombatInit
    jsr OverworldInit
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #$01
    sta MapDirty
    lda #STATE_OVERWORLD
    sta GameState
    jmp @loop

; --- Overworld ---
@do_overworld:
    jsr OverworldUpdate
    lda MapDirty
    beq :+
    jsr OverworldRender
    lda #$01
    sta MapDirty
:   jsr UiDrawStats
    jmp @loop

; --- Dungeon ---
@do_dungeon:
    jsr DungeonUpdate
    jsr UiDrawStats
    jmp @loop

; --- Combat ---
@do_combat:
    jsr CombatUpdate
    jsr UiDrawStats
    jmp @loop

; --- Shop ---
@do_shop:
    jsr UiShowShop
    SET_A16
    lda JoyPress
    bit #JOY_B
    bne @leave_shop
    bit #JOY_A
    bne @buy_food
    SET_A8
    jmp @loop

@leave_shop:
    SET_A8
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jmp @loop

@buy_food:
    SET_A8
    SET_A16
    lda PlayerGold
    beq @no_gold
    dec a
    sta PlayerGold
    lda PlayerFood
    clc
    adc #10
    sta PlayerFood
@no_gold:
    SET_A8
    lda #$01
    sta StatsDirty
    jmp @loop

; --- Castle ---
@do_castle:
    jsr UiShowCastle
    SET_A16
    lda JoyPress
    bit #JOY_B
    bne @leave_castle
    bit #JOY_A
    bne @accept_quest
    SET_A8
    jmp @loop

@leave_castle:
    SET_A8
    jsr GfxUploadOverworld
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jmp @loop

@accept_quest:
    SET_A8
    lda PlayerQuest
    bmi @advance_quest
    jmp @loop

@advance_quest:
    lda PlayerQuest
    and #$7F
    inc a
    cmp #10
    bcs @victory
    sta PlayerQuest
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
    lda #STATE_TITLE
    sta GameState
    jsr UiShowTitle
    lda #$01
    sta StatsDirty
    jmp @loop

; --- Game Over ---
@do_gameover:
    SET_A16
    lda JoyPress
    bit #JOY_START
    SET_A8
    beq :+
    lda #STATE_TITLE
    sta GameState
    jsr UiShowTitle
    lda #$01
    sta StatsDirty
:   jmp @loop
.endproc

; ============================================================================
; BSS address labels for DMA
; ============================================================================
.import TilemapBuffer: abs, Bg3Tilemap: abs
TilemapBufAddr = TilemapBuffer
Bg3TilemapAddr = Bg3Tilemap
