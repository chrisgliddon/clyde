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
.import CombatInit, RollStats, SeedPrng
.import UiInit, UiDrawStats, UiShowTitle, UiShowShop, UiShowCastle
.import UiShowChargenSeed, UiShowChargenStats, UiShowChargenClass
.import UiShowGameOver, UiShowVictory
.import UiClearBg3, UiTickMessage
.import GfxUploadOverworld, GfxUploadFont, SetBackdropColor
.import SaveGame, LoadGame, EraseSave
.import AudioInit, PlaySfx, SetAmbience
.import SpriteInit
.import PalFxTick, PalFxFlash, PalFxHeal, PalFxWaterCycle, PalFxTorchFlicker
.import HdmaSetOverworld, HdmaDisable
.include "sfx_ids.inc"
.importzp MapDirty, PlayerX, PlayerY
.importzp StatsDirty
.importzp PlayerHP, PlayerFood, PlayerGold, PlayerQuest
.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS
.importzp PlayerClass, DiffLevel
.importzp PlayerRapier, PlayerAxe, PlayerShield, PlayerBow, PlayerAmulet

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
.export FadeOut, FadeIn
.exportzp GameState, ChargenSeed, ShopCursor, AudioEnabled

CART_TYPE = $02             ; ROM + SRAM + battery
SRAM_SIZE = $03             ; 8KB (2^3)
ROM_SIZE_BYTE = $07         ; 128KB ROM (4 LoROM banks × 32KB)

.include "header.inc"

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
GameState:      .res 1
ChargenSeed:    .res 2          ; Lucky number (auto-increments)
ShopCursor:     .res 1          ; 0-5: selected item in shop
FadeTarget:     .res 1
FadeActive:     .res 1
AudioEnabled:   .res 1          ; Nonzero after AudioInit succeeds

; ============================================================================
; Constants
; ============================================================================

STATE_TITLE         = $00
STATE_OVERWORLD     = $01
STATE_DUNGEON       = $02
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
    jsr SpriteInit          ; Clear all OAM entries
    lda #$02                ; OBJ base VRAM $4000, size 8x8/16x16
    sta SHADOW_OBSEL
    jsr AudioInit           ; Upload SPC driver to ARAM
    ; Keep force blank via shadow until init complete
    lda #FORCE_BLANK
    sta SHADOW_INIDISP
    jmp Main
.endproc

; ============================================================================
; FadeOut — ramp brightness from current to 0, then set force blank
; Blocks until complete (15 frames max). Call with A8.
; ============================================================================
.proc FadeOut
    SET_AXY8
@loop:
    lda SHADOW_INIDISP
    and #$0F                ; Get current brightness
    beq @done               ; Already at 0
    dec a
    sta SHADOW_INIDISP
    stz FrameReady
@wait:
    wai
    lda FrameReady
    beq @wait
    jmp @loop
@done:
    lda #FORCE_BLANK
    sta SHADOW_INIDISP
    sta INIDISP
    rts
.endproc

; ============================================================================
; FadeIn — clear force blank, ramp brightness from 0 to max
; Blocks until complete (15 frames). Call with A8.
; ============================================================================
.proc FadeIn
    SET_AXY8
    lda #$00
    sta SHADOW_INIDISP      ; Start at brightness 0 (no force blank)
@loop:
    stz FrameReady
@wait:
    wai
    lda FrameReady
    beq @wait
    lda SHADOW_INIDISP
    and #$0F
    cmp #$0F                ; Max brightness?
    beq @done
    lda SHADOW_INIDISP
    inc a
    sta SHADOW_INIDISP
    jmp @loop
@done:
    rts
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
    SET_A16
    lda #$2020                  ; Dark navy backdrop
    jsr SetBackdropColor
    SET_A8
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
    jsr PalFxTick

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
    ; Enter character creation (keep DiffLevel if set by victory)
    lda DiffLevel
    bne :+
    lda #5
    sta DiffLevel
:
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
    jsr UiClearBg3
    jsr FadeOut
    SET_A16
    lda #$0000                  ; Black backdrop for gameplay
    jsr SetBackdropColor
    SET_A8
    jsr GfxUploadOverworld
    jsr HdmaSetOverworld
    lda #$01
    jsr SetAmbience          ; overworld ambient drone
    jsr FadeIn
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
    jsr PalFxWaterCycle
    jmp @loop

; --- Dungeon ---
@do_dungeon:
    jsr DungeonUpdate
    lda GameState
    cmp #STATE_OVERWORLD
    beq @exit_dungeon_gfx
    cmp #STATE_GAMEOVER
    beq :+
    jsr UiDrawStats
    jsr UiTickMessage
    jsr PalFxTorchFlicker
