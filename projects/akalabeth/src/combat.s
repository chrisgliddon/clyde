; combat.s — Akalabeth turn-based combat system
; Player stats, weapons, 10 monster types

.include "macros.s"

.export CombatInit
.exportzp PlayerHP, PlayerFood, PlayerGold, PlayerWeapon
.exportzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS, PlayerQuest

; ============================================================================
; Constants — Player stats
; ============================================================================

; Weapon IDs
WEAPON_RAPIER   = $00
WEAPON_AXE      = $01
WEAPON_BOW      = $02
WEAPON_SHIELD   = $03

; Monster IDs (matching original Akalabeth quest order)
MON_SKELETON    = $00
MON_THIEF       = $01
MON_GIANT_RAT   = $02
MON_ORC         = $03
MON_VIPER       = $04
MON_CARRION     = $05
MON_GREMLIN     = $06
MON_MIMIC       = $07
MON_DAEMON      = $08
MON_BALROG      = $09

NUM_MONSTERS    = 10

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"

; Player stats
PlayerSTR:      .res 1
PlayerDEX:      .res 1
PlayerSTA:      .res 1
PlayerWIS:      .res 1
PlayerHP:       .res 2      ; 16-bit HP
PlayerFood:     .res 2      ; 16-bit food counter
PlayerGold:     .res 2      ; 16-bit gold
PlayerWeapon:   .res 1      ; Current weapon ID
PlayerQuest:    .res 1      ; Current quest monster (0-9)

; Current enemy
EnemyType:      .res 1
EnemyHP:        .res 2

; ============================================================================
; ROM data — monster stats
; ============================================================================

.segment "RODATA"

; Monster base HP (16-bit values, little-endian)
MonsterHP:
    .word 10                ; Skeleton
    .word 15                ; Thief
    .word 12                ; Giant Rat
    .word 25                ; Orc
    .word 20                ; Viper
    .word 30                ; Carrion Crawler
    .word 18                ; Gremlin
    .word 35                ; Mimic
    .word 50                ; Daemon
    .word 80                ; Balrog

; Monster attack power (8-bit)
MonsterATK:
    .byte 3, 5, 4, 8, 6, 10, 7, 12, 18, 25

; Monster names — 8 chars each, space-padded
MonsterNames:
    .byte "SKELETON"
    .byte "THIEF   "
    .byte "GNT RAT "
    .byte "ORC     "
    .byte "VIPER   "
    .byte "CARRION "
    .byte "GREMLIN "
    .byte "MIMIC   "
    .byte "DAEMON  "
    .byte "BALROG  "

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; CombatInit — set initial player stats (new game)
; ============================================================================
.proc CombatInit
    SET_A8

    ; Starting stats (matching original Akalabeth defaults)
    lda #10
    sta PlayerSTR
    sta PlayerDEX
    sta PlayerSTA
    sta PlayerWIS

    ; 16-bit values
    SET_A16
    lda #100
    sta PlayerHP
    lda #500
    sta PlayerFood
    lda #200
    sta PlayerGold

    SET_A8
    lda #WEAPON_RAPIER
    sta PlayerWeapon
    stz PlayerQuest         ; First quest: kill Skeleton

    rts
.endproc
