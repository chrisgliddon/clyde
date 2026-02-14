; combat.s — Akalabeth player stats, stat rolling, PRNG
; Combat itself is now inline in dungeon.s

.include "macros.s"

.export CombatInit, RollStats, SeedPrng
.exportzp PlayerHP, PlayerFood, PlayerGold
.exportzp PlayerRapier, PlayerAxe, PlayerShield, PlayerBow, PlayerAmulet
.exportzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS, PlayerQuest
.exportzp PlayerClass, DiffLevel

; ============================================================================
; Constants
; ============================================================================

; Hardware multiplier result registers
RDMPYH          = $4217     ; Product high byte

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
PlayerRapier:   .res 1      ; Rapier count
PlayerAxe:      .res 1      ; Axe count
PlayerShield:   .res 1      ; Shield count
PlayerBow:      .res 1      ; Bow & arrows count
PlayerAmulet:   .res 1      ; Magic amulet count
PlayerQuest:    .res 1      ; Current quest monster (0-9), bit 7 = completed

PlayerClass:    .res 1      ; 0=Fighter, 1=Mage
DiffLevel:      .res 1      ; 1-10
RNG_State:      .res 2      ; 16-bit LFSR state
CB_TempA:       .res 1      ; Temp for RollStat

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; CombatInit — init non-stat player fields (call after RollStats)
; Sets first quest = WIS/3 (clamped 0-9) per original game
; ============================================================================
.proc CombatInit
    SET_A8
    SET_A16
    stz PlayerFood          ; No food — must buy in town
    SET_A8
    lda #$01
    sta PlayerRapier        ; Start with one rapier
    stz PlayerAxe
    stz PlayerShield
    stz PlayerBow
    stz PlayerAmulet

    ; First quest = INT(WIS/3), clamped 0-9
    SET_XY8
    lda PlayerWIS
    ldx #$00
@div3:
    cmp #3
    bcc @div3_done
    sec
    sbc #3
    inx
    jmp @div3
@div3_done:
    cpx #10
    bcc :+
    ldx #9
:   stx PlayerQuest

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
