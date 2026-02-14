; combat.s — Akalabeth turn-based combat system
; Player stats, weapons, 10 monster types, turn-based combat

.include "macros.s"

.export CombatInit, CombatUpdate
.exportzp PlayerHP, PlayerFood, PlayerGold, PlayerWeapon
.exportzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS, PlayerQuest

.importzp JoyPress, GameState, MapDirty

; ============================================================================
; Constants
; ============================================================================

WEAPON_RAPIER   = $00
WEAPON_AXE      = $01
WEAPON_BOW      = $02
WEAPON_SHIELD   = $03

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

; Combat states
CSTATE_PLAYER   = $00       ; Player's turn
CSTATE_ENEMY    = $01       ; Enemy's turn
CSTATE_WON      = $02       ; Victory
CSTATE_LOST     = $03       ; Defeat

; Joypad
JOY_A           = $80       ; A button (high byte)
JOY_B           = $40       ; B button

; Game states (must match main.s)
STATE_OVERWORLD = $01
STATE_DUNGEON   = $02

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"

PlayerSTR:      .res 1
PlayerDEX:      .res 1
PlayerSTA:      .res 1
PlayerWIS:      .res 1
PlayerHP:       .res 2
PlayerFood:     .res 2
PlayerGold:     .res 2
PlayerWeapon:   .res 1
PlayerQuest:    .res 1      ; Current quest monster (0-9), bit 7 = completed

EnemyType:      .res 1
EnemyHP:        .res 2
CombatState:    .res 1
CB_TempA:       .res 1
CB_TempB:       .res 2      ; 16-bit temp

; ============================================================================
; ROM data
; ============================================================================

.segment "RODATA"

MonsterHP:
    .word 10, 15, 12, 25, 20, 30, 18, 35, 50, 80

MonsterATK:
    .byte 3, 5, 4, 8, 6, 10, 7, 12, 18, 25

; Weapon damage values
WeaponDamage:
    .byte 10, 5, 4, 1      ; Rapier, Axe, Bow, Shield

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

    lda #10
    sta PlayerSTR
    sta PlayerDEX
    sta PlayerSTA
    sta PlayerWIS

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
    stz PlayerQuest

    rts
.endproc

; ============================================================================
; StartCombat — begin combat with monster type in A
; ============================================================================
.proc StartCombat
    SET_A8
    sta EnemyType

    ; Look up monster HP
    SET_XY16
    and #$0F
    asl                     ; * 2 for word index
    tax
    SET_A16
    lda MonsterHP,x
    sta EnemyHP
    SET_A8

    lda #CSTATE_PLAYER
    sta CombatState
    rts
.endproc

; ============================================================================
; CombatUpdate — turn-based combat state machine
; A = attack, B = retreat
; ============================================================================
.proc CombatUpdate
    SET_AXY8
    SET_XY16

    lda CombatState
    cmp #CSTATE_PLAYER
    beq @player_turn
    cmp #CSTATE_ENEMY
    beq @enemy_turn
    cmp #CSTATE_WON
    bne :+
    jmp @victory
:   ; CSTATE_LOST or unknown
    jmp @defeat

@player_turn:
    lda JoyPress+1
    bit #JOY_A
    bne @attack
    bit #JOY_B
    bne :+
    rts
:   jmp @retreat

@attack:
    ; Hit formula: random chance based on DEX
    ; Simple: if RNG < DEX*8, hit. Otherwise miss.
    jsr PrngByte
    sta CB_TempA            ; Random 0-255
    lda PlayerDEX
    asl
    asl
    asl                     ; DEX * 8
    cmp CB_TempA
    bcc @miss               ; DEX*8 < random → miss

    ; Hit! Damage = RNG(weapon_damage) + STR/4
    jsr PrngByte
    pha                     ; Save random
    SET_XY8
    ldx PlayerWeapon
    pla
    and WeaponDamage,x      ; Mask by weapon damage
    SET_XY16
    clc
    adc #$01                ; At least 1 damage
    sta CB_TempA            ; Base damage
    lda PlayerSTR
    lsr
    lsr                     ; STR / 4
    clc
    adc CB_TempA            ; Total damage

    ; Apply damage to enemy
    sta CB_TempA
    stz CB_TempB+1
    sta CB_TempB
    SET_A16
    lda EnemyHP
    sec
    sbc CB_TempB
    bcs :+
    lda #$0000
