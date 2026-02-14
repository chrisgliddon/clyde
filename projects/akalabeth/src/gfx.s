; gfx.s — Akalabeth graphics: tile data, palettes, VRAM uploads
; VRAM layout:
;   $0000-$0FFF  BG1 tiles (4bpp overworld/dungeon, up to 256 tiles)
;   $1000-$17FF  BG3 tiles (2bpp font, 96 glyphs)
;   $2000-$27FF  BG1 tilemap (32x32)
;   $3000-$37FF  BG3 tilemap (32x32)

.include "macros.s"

.export GfxUploadOverworld, GfxUploadFont, GfxUploadDungeon

; DMA channel 0 registers (channel 1 for second transfers)
DMAP1       = $4310
BBAD1       = $4311
A1T1L       = $4312
A1T1H       = $4313
A1B1        = $4314
DAS1L       = $4315
DAS1H       = $4316

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; GfxUploadOverworld — upload overworld tiles + palette, configure PPU
; Call during force blank or VBlank.
; ============================================================================
.proc GfxUploadOverworld
    SET_A8

    ; --- Upload overworld tiles to VRAM $0000 (4bpp) ---
    lda #$80
    sta VMAIN               ; Word increment after high byte write
    stz VMADDL              ; VRAM address = $0000
    stz VMADDH

    lda #$01                ; DMA mode: 2-reg write (VMDATAL+VMDATAH)
    sta DMAP0
    lda #$18                ; B-bus = VMDATAL ($2118)
    sta BBAD0
    lda #<OverworldTiles
    sta A1T0L
    lda #>OverworldTiles
    sta A1T0H
    lda #^OverworldTiles
    sta A1B0
    lda #<OVERWORLD_TILES_SIZE
    sta DAS0L
    lda #>OVERWORLD_TILES_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; --- Upload palette to CGRAM ---
    stz CGADD               ; Palette index 0
    lda #$00                ; DMA mode: 1-reg write
    sta DMAP0
    lda #$22                ; B-bus = CGDATA ($2122)
    sta BBAD0
    lda #<OverworldPalette
    sta A1T0L
    lda #>OverworldPalette
    sta A1T0H
    lda #^OverworldPalette
    sta A1B0
    lda #<OVERWORLD_PAL_SIZE
    sta DAS0L
    lda #>OVERWORLD_PAL_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; --- Configure PPU for Mode 1 ---
    lda #$01                ; Mode 1, 8x8 tiles
    sta BGMODE

    ; BG1 tilemap at VRAM $2000 (word addr $2000, reg val = $2000>>8 = $20)
    lda #$20
    sta BG1SC

    ; BG3 tilemap at VRAM $3000
    lda #$30
    sta BG3SC

    ; BG1 char base = VRAM $0000 (nibble 0), BG2 char base = 0
    stz BG12NBA

    ; BG3 char base = VRAM $1000 (nibble 2 → value $02), BG4 = 0
    lda #$02
    sta BG34NBA

    ; Enable BG1 + BG3 on main screen
    lda #$05
    sta TM

    rts
.endproc

