; ui.s — Akalabeth UI system
; Stats bar, message log, menu rendering

.include "macros.s"

.export UiInit, UiDrawStats

.importzp PlayerHP, PlayerFood, PlayerGold, PlayerWeapon

; ============================================================================
; Constants
; ============================================================================

; BG3 used for text overlay (Mode 1: BG3 is 4-color, good for text)
BG3_TILEMAP     = $7000     ; VRAM address for BG3 tilemap
BG3_CHARSET     = $6000     ; VRAM address for BG3 character data

MSG_LOG_Y       = 24        ; Tilemap row for message log
STATS_Y         = 0         ; Tilemap row for stats bar

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
MsgBuffer:      .res 32     ; Current message string buffer
StatsDirty:     .res 1      ; Nonzero = need to update stats display

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; UiInit — set up BG3 for text display
; ============================================================================
.proc UiInit
    SET_A8

    ; TODO: upload font tiles to VRAM at BG3_CHARSET
    ; TODO: configure BG3SC, BG34NBA
    ; TODO: enable BG3 on main screen (TM)

    lda #$01
    sta StatsDirty

    rts
.endproc

; ============================================================================
; UiDrawStats — update stats bar on BG3
; Called once per frame when stats change.
; ============================================================================
.proc UiDrawStats
    SET_A8

    lda StatsDirty
    beq @done               ; Nothing to update

    ; TODO: convert PlayerHP/Food/Gold to decimal strings
    ; TODO: write tilemap entries to BG3 for stats bar
    ; Format: "HP:999 FOOD:999 GOLD:999 WPN:RAPIER"

    stz StatsDirty

@done:
    rts
.endproc
