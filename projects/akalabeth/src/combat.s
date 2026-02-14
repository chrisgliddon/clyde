; combat.s — Akalabeth turn-based combat system
; Player stats, weapons, 10 monster types, turn-based combat

.include "macros.s"

.export CombatInit, CombatUpdate, RollStats, SeedPrng
.exportzp PlayerHP, PlayerFood, PlayerGold, PlayerWeapon
.exportzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS, PlayerQuest
.exportzp PlayerClass, DiffLevel

.importzp JoyPress, GameState, MapDirty
.import JOY_A, JOY_B

; ============================================================================
; Constants
; ============================================================================

; Hardware multiplier result registers
RDMPYH          = $4217     ; Product high byte

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

PlayerClass:    .res 1      ; 0=Fighter, 1=Mage
DiffLevel:      .res 1      ; 1-10
RNG_State:      .res 2      ; 16-bit LFSR state

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
; CombatInit — init non-stat player fields (call after RollStats)
; ============================================================================
.proc CombatInit
    SET_A8
    SET_A16
    stz PlayerFood          ; No food — must buy in town
    SET_A8
    lda #WEAPON_RAPIER
    sta PlayerWeapon
    stz PlayerQuest
    rts
.endproc

; ============================================================================
; SeedPrng — seed the 16-bit LFSR from A (16-bit)
; Input: A = 16-bit seed value. Must not be 0.
; ============================================================================
.proc SeedPrng
    SET_A16
    cmp #$0000
    bne :+
    lda #$ACE1              ; Avoid zero state (LFSR deadlock)
:   sta RNG_State
    SET_A8
    rts
.endproc

; ============================================================================
; RollStats — roll all 6 stats using INT(SQR(RND)*21+4) approximation
; Uses max(R1,R2)*21/256 + 4 to approximate sqrt distribution
; ============================================================================
.proc RollStats
    SET_A8

    ; Roll STR
    jsr RollStat
    sta PlayerSTR

    ; Roll DEX
    jsr RollStat
    sta PlayerDEX

    ; Roll STA
    jsr RollStat
    sta PlayerSTA

    ; Roll WIS
    jsr RollStat
    sta PlayerWIS

    ; Roll HP (store as 16-bit)
    jsr RollStat
    sta PlayerHP
    stz PlayerHP+1

    ; Roll GOLD (store as 16-bit)
    jsr RollStat
    sta PlayerGold
    stz PlayerGold+1

    rts
.endproc

; ============================================================================
; RollStat — generate one stat: max(R1,R2)*21/256+4 → range 4-24
; Returns: A = stat value (8-bit)
; Clobbers: CB_TempA
; ============================================================================
.proc RollStat
    SET_A8
    jsr PrngByte
    sta CB_TempA
    jsr PrngByte
    cmp CB_TempA
    bcs :+
    lda CB_TempA            ; A = max(R1, R2)
:   ; A * 21 via hardware multiplier
    sta WRMPYA              ; $4202 = multiplicand
    lda #21
    sta WRMPYB              ; $4203 = multiplier, triggers multiply
    ; Wait 8 machine cycles (4 nops × 2 cycles each)
    nop
    nop
    nop
    nop
    lda RDMPYH              ; $4217 = high byte = A*21/256 → range 0-20
    clc
    adc #4                  ; range 4-24
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
    SET_A16
    lda JoyPress
    bit #JOY_A
    bne @attack
    bit #JOY_B
    bne @do_retreat
    SET_A8
    rts

@do_retreat:
    SET_A8
    jmp @retreat

@attack:
    SET_A8
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
    SET_A16
    lda JoyPress
    SET_A8
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
    SET_A16
    lda JoyPress
    SET_A8
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
; PrngByte — 16-bit Galois LFSR, returns random byte in A (8-bit)
; Polynomial: x^16 + x^14 + x^13 + x^11 + 1 (maximal period 65535)
; ============================================================================
.proc PrngByte
    SET_A16
    lda RNG_State
    beq @fix_zero           ; LFSR must never be 0
    lsr
    bcc :+
    eor #$B400              ; Feedback taps
:   sta RNG_State
    SET_A8
    lda RNG_State           ; Return low byte
    rts
@fix_zero:
    .a16                    ; Branch arrives with A still 16-bit
    lda #$ACE1
    sta RNG_State
    SET_A8
    lda RNG_State
    rts
.endproc