; ============================================================================
; GfxUploadFont — upload 2bpp font tiles to VRAM $1000, set BG3 palette
; ============================================================================
.proc GfxUploadFont
    SET_A8

    ; Upload font tiles to VRAM $1000
    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$10                ; VRAM word address $1000
    sta VMADDH

    lda #$01                ; 2-reg write
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<FontTiles
    sta A1T0L
    lda #>FontTiles
    sta A1T0H
    lda #^FontTiles
    sta A1B0
    lda #<FONT_TILES_SIZE
    sta DAS0L
    lda #>FONT_TILES_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; BG3 palette: use palette 1 (colors 4-7) for BG3 text
    ; CGRAM offset = palette_number * 4 * 2 bytes = 8 bytes into CGRAM
    ; But BG3 in mode 1 uses palettes 0-7 (2bpp = 4 colors each)
    ; We use palette 0 for BG3: transparent, white, gray, black
    ; BG3 palettes start at CGRAM $00 (shared with BG1 but BG3 is 2bpp)
    ; Actually in Mode 1, BG3 uses its own palette group.
    ; BG3 2bpp: palette 0 = CGRAM colors 0-3 (shared with BG1 color 0 = transparent)
    ; We'll put BG3 text colors in palette 1 to avoid overwriting BG1 palette 0
    ; Tilemap attribute bits 10-12 select palette. We'll set palette=0 and put
    ; text colors at the very start of CGRAM... but that conflicts with BG1.
    ; Solution: BG3 in Mode 1 priority uses palettes from CGRAM $00.
    ; We just need color 1,2,3 of palette 0 to be visible for font.
    ; BG1 also uses palette 0 colors 0-15. So color 1 = our first BG1 color.
    ; That's fine — text will render in whatever color 1 is (green for overworld).
    ; Better: use BG3 tilemap palette bits to select palette 1 = CGRAM colors 4-7.
    ; We'll write white at CGRAM color 4.
    lda #$04                ; CGRAM index 4
    sta CGADD
    ; Color 4 = white ($7FFF)
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA
    ; Color 5 = light gray ($56B5)
    lda #$B5
    sta CGDATA
    lda #$56
    sta CGDATA
    ; Color 6 = dark gray ($294A)
    lda #$4A
    sta CGDATA
    lda #$29
    sta CGDATA
    ; Color 7 = black (already 0 from init, but set explicitly)
    stz CGDATA
    stz CGDATA

    rts
.endproc

; ============================================================================
; GfxUploadDungeon — swap to dungeon tile set + palette
; ============================================================================
.proc GfxUploadDungeon
    SET_A8

    ; Upload dungeon tiles to VRAM $0000
    lda #$80
    sta VMAIN
    stz VMADDL
    stz VMADDH

    lda #$01
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<DungeonTiles
    sta A1T0L
    lda #>DungeonTiles
    sta A1T0H
    lda #^DungeonTiles
    sta A1B0
    lda #<DUNGEON_TILES_SIZE
    sta DAS0L
    lda #>DUNGEON_TILES_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

    ; Upload dungeon palette
    stz CGADD
    lda #$00
    sta DMAP0
    lda #$22
    sta BBAD0
    lda #<DungeonPalette
    sta A1T0L
    lda #>DungeonPalette
    sta A1T0H
    lda #^DungeonPalette
    sta A1B0
    lda #<DUNGEON_PAL_SIZE
    sta DAS0L
    lda #>DUNGEON_PAL_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

    rts
.endproc

; ============================================================================
; RODATA — Tile data and palettes
; ============================================================================

.segment "RODATA"

; ----------------------------------------------------------------------------
; Overworld tiles — 4bpp, 8x8 pixels, 32 bytes each
; 8 tiles: grass, mountain, water, town, castle, dungeon, forest, player
; 4bpp format: each row = 2 bytes bitplane 0+1, then 2 bytes bitplane 2+3
; Encoding: 8 rows × (2 bytes low + 2 bytes high) = 32 bytes per tile
; In SNES 4bpp: first 16 bytes = bitplanes 0,1 (interleaved row by row)
;               next  16 bytes = bitplanes 2,3 (interleaved row by row)
; ----------------------------------------------------------------------------

OverworldTiles:

; Tile 0: Grass — scattered dots pattern (green)
; Uses color 1 (green) with scattered pixels
.byte $44,$00, $11,$00, $44,$00, $00,$00  ; BP 0,1 rows 0-3
.byte $00,$00, $44,$00, $11,$00, $44,$00  ; BP 0,1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 2,3 rows 0-3
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 2,3 rows 4-7

; Tile 1: Mountain — triangle shape (brown, color 2)
.byte $00,$00, $00,$00, $18,$00, $18,$00  ; BP 0,1
.byte $3C,$00, $3C,$00, $7E,$00, $FF,$00  ;
.byte $00,$00, $00,$00, $00,$18, $00,$18  ; BP 2,3
.byte $00,$3C, $00,$3C, $00,$7E, $00,$FF  ;

