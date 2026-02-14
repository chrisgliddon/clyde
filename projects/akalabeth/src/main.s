; main.s — Akalabeth: World of Doom (SNES port)
; Entry point: ResetHandler → InitSNES → MainLoop

.include "macros.s"

; ROM header title — exactly 21 bytes, must be defined before header.inc
.define GAME_TITLE "AKALABETH            "

; ============================================================================
; Imports
; ============================================================================

.import InitSNES
.import OverworldInit, OverworldUpdate
.import DungeonInit
.import CombatInit
.import UiInit, UiDrawStats

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
GameState:      .res 1      ; 0=title, 1=overworld, 2=dungeon, 3=combat
JoyRaw:         .res 2      ; Raw joypad 1 state (16-bit)
JoyPress:       .res 2      ; Newly pressed buttons this frame

; ============================================================================
; Constants
; ============================================================================

STATE_TITLE     = $00
STATE_OVERWORLD = $01
STATE_DUNGEON   = $02
STATE_COMBAT    = $03

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
.proc NmiHandler
    pha
    SET_A8
    lda RDNMI               ; Acknowledge NMI
    lda #$01
    sta FrameReady
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

    ; Enable NMI + auto-joypad read
    lda #$81
    sta NMITIMEN

    ; Init game state
    lda #STATE_OVERWORLD
    sta GameState

    jsr OverworldInit
    jsr UiInit

    ; Turn on display (brightness 15)
    lda #$0F
    sta INIDISP

; --- Main Loop ---
@loop:
    stz FrameReady
@wait:
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
    jmp @loop

@do_overworld:
    jsr OverworldUpdate
    jsr UiDrawStats
    jmp @loop

@do_dungeon:
    jmp @loop

@do_combat:
    jmp @loop
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
