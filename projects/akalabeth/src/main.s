; main.s — Akalabeth: World of Doom (SNES port)
; Entry point: ResetHandler → InitSNES → MainLoop

.include "macros.s"

; ROM header title — exactly 21 bytes, must be defined before header.inc
.define GAME_TITLE "AKALABETH            "

; ============================================================================
; Imports
; ============================================================================

.import InitSNES
.import OverworldInit, OverworldUpdate, OverworldRender
.import DungeonInit, DungeonUpdate, DungeonRender
.import CombatInit, CombatUpdate
.import UiInit, UiDrawStats
.import GfxUploadOverworld, GfxUploadFont
.importzp MapDirty, PlayerX, PlayerY
.importzp StatsDirty

; ============================================================================
; Exports (vectors — referenced by header.inc)
; ============================================================================

.export ResetHandler, NmiHandler, IrqHandler
.exportzp JoyPress, JoyRaw, FrameReady, GameState

; Include ROM header + vectors (uses GAME_TITLE define above)
.include "header.inc"

; ============================================================================
; Zero page variables
; ============================================================================

.segment "ZEROPAGE"
FrameReady:     .res 1      ; NMI sets this; main loop waits on it
GameState:      .res 1      ; 0=title, 1=overworld, 2=dungeon, 3=combat, 4=shop, 5=castle
JoyRaw:         .res 2      ; Raw joypad 1 state (16-bit)
JoyPress:       .res 2      ; Newly pressed buttons this frame

; ============================================================================
; Constants
; ============================================================================

STATE_TITLE     = $00
STATE_OVERWORLD = $01
STATE_DUNGEON   = $02
STATE_COMBAT    = $03
STATE_SHOP      = $04
STATE_CASTLE    = $05

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; --- Reset vector entry point ---
.proc ResetHandler
    jsr InitSNES            ; Full hardware init (lib/init.s)
    jmp Main
.endproc

; --- NMI (VBlank) handler ---
; During VBlank: DMA dirty buffers to VRAM, then signal main loop
.proc NmiHandler
    pha
    phx
    phy
    phd
    php

    SET_AXY8

    lda RDNMI               ; Acknowledge NMI

    ; --- DMA tilemap buffer to VRAM when MapDirty ---
    lda MapDirty
    beq @skip_bg1

    ; VRAM address = $2000 (BG1 tilemap)
    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$20                ; VRAM word address $2000
    sta VMADDH

    lda #$01                ; DMA mode: 2-reg write (lo+hi)
    sta DMAP0
    lda #$18                ; B-bus = VMDATAL
    sta BBAD0
    lda #<TilemapBufAddr
    sta A1T0L
    lda #>TilemapBufAddr
    sta A1T0H
    stz A1B0                ; Bank 0 (low RAM)
    stz DAS0L               ; Size = $0800 = 2048
    lda #$08
    sta DAS0H
    lda #$01
    sta MDMAEN

    stz MapDirty

@skip_bg1:

    ; --- DMA BG3 tilemap when StatsDirty ---
    lda StatsDirty
    beq @skip_bg3

    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$30                ; VRAM word address $3000 (BG3 tilemap)
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

; --- IRQ handler (unused) ---
.proc IrqHandler
    rti
.endproc

; ============================================================================
; Main — game initialization + main loop
; ============================================================================
.proc Main
    SET_A8

    ; Init subsystems (order matters: combat sets stats, then overworld, then gfx)
    jsr CombatInit
    jsr OverworldInit
    jsr GfxUploadOverworld
    jsr GfxUploadFont
    jsr UiInit

    ; Build initial tilemap
    jsr OverworldRender

    ; Enable NMI + auto-joypad read
    lda #$81
    sta NMITIMEN

    ; Set game state
    lda #STATE_OVERWORLD
    sta GameState

    ; Turn on display (brightness 15)
    lda #$0F
    sta INIDISP

; --- Main Loop ---
@loop:
    stz FrameReady
@wait:
    wai                     ; Wait for interrupt (saves CPU cycles)
    lda FrameReady
    beq @wait

    ; Read joypad
    jsr ReadJoypad

    ; Dispatch based on game state
    lda GameState
    cmp #STATE_OVERWORLD
    beq @do_overworld
    cmp #STATE_DUNGEON
    beq @do_dungeon
    cmp #STATE_COMBAT
    beq @do_combat
    cmp #STATE_SHOP
    beq @do_shop
    cmp #STATE_CASTLE
    beq @do_castle
    jmp @loop

@do_overworld:
    jsr OverworldUpdate
    ; Rebuild tilemap if map changed
    lda MapDirty
    beq :+
    jsr OverworldRender
    lda #$01
    sta MapDirty            ; Signal NMI to DMA
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
    ; TODO: Phase 6 — ShopUpdate
    ; For now, pressing B returns to overworld
    lda JoyPress+1
    and #$40                ; B button = bit 14, high byte bit 6
    beq :+
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
:   jmp @loop

@do_castle:
    ; TODO: Phase 6 — CastleUpdate
    ; For now, pressing B returns to overworld
    lda JoyPress+1
    and #$40
    beq :+
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
:   jmp @loop
.endproc

; ============================================================================
; ReadJoypad — read auto-joypad results into JoyRaw/JoyPress
; ============================================================================
.proc ReadJoypad
    SET_A8
@wait_auto:
    lda HVBJOY
    and #$01                ; Bit 0 = auto-read in progress
    bne @wait_auto

    SET_A16
    lda JoyRaw              ; Previous frame
    eor #$FFFF
    sta JoyPress
    lda JOY1L               ; Current frame (16-bit read)
    sta JoyRaw
    and JoyPress            ; Only newly pressed
    sta JoyPress

    SET_A8
    rts
.endproc

; ============================================================================
; BSS address labels for NMI DMA (linker resolves these)
; ============================================================================
.import TilemapBuffer: abs, Bg3Tilemap: abs

; We need the addresses as constants for DMA source
TilemapBufAddr = TilemapBuffer
Bg3TilemapAddr = Bg3Tilemap