; Tile 2: Water — wavy lines (blue, color 3)
.byte $00,$55, $00,$AA, $00,$55, $00,$AA  ; BP 0,1
.byte $00,$55, $00,$AA, $00,$55, $00,$AA  ;
.byte $00,$55, $00,$AA, $00,$55, $00,$AA  ; BP 2,3
.byte $00,$55, $00,$AA, $00,$55, $00,$AA  ;

; Tile 3: Town — house shape (light brown, color 6)
.byte $00,$00, $18,$00, $3C,$00, $7E,$00  ; BP 0,1
.byte $7E,$00, $7E,$00, $66,$00, $66,$00  ;
.byte $00,$00, $00,$18, $00,$3C, $00,$7E  ; BP 2,3
.byte $00,$7E, $00,$7E, $00,$66, $00,$66  ;

; Tile 4: Castle — battlements (white, color 15)
.byte $5A,$5A, $5A,$5A, $FF,$FF, $FF,$FF  ; BP 0,1
.byte $DB,$DB, $DB,$DB, $DB,$DB, $FF,$FF  ;
.byte $5A,$5A, $5A,$5A, $FF,$FF, $FF,$FF  ; BP 2,3
.byte $DB,$DB, $DB,$DB, $DB,$DB, $FF,$FF  ;

; Tile 5: Dungeon — dark entrance (dark gray, color 8 + red accent)
.byte $FF,$00, $C3,$00, $A5,$00, $81,$00  ; BP 0,1
.byte $81,$00, $A5,$00, $C3,$00, $FF,$00  ;
.byte $00,$FF, $00,$00, $00,$00, $00,$00  ; BP 2,3
.byte $00,$00, $00,$00, $00,$00, $00,$FF  ;

; Tile 6: Forest — tree shape (dark green, color 4)
.byte $18,$00, $3C,$00, $7E,$00, $FF,$00  ; BP 0,1
.byte $3C,$00, $7E,$00, $FF,$00, $18,$00  ;
.byte $18,$00, $3C,$00, $7E,$00, $FF,$00  ; BP 2,3
.byte $3C,$00, $7E,$00, $FF,$00, $18,$00  ;

; Tile 7: Player marker — filled diamond (bright white, color 15)
.byte $18,$18, $3C,$3C, $7E,$7E, $FF,$FF  ; BP 0,1
.byte $FF,$FF, $7E,$7E, $3C,$3C, $18,$18  ;
.byte $18,$18, $3C,$3C, $7E,$7E, $FF,$FF  ; BP 2,3
.byte $FF,$FF, $7E,$7E, $3C,$3C, $18,$18  ;

OVERWORLD_TILES_SIZE = * - OverworldTiles ; 256 bytes (8 tiles × 32)

; ----------------------------------------------------------------------------
; Overworld palette — 16 colors, SNES 15-bit BGR format (2 bytes each)
; Format: %0bbbbbgg gggrrrrr
; ----------------------------------------------------------------------------

OverworldPalette:
    .word $0000             ; 0: Transparent/black
    .word $0380             ; 1: Green (grass)        — r=0  g=28 b=0
    .word $0173             ; 2: Brown (mountain)     — r=19 g=11 b=0
    .word $7C00             ; 3: Blue (water)         — r=0  g=0  b=31
    .word $01C0             ; 4: Dark green (forest)  — r=0  g=14 b=0
    .word $0260             ; 5: Med green            — r=0  g=19 b=0
    .word $02F7             ; 6: Light brown (town)   — r=23 g=23 b=0
    .word $4210             ; 7: Gray                 — r=16 g=16 b=16
    .word $2108             ; 8: Dark gray (dungeon)  — r=8  g=8  b=8
    .word $001F             ; 9: Red                  — r=31 g=0  b=0
    .word $4BFF             ; 10: Yellow              — r=31 g=31 b=9
    .word $7EA0             ; 11: Light blue          — r=0  g=21 b=31
    .word $5294             ; 12: Medium gray         — r=20 g=20 b=20
    .word $0000             ; 13: unused
    .word $0000             ; 14: unused
    .word $7FFF             ; 15: White (player/castle)