:   sta EnemyHP
    SET_A8

    ; Check if enemy dead
    SET_A16
    lda EnemyHP
    SET_A8
    bne @enemy_turn_start
    ; Enemy killed!
    lda #CSTATE_WON
    sta CombatState
    rts

@miss:
@enemy_turn_start:
    lda #CSTATE_ENEMY
    sta CombatState
    ; Fall through to enemy turn

@enemy_turn:
    ; Enemy attacks player
    ; Hit: if RNG < (monster_ATK + floor_bonus) * 8
    jsr PrngByte
    sta CB_TempA
    SET_XY8
    ldx EnemyType
    lda MonsterATK,x
    SET_XY16
    asl
    asl
    asl                     ; ATK * 8
    cmp CB_TempA
    bcc @enemy_miss

    ; Enemy hit! Damage = RNG & monster_ATK + 1
    jsr PrngByte
    SET_XY8
    ldx EnemyType
    and MonsterATK,x
    SET_XY16
    clc
    adc #$01

    ; Apply to player HP
    sta CB_TempA
    stz CB_TempB+1
    sta CB_TempB
    SET_A16
    lda PlayerHP
    sec
    sbc CB_TempB
    bcs :+
    lda #$0000
:   sta PlayerHP
    SET_A8

    ; Check player death
    SET_A16
    lda PlayerHP
    SET_A8
    bne @back_to_player
    lda #CSTATE_LOST
    sta CombatState
    rts

@enemy_miss:
@back_to_player:
    lda #CSTATE_PLAYER
    sta CombatState
    rts

@retreat:
    ; 50% chance to escape
    jsr PrngByte
    and #$01
    beq @escape_fail
    ; Escape!
    lda #STATE_DUNGEON
    sta GameState
    lda #$01
    sta MapDirty
    rts
@escape_fail:
    ; Failed — enemy gets a free hit
    jmp @enemy_turn

@victory:
    ; Award gold = monster_type + 5
    lda EnemyType
    clc
    adc #$05
    sta CB_TempA
    stz CB_TempB+1
    sta CB_TempB
    SET_A16
    lda PlayerGold
    clc
    adc CB_TempB
    sta PlayerGold
    SET_A8

    ; Check quest completion
    lda EnemyType
    cmp PlayerQuest
    bne @no_quest_advance
    ; Quest complete!
    lda PlayerQuest
    ora #$80                ; Set completion flag
    sta PlayerQuest
@no_quest_advance:

    ; Press any button to continue → return to dungeon
    lda JoyPress+1
    ora JoyPress
    beq @wait_victory       ; Wait for button
    lda #STATE_DUNGEON
    sta GameState
    lda #$01
    sta MapDirty
    rts
@wait_victory:
    rts

@defeat:
    ; TODO: game over screen
    ; For now, just return to overworld with reset stats
    lda JoyPress+1
    ora JoyPress
    beq @wait_defeat
    jsr CombatInit
    lda #STATE_OVERWORLD
    sta GameState
    lda #$01
    sta MapDirty
@wait_defeat:
    rts
.endproc

; ============================================================================
; PrngByte — quick 8-bit PRNG using LFSR (reuse dungeon seed via import)
; Returns random byte in A
; ============================================================================
; We import the PRNG from dungeon.s? No — let's keep our own simple one.
; Use hardware timer for additional entropy.
.proc PrngByte
    ; Read HVBJOY low bits as noise source, mix with counter
    SET_A8
    lda $4210               ; RDNMI counter bits
    eor CB_TempA            ; Mix with temp
    asl
    adc #$7D
    eor CB_TempA
    sta CB_TempA
    rts
.endproc