:   jmp @loop
@exit_dungeon_gfx:
    jsr UiClearBg3
    jsr FadeOut
    SET_A16
    lda #$0000                  ; Black backdrop for gameplay
    jsr SetBackdropColor
    SET_A8
    jsr GfxUploadOverworld
    jsr HdmaSetOverworld
    lda #$01
    jsr SetAmbience          ; overworld ambient drone
    jsr FadeIn
    jsr OverworldRender
    lda #$01
    sta MapDirty
    sta StatsDirty
    jsr UiDrawStats
    jsr SaveGame
    jmp @loop

; --- Shop ---
@do_shop:
    jsr UiShowShop
    SET_A16
    lda JoyPress
    bit #JOY_B
    bne @leave_shop
    bit #JOY_A
    bne @buy_item
    bit #JOY_UP
    bne @shop_up
    bit #JOY_DOWN
    bne @shop_down
    SET_A8
    jmp @loop

@shop_up:
    SET_A8
    lda ShopCursor
    beq :+
    dec a
    sta ShopCursor
:   jmp @loop

@shop_down:
    SET_A8
    lda ShopCursor
    cmp #$05
    beq :+
    inc a
    sta ShopCursor
:   jmp @loop

@leave_shop:
    SET_A8
    jsr UiClearBg3
    jsr FadeOut
    jsr GfxUploadOverworld
    jsr HdmaSetOverworld
    lda #$01
    jsr SetAmbience          ; overworld ambient drone
    jsr FadeIn
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jsr SaveGame
    jmp @loop

@buy_item:
    SET_A8
    ; Price table: Food=1(for 10), Rapier=8, Axe=5, Shield=6, Bow=3, Amulet=15
    lda ShopCursor
    beq @buy_food
    cmp #$01
    beq @buy_rapier
    cmp #$02
    beq @buy_axe
    cmp #$03
    beq @buy_shield
    cmp #$04
    beq @buy_bow
    ; $05 = amulet
    jmp @buy_amulet

@buy_food:
    SET_A16
    lda PlayerGold
    beq @shop_no_gold
    dec a
    sta PlayerGold
    lda PlayerFood
    clc
    adc #10
    sta PlayerFood
    SET_A8
    jmp @shop_done
@buy_rapier:
    SET_A16
    lda PlayerGold
    cmp #8
    bcc @shop_no_gold
    sec
    sbc #8
    sta PlayerGold
    SET_A8
    inc PlayerRapier
    jmp @shop_done
@buy_axe:
    SET_A16
    lda PlayerGold
    cmp #5
    bcc @shop_no_gold
    sec
    sbc #5
    sta PlayerGold
    SET_A8
    inc PlayerAxe
    jmp @shop_done
@buy_shield:
    SET_A16
    lda PlayerGold
    cmp #6
    bcc @shop_no_gold
    sec
    sbc #6
    sta PlayerGold
    SET_A8
    inc PlayerShield
    jmp @shop_done
@buy_bow:
    SET_A16
    lda PlayerGold
    cmp #3
    bcc @shop_no_gold
    sec
    sbc #3
    sta PlayerGold
    SET_A8
    inc PlayerBow
    jmp @shop_done
@buy_amulet:
    SET_A16
    lda PlayerGold
    cmp #15
    bcc @shop_no_gold
    sec
    sbc #15
    sta PlayerGold
    SET_A8
    inc PlayerAmulet
    jmp @shop_done
@shop_no_gold:
    SET_A8
    jmp @loop
@shop_done:
    lda #SFX_BUY
    jsr PlaySfx
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
    jsr UiClearBg3
    jsr FadeOut
    jsr GfxUploadOverworld
    jsr HdmaSetOverworld
    lda #$01
    jsr SetAmbience          ; overworld ambient drone
    jsr FadeIn
    jsr OverworldRender
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
    jsr SaveGame
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
    jsr PalFxHeal
    lda #$01
    sta StatsDirty
    jsr SaveGame
    jmp @loop

@victory:
    lda #SFX_QUEST
    jsr PlaySfx
    ; Increment difficulty for next playthrough (cap at 10)
    lda DiffLevel
    cmp #10
    bcs :+
    inc a
    sta DiffLevel
:   lda #STATE_GAMEOVER
    sta GameState
    jsr UiShowVictory
    jmp @loop

; --- Game Over ---
@do_gameover:
    jsr UiShowGameOver
    SET_A16
    lda JoyPress
    bit #JOY_START
    SET_A8
    beq :+
    lda #$00
    jsr SetAmbience          ; silence ambient drone
    lda #SFX_GAMEOVER
    jsr PlaySfx
    jsr HdmaDisable
    SET_A16
    lda #$2020                  ; Dark navy backdrop for title
    jsr SetBackdropColor
    SET_A8
    lda #STATE_TITLE
    sta GameState
    jsr EraseSave
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