OVERWORLD_PAL_SIZE = * - OverworldPalette ; 32 bytes

; ----------------------------------------------------------------------------
; Font tiles — 2bpp, 8x8 pixels, 16 bytes each
; 96 ASCII glyphs (space $20 through tilde $7E, plus one extra)
; 2bpp format: each row = 2 bytes (bitplane 0, bitplane 1)
; Color 0 = transparent, color 1 = white text
; We only use bitplane 0 for single-color text (color 1)
; ----------------------------------------------------------------------------

FontTiles:
; Glyph $20: Space (blank)
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $21: !
.byte $18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00,$18,$00,$00,$00
; Glyph $22: "
.byte $6C,$00,$6C,$00,$6C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $23: #
.byte $6C,$00,$FE,$00,$6C,$00,$6C,$00,$FE,$00,$6C,$00,$00,$00,$00,$00
; Glyph $24: $
.byte $18,$00,$7E,$00,$58,$00,$3C,$00,$1A,$00,$7E,$00,$18,$00,$00,$00
; Glyph $25: %
.byte $62,$00,$64,$00,$08,$00,$10,$00,$20,$00,$4C,$00,$8C,$00,$00,$00
; Glyph $26: &
.byte $38,$00,$6C,$00,$38,$00,$76,$00,$DC,$00,$CC,$00,$76,$00,$00,$00
; Glyph $27: '
.byte $18,$00,$18,$00,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $28: (
.byte $0C,$00,$18,$00,$30,$00,$30,$00,$30,$00,$18,$00,$0C,$00,$00,$00
; Glyph $29: )
.byte $30,$00,$18,$00,$0C,$00,$0C,$00,$0C,$00,$18,$00,$30,$00,$00,$00
; Glyph $2A: *
.byte $00,$00,$66,$00,$3C,$00,$FF,$00,$3C,$00,$66,$00,$00,$00,$00,$00
; Glyph $2B: +
.byte $00,$00,$18,$00,$18,$00,$7E,$00,$18,$00,$18,$00,$00,$00,$00,$00
; Glyph $2C: ,
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$18,$00,$30,$00
; Glyph $2D: -
.byte $00,$00,$00,$00,$00,$00,$7E,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $2E: .
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$18,$00,$00,$00
; Glyph $2F: /
.byte $02,$00,$04,$00,$08,$00,$10,$00,$20,$00,$40,$00,$80,$00,$00,$00
; Glyph $30: 0
.byte $3C,$00,$66,$00,$6E,$00,$76,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; Glyph $31: 1
.byte $18,$00,$38,$00,$18,$00,$18,$00,$18,$00,$18,$00,$7E,$00,$00,$00
; Glyph $32: 2
.byte $3C,$00,$66,$00,$06,$00,$0C,$00,$18,$00,$30,$00,$7E,$00,$00,$00
; Glyph $33: 3
.byte $3C,$00,$66,$00,$06,$00,$1C,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; Glyph $34: 4
.byte $0C,$00,$1C,$00,$2C,$00,$4C,$00,$7E,$00,$0C,$00,$0C,$00,$00,$00
; Glyph $35: 5
.byte $7E,$00,$60,$00,$7C,$00,$06,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; Glyph $36: 6
.byte $1C,$00,$30,$00,$60,$00,$7C,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; Glyph $37: 7
.byte $7E,$00,$06,$00,$0C,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; Glyph $38: 8
.byte $3C,$00,$66,$00,$66,$00,$3C,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; Glyph $39: 9
.byte $3C,$00,$66,$00,$66,$00,$3E,$00,$06,$00,$0C,$00,$38,$00,$00,$00
; Glyph $3A: :
.byte $00,$00,$18,$00,$18,$00,$00,$00,$18,$00,$18,$00,$00,$00,$00,$00
; Glyph $3B: ;
.byte $00,$00,$18,$00,$18,$00,$00,$00,$18,$00,$18,$00,$30,$00,$00,$00
; Glyph $3C: <
.byte $06,$00,$0C,$00,$18,$00,$30,$00,$18,$00,$0C,$00,$06,$00,$00,$00
; Glyph $3D: =
.byte $00,$00,$00,$00,$7E,$00,$00,$00,$7E,$00,$00,$00,$00,$00,$00,$00
; Glyph $3E: >
.byte $60,$00,$30,$00,$18,$00,$0C,$00,$18,$00,$30,$00,$60,$00,$00,$00
; Glyph $3F: ?
.byte $3C,$00,$66,$00,$06,$00,$0C,$00,$18,$00,$00,$00,$18,$00,$00,$00
; Glyph $40: @
.byte $3C,$00,$66,$00,$6E,$00,$6A,$00,$6E,$00,$60,$00,$3C,$00,$00,$00
; Glyph $41: A
.byte $18,$00,$3C,$00,$66,$00,$66,$00,$7E,$00,$66,$00,$66,$00,$00,$00
; Glyph $42: B
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$66,$00,$66,$00,$7C,$00,$00,$00
; Glyph $43: C
.byte $3C,$00,$66,$00,$60,$00,$60,$00,$60,$00,$66,$00,$3C,$00,$00,$00
; Glyph $44: D
.byte $78,$00,$6C,$00,$66,$00,$66,$00,$66,$00,$6C,$00,$78,$00,$00,$00
; Glyph $45: E
.byte $7E,$00,$60,$00,$60,$00,$7C,$00,$60,$00,$60,$00,$7E,$00,$00,$00
; Glyph $46: F
.byte $7E,$00,$60,$00,$60,$00,$7C,$00,$60,$00,$60,$00,$60,$00,$00,$00
; Glyph $47: G
.byte $3C,$00,$66,$00,$60,$00,$6E,$00,$66,$00,$66,$00,$3E,$00,$00,$00
; Glyph $48: H
.byte $66,$00,$66,$00,$66,$00,$7E,$00,$66,$00,$66,$00,$66,$00,$00,$00
; Glyph $49: I
.byte $7E,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$7E,$00,$00,$00
; Glyph $4A: J
.byte $1E,$00,$06,$00,$06,$00,$06,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; Glyph $4B: K
.byte $66,$00,$6C,$00,$78,$00,$70,$00,$78,$00,$6C,$00,$66,$00,$00,$00
; Glyph $4C: L
.byte $60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$7E,$00,$00,$00
; Glyph $4D: M
.byte $C6,$00,$EE,$00,$FE,$00,$D6,$00,$C6,$00,$C6,$00,$C6,$00,$00,$00
; Glyph $4E: N
.byte $66,$00,$76,$00,$7E,$00,$7E,$00,$6E,$00,$66,$00,$66,$00,$00,$00
; Glyph $4F: O
.byte $3C,$00,$66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; Glyph $50: P
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$60,$00,$60,$00,$60,$00,$00,$00
; Glyph $51: Q
.byte $3C,$00,$66,$00,$66,$00,$66,$00,$6A,$00,$6C,$00,$36,$00,$00,$00
; Glyph $52: R
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$6C,$00,$66,$00,$66,$00,$00,$00
; Glyph $53: S
.byte $3C,$00,$66,$00,$60,$00,$3C,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; Glyph $54: T
.byte $7E,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; Glyph $55: U
.byte $66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; Glyph $56: V
.byte $66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$3C,$00,$18,$00,$00,$00
; Glyph $57: W
.byte $C6,$00,$C6,$00,$C6,$00,$D6,$00,$FE,$00,$EE,$00,$C6,$00,$00,$00
; Glyph $58: X
.byte $66,$00,$66,$00,$3C,$00,$18,$00,$3C,$00,$66,$00,$66,$00,$00,$00
; Glyph $59: Y
.byte $66,$00,$66,$00,$3C,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; Glyph $5A: Z
.byte $7E,$00,$06,$00,$0C,$00,$18,$00,$30,$00,$60,$00,$7E,$00,$00,$00
; Glyph $5B: [
.byte $3C,$00,$30,$00,$30,$00,$30,$00,$30,$00,$30,$00,$3C,$00,$00,$00
; Glyph $5C: backslash
.byte $80,$00,$40,$00,$20,$00,$10,$00,$08,$00,$04,$00,$02,$00,$00,$00
; Glyph $5D: ]
.byte $3C,$00,$0C,$00,$0C,$00,$0C,$00,$0C,$00,$0C,$00,$3C,$00,$00,$00
; Glyph $5E: ^
.byte $18,$00,$3C,$00,$66,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $5F: _
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00,$00,$00
; Glyph $60: `
.byte $30,$00,$18,$00,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; Glyph $61-7A: lowercase a-z (reuse uppercase bitmaps for SNES simplicity)
; a
.byte $18,$00,$3C,$00,$66,$00,$66,$00,$7E,$00,$66,$00,$66,$00,$00,$00
; b
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$66,$00,$66,$00,$7C,$00,$00,$00
; c
.byte $3C,$00,$66,$00,$60,$00,$60,$00,$60,$00,$66,$00,$3C,$00,$00,$00
; d
.byte $78,$00,$6C,$00,$66,$00,$66,$00,$66,$00,$6C,$00,$78,$00,$00,$00
; e
.byte $7E,$00,$60,$00,$60,$00,$7C,$00,$60,$00,$60,$00,$7E,$00,$00,$00
; f
.byte $7E,$00,$60,$00,$60,$00,$7C,$00,$60,$00,$60,$00,$60,$00,$00,$00
; g
.byte $3C,$00,$66,$00,$60,$00,$6E,$00,$66,$00,$66,$00,$3E,$00,$00,$00
; h
.byte $66,$00,$66,$00,$66,$00,$7E,$00,$66,$00,$66,$00,$66,$00,$00,$00
; i
.byte $7E,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$7E,$00,$00,$00
; j
.byte $1E,$00,$06,$00,$06,$00,$06,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; k
.byte $66,$00,$6C,$00,$78,$00,$70,$00,$78,$00,$6C,$00,$66,$00,$00,$00
; l
.byte $60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$60,$00,$7E,$00,$00,$00
; m
.byte $C6,$00,$EE,$00,$FE,$00,$D6,$00,$C6,$00,$C6,$00,$C6,$00,$00,$00
; n
.byte $66,$00,$76,$00,$7E,$00,$7E,$00,$6E,$00,$66,$00,$66,$00,$00,$00
; o
.byte $3C,$00,$66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; p
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$60,$00,$60,$00,$60,$00,$00,$00
; q
.byte $3C,$00,$66,$00,$66,$00,$66,$00,$6A,$00,$6C,$00,$36,$00,$00,$00
; r
.byte $7C,$00,$66,$00,$66,$00,$7C,$00,$6C,$00,$66,$00,$66,$00,$00,$00
; s
.byte $3C,$00,$66,$00,$60,$00,$3C,$00,$06,$00,$66,$00,$3C,$00,$00,$00
; t
.byte $7E,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; u
.byte $66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$00,$00
; v
.byte $66,$00,$66,$00,$66,$00,$66,$00,$3C,$00,$3C,$00,$18,$00,$00,$00
; w
.byte $C6,$00,$C6,$00,$C6,$00,$D6,$00,$FE,$00,$EE,$00,$C6,$00,$00,$00
; x
.byte $66,$00,$66,$00,$3C,$00,$18,$00,$3C,$00,$66,$00,$66,$00,$00,$00
; y
.byte $66,$00,$66,$00,$3C,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; z
.byte $7E,$00,$06,$00,$0C,$00,$18,$00,$30,$00,$60,$00,$7E,$00,$00,$00
; Glyph $7B: {
.byte $0E,$00,$18,$00,$18,$00,$70,$00,$18,$00,$18,$00,$0E,$00,$00,$00
; Glyph $7C: |
.byte $18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$18,$00,$00,$00
; Glyph $7D: }
.byte $70,$00,$18,$00,$18,$00,$0E,$00,$18,$00,$18,$00,$70,$00,$00,$00
; Glyph $7E: ~
.byte $00,$00,$00,$00,$32,$00,$7F,$00,$4C,$00,$00,$00,$00,$00,$00,$00
; Glyph $7F: padding (blank)
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

FONT_TILES_SIZE = * - FontTiles ; 1536 bytes (96 glyphs × 16)

; ----------------------------------------------------------------------------
; Dungeon tiles — 4bpp, 8x8 pixels, 32 bytes each
; 8 tiles: floor, wall, wall-highlight, door, floor-pattern, stairs, chest, wall-edge
; ----------------------------------------------------------------------------

DungeonTiles:

; Tile 0: Floor — empty/dark
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 1: Stone wall — brick pattern (gray)
.byte $FF,$00, $81,$00, $FF,$00, $C3,$00  ; BP 0,1
.byte $FF,$00, $81,$00, $FF,$00, $C3,$00
.byte $00,$FF, $00,$81, $00,$FF, $00,$C3  ; BP 2,3
.byte $00,$FF, $00,$81, $00,$FF, $00,$C3

; Tile 2: Wall highlight — lighter brick (light gray)
.byte $FF,$FF, $81,$81, $FF,$FF, $C3,$C3  ; BP 0,1
.byte $FF,$FF, $81,$81, $FF,$FF, $C3,$C3
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 2,3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 3: Door — arch shape (brown)
.byte $FF,$00, $C3,$00, $A5,$00, $99,$00  ; BP 0,1
.byte $99,$00, $99,$00, $99,$00, $FF,$00
.byte $00,$00, $00,$C3, $00,$A5, $00,$99  ; BP 2,3
.byte $00,$99, $00,$99, $00,$99, $00,$00

; Tile 4: Floor pattern — tiled floor
.byte $AA,$00, $55,$00, $AA,$00, $55,$00  ; BP 0,1
.byte $AA,$00, $55,$00, $AA,$00, $55,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 2,3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 5: Stairs — step pattern
.byte $FF,$00, $7F,$00, $3F,$00, $1F,$00  ; BP 0,1
.byte $0F,$00, $07,$00, $03,$00, $01,$00
.byte $00,$FF, $00,$7F, $00,$3F, $00,$1F  ; BP 2,3
.byte $00,$0F, $00,$07, $00,$03, $00,$01

; Tile 6: Chest — box shape (yellow/gold)
.byte $7E,$00, $FF,$00, $FF,$00, $DB,$00  ; BP 0,1
.byte $DB,$00, $FF,$00, $FF,$00, $7E,$00
.byte $00,$7E, $00,$FF, $00,$FF, $00,$DB  ; BP 2,3
.byte $00,$DB, $00,$FF, $00,$FF, $00,$7E

; Tile 7: Wall edge — vertical line
.byte $C0,$00, $C0,$00, $C0,$00, $C0,$00  ; BP 0,1
.byte $C0,$00, $C0,$00, $C0,$00, $C0,$00
.byte $00,$C0, $00,$C0, $00,$C0, $00,$C0  ; BP 2,3
.byte $00,$C0, $00,$C0, $00,$C0, $00,$C0

DUNGEON_TILES_SIZE = * - DungeonTiles ; 256 bytes

; ----------------------------------------------------------------------------
; Dungeon palette — 16 colors
; ----------------------------------------------------------------------------

DungeonPalette:
    .word $0000             ; 0: Black (floor)
    .word $2108             ; 1: Dark gray
    .word $4210             ; 2: Medium gray (wall)
    .word $6318             ; 3: Light gray (wall highlight)
    .word $0173             ; 4: Brown (door)
    .word $02F7             ; 5: Light brown
    .word $4BFF             ; 6: Yellow/gold (chest)
    .word $5294             ; 7: Silver
    .word $001F             ; 8: Red (danger)
    .word $0380             ; 9: Green
    .word $7C00             ; 10: Blue
    .word $7FFF             ; 11: White (stairs)
    .word $18C6             ; 12: Darker gray
    .word $0000             ; 13: unused
    .word $0000             ; 14: unused
    .word $7FFF             ; 15: Bright white

DUNGEON_PAL_SIZE = * - DungeonPalette ; 32 bytes
