; save.s — SRAM save/load for Akalabeth
; Save layout at $700000 (29 bytes):
;   $00-$01: Magic ($A5, $5A)
;   $02:     XOR checksum of bytes $03-$19
;   $03-$19: Player state (23 bytes)

.include "macros.s"

.export SaveGame, LoadGame, EraseSave

.importzp PlayerSTR, PlayerDEX, PlayerSTA, PlayerWIS
.importzp PlayerHP, PlayerFood, PlayerGold
.importzp PlayerRapier, PlayerAxe, PlayerShield, PlayerBow, PlayerAmulet
.importzp PlayerQuest, PlayerClass, DiffLevel
.importzp PlayerX, PlayerY
.importzp GameState, ChargenSeed

; SRAM base address (LoROM bank $70)
SRAM_BASE = $700000

SAVE_MAGIC_0 = $A5
SAVE_MAGIC_1 = $5A
SAVE_SIZE    = 23          ; Bytes of player state

.segment "CODE"

; ============================================================================
; SaveGame — write player state to SRAM
; ============================================================================
.proc SaveGame
    SET_AXY8
    ; Write magic bytes
    lda #SAVE_MAGIC_0
    sta f:SRAM_BASE+0
    lda #SAVE_MAGIC_1
    sta f:SRAM_BASE+1

    ; Write player state at offset $03
    lda PlayerSTR
    sta f:SRAM_BASE+3
    lda PlayerDEX
    sta f:SRAM_BASE+4
    lda PlayerSTA
    sta f:SRAM_BASE+5
    lda PlayerWIS
    sta f:SRAM_BASE+6

    ; HP (16-bit)
    lda PlayerHP
    sta f:SRAM_BASE+7
    lda PlayerHP+1
    sta f:SRAM_BASE+8

    ; Food (16-bit)
    lda PlayerFood
    sta f:SRAM_BASE+9
    lda PlayerFood+1
    sta f:SRAM_BASE+10

    ; Gold (16-bit)
    lda PlayerGold
    sta f:SRAM_BASE+11
    lda PlayerGold+1
    sta f:SRAM_BASE+12

    ; Equipment (5 bytes)
    lda PlayerRapier
    sta f:SRAM_BASE+13
    lda PlayerAxe
    sta f:SRAM_BASE+14
    lda PlayerShield
    sta f:SRAM_BASE+15
    lda PlayerBow
    sta f:SRAM_BASE+16
    lda PlayerAmulet
    sta f:SRAM_BASE+17

    ; Quest/Class/Difficulty (3 bytes)
    lda PlayerQuest
    sta f:SRAM_BASE+18
    lda PlayerClass
    sta f:SRAM_BASE+19
    lda DiffLevel
    sta f:SRAM_BASE+20

    ; Position (2 bytes)
    lda PlayerX
    sta f:SRAM_BASE+21
    lda PlayerY
    sta f:SRAM_BASE+22

    ; GameState (1 byte)
    lda GameState
    sta f:SRAM_BASE+23

    ; ChargenSeed (2 bytes)
    lda ChargenSeed
    sta f:SRAM_BASE+24
    lda ChargenSeed+1
    sta f:SRAM_BASE+25

    ; Compute XOR checksum of bytes $03-$19 (offsets 3-25)
    lda #$00
    eor f:SRAM_BASE+3
    eor f:SRAM_BASE+4
    eor f:SRAM_BASE+5
    eor f:SRAM_BASE+6
    eor f:SRAM_BASE+7
    eor f:SRAM_BASE+8
    eor f:SRAM_BASE+9
    eor f:SRAM_BASE+10
    eor f:SRAM_BASE+11
    eor f:SRAM_BASE+12
    eor f:SRAM_BASE+13
    eor f:SRAM_BASE+14
    eor f:SRAM_BASE+15
    eor f:SRAM_BASE+16
    eor f:SRAM_BASE+17
    eor f:SRAM_BASE+18
    eor f:SRAM_BASE+19
    eor f:SRAM_BASE+20
    eor f:SRAM_BASE+21
    eor f:SRAM_BASE+22
    eor f:SRAM_BASE+23
    eor f:SRAM_BASE+24
    eor f:SRAM_BASE+25
    sta f:SRAM_BASE+2       ; Store checksum

    rts
.endproc

; ============================================================================
; LoadGame — restore player state from SRAM
; Returns: carry clear = valid save loaded, carry set = no valid save
; ============================================================================
.proc LoadGame
    SET_AXY8
    ; Check magic bytes
    lda f:SRAM_BASE+0
    cmp #SAVE_MAGIC_0
    beq :+
    jmp @invalid
:   lda f:SRAM_BASE+1
    cmp #SAVE_MAGIC_1
    beq :+
    jmp @invalid
:

    ; Verify checksum
    lda #$00
    eor f:SRAM_BASE+3
    eor f:SRAM_BASE+4
    eor f:SRAM_BASE+5
    eor f:SRAM_BASE+6
    eor f:SRAM_BASE+7
    eor f:SRAM_BASE+8
    eor f:SRAM_BASE+9
    eor f:SRAM_BASE+10
    eor f:SRAM_BASE+11
    eor f:SRAM_BASE+12
    eor f:SRAM_BASE+13
    eor f:SRAM_BASE+14
    eor f:SRAM_BASE+15
    eor f:SRAM_BASE+16
    eor f:SRAM_BASE+17
    eor f:SRAM_BASE+18
    eor f:SRAM_BASE+19
    eor f:SRAM_BASE+20
    eor f:SRAM_BASE+21
    eor f:SRAM_BASE+22
    eor f:SRAM_BASE+23
    eor f:SRAM_BASE+24
    eor f:SRAM_BASE+25
    cmp f:SRAM_BASE+2
    beq :+
    jmp @invalid
:

    ; Restore player state
    lda f:SRAM_BASE+3
    sta PlayerSTR
    lda f:SRAM_BASE+4
    sta PlayerDEX
    lda f:SRAM_BASE+5
    sta PlayerSTA
    lda f:SRAM_BASE+6
    sta PlayerWIS

    lda f:SRAM_BASE+7
    sta PlayerHP
    lda f:SRAM_BASE+8
    sta PlayerHP+1

    lda f:SRAM_BASE+9
    sta PlayerFood
    lda f:SRAM_BASE+10
    sta PlayerFood+1

    lda f:SRAM_BASE+11
    sta PlayerGold
    lda f:SRAM_BASE+12
    sta PlayerGold+1

    lda f:SRAM_BASE+13
    sta PlayerRapier
    lda f:SRAM_BASE+14
    sta PlayerAxe
    lda f:SRAM_BASE+15
    sta PlayerShield
    lda f:SRAM_BASE+16
    sta PlayerBow
    lda f:SRAM_BASE+17
    sta PlayerAmulet

    lda f:SRAM_BASE+18
    sta PlayerQuest
    lda f:SRAM_BASE+19
    sta PlayerClass
    lda f:SRAM_BASE+20
    sta DiffLevel

    lda f:SRAM_BASE+21
    sta PlayerX
    lda f:SRAM_BASE+22
    sta PlayerY

    lda f:SRAM_BASE+23
    sta GameState

    lda f:SRAM_BASE+24
    sta ChargenSeed
    lda f:SRAM_BASE+25
    sta ChargenSeed+1

    clc                     ; Valid save
    rts

@invalid:
    sec                     ; No valid save
    rts
.endproc

; ============================================================================
; EraseSave — invalidate SRAM save
; ============================================================================
.proc EraseSave
    SET_A8
    lda #$00
    sta f:SRAM_BASE+0
    sta f:SRAM_BASE+1
    rts
.endproc
