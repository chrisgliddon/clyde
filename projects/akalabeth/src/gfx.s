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

    ; --- Configure PPU for Mode 1 (via shadow registers) ---
    lda #$01                ; Mode 1, 8x8 tiles
    sta SHADOW_BGMODE

    ; BG1 tilemap at VRAM $2000
    lda #$20
    sta SHADOW_BG1SC

    ; BG3 tilemap at VRAM $3000
    lda #$30
    sta SHADOW_BG3SC

    ; BG1 char base = VRAM $0000, BG2 = 0
    stz SHADOW_BG12NBA

    ; BG3 char base = word $1000, BG4 = 0
    lda #$01
    sta SHADOW_BG34NBA

    ; Enable BG1 + BG3 on main screen
    lda #$05
    sta SHADOW_TM

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
    ; Color 4 = black (BG3 pal 1 color 0 — transparent anyway)
    stz CGDATA
    stz CGDATA
    ; Color 5 = white ($7FFF) — BG3 font color (pal 1 color 1)
    lda #$FF
    sta CGDATA
    lda #$7F
    sta CGDATA
    ; Color 6 = black
    stz CGDATA
    stz CGDATA
    ; Color 7 = black
    stz CGDATA
    stz CGDATA

    ; --- BG3 colored palettes for UI text ---
    ; BG3 pal 2 (colors 8-11): color 9 = Green (shop)
    lda #$08
    sta CGADD
    stz CGDATA
    stz CGDATA              ; 8: transparent
    lda #$E0
    sta CGDATA
    lda #$03
    sta CGDATA              ; 9: Green $03E0
    stz CGDATA
    stz CGDATA              ; 10: black
    stz CGDATA
    stz CGDATA              ; 11: black

    ; BG3 pal 3 (colors 12-15): color 13 = Yellow (castle)
    lda #$0C
    sta CGADD
    stz CGDATA
    stz CGDATA              ; 12: transparent
    lda #$FF
    sta CGDATA
    lda #$03
    sta CGDATA              ; 13: Yellow $03FF
    stz CGDATA
    stz CGDATA              ; 14: black
    stz CGDATA
    stz CGDATA              ; 15: black

    ; BG3 pal 4 (colors 16-19): color 17 = Cyan (chargen)
    lda #$10
    sta CGADD
    stz CGDATA
    stz CGDATA              ; 16: transparent
    lda #$E0
    sta CGDATA
    lda #$7F
    sta CGDATA              ; 17: Cyan $7FE0
    stz CGDATA
    stz CGDATA              ; 18: black
    stz CGDATA
    stz CGDATA              ; 19: black

    ; BG3 pal 5 (colors 20-23): color 21 = Red (game over)
    lda #$14
    sta CGADD
    stz CGDATA
    stz CGDATA              ; 20: transparent
    lda #$1F
    sta CGDATA
    lda #$00
    sta CGDATA              ; 21: Red $001F
    stz CGDATA
    stz CGDATA              ; 22: black
    stz CGDATA
    stz CGDATA              ; 23: black

    ; BG3 pal 6 (colors 24-27): color 25 = Gold (victory)
    lda #$18
    sta CGADD
    stz CGDATA
    stz CGDATA              ; 24: transparent
    lda #$BF
    sta CGDATA
    lda #$02
    sta CGDATA              ; 25: Gold $02BF
    stz CGDATA
    stz CGDATA              ; 26: black
    stz CGDATA
    stz CGDATA              ; 27: black

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
; Black & white wireframe: color 0 (black) + color 15 (white) only
; 4bpp: white pixel = all 4 bitplanes set, black = all clear
; ----------------------------------------------------------------------------

OverworldTiles:

; B&W wireframe tiles — color 15 (white) on color 0 (black)
; All white pixels: BP0=BP1=BP2=BP3=pattern

; Tile 0: Grass — empty black
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 0,1
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; BP 2,3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 1: Mountain — wireframe triangle
.byte $00,$00, $18,$18, $24,$24, $42,$42  ; BP 0,1
.byte $81,$81, $FF,$FF, $00,$00, $00,$00
.byte $00,$00, $18,$18, $24,$24, $42,$42  ; BP 2,3
.byte $81,$81, $FF,$FF, $00,$00, $00,$00

; Tile 2: Water — wireframe wavy lines
.byte $00,$00, $00,$00, $66,$66, $99,$99  ; BP 0,1
.byte $00,$00, $66,$66, $99,$99, $00,$00
.byte $00,$00, $00,$00, $66,$66, $99,$99  ; BP 2,3
.byte $00,$00, $66,$66, $99,$99, $00,$00

; Tile 3: Town — wireframe building with door
.byte $18,$18, $3C,$3C, $7E,$7E, $42,$42  ; BP 0,1
.byte $5A,$5A, $5A,$5A, $5A,$5A, $FF,$FF
.byte $18,$18, $3C,$3C, $7E,$7E, $42,$42  ; BP 2,3
.byte $5A,$5A, $5A,$5A, $5A,$5A, $FF,$FF

; Tile 4: Castle — wireframe battlements + inner box
.byte $AA,$AA, $FF,$FF, $81,$81, $BD,$BD  ; BP 0,1
.byte $A5,$A5, $BD,$BD, $81,$81, $FF,$FF
.byte $AA,$AA, $FF,$FF, $81,$81, $BD,$BD  ; BP 2,3
.byte $A5,$A5, $BD,$BD, $81,$81, $FF,$FF

; Tile 5: Dungeon — wireframe X marker
.byte $81,$81, $42,$42, $24,$24, $18,$18  ; BP 0,1
.byte $18,$18, $24,$24, $42,$42, $81,$81
.byte $81,$81, $42,$42, $24,$24, $18,$18  ; BP 2,3
.byte $18,$18, $24,$24, $42,$42, $81,$81

; Tile 6: Forest — wireframe tree outline
.byte $18,$18, $3C,$3C, $7E,$7E, $3C,$3C  ; BP 0,1
.byte $7E,$7E, $FF,$FF, $18,$18, $18,$18
.byte $18,$18, $3C,$3C, $7E,$7E, $3C,$3C  ; BP 2,3
.byte $7E,$7E, $FF,$FF, $18,$18, $18,$18

; Tile 7: Player — + crosshair
.byte $00,$00, $18,$18, $18,$18, $FF,$FF  ; BP 0,1
.byte $FF,$FF, $18,$18, $18,$18, $00,$00
.byte $00,$00, $18,$18, $18,$18, $FF,$FF  ; BP 2,3
.byte $FF,$FF, $18,$18, $18,$18, $00,$00

OVERWORLD_TILES_SIZE = * - OverworldTiles ; 256 bytes (8 tiles × 32)

; ----------------------------------------------------------------------------
; Overworld palette — B&W: color 0=black, 5=white (font), 15=white (tiles)
; SNES 15-bit BGR format (2 bytes each)
; ----------------------------------------------------------------------------

OverworldPalette:
    ; Palette 0: White (unused fallback)
    .word $0000             ; 0: Black (transparent)
    .word $0000, $0000, $0000
    .word $0000             ; 4: Black (BG3 pal 1 color 0)
    .word $7FFF             ; 5: White (BG3 font — must stay white in all pals)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: White

    ; Palette 1: Green (grass, forest)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03E0             ; 15: Green

    ; Palette 2: Blue (water)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7C00             ; 15: Blue

    ; Palette 3: Brown (mountain)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0193             ; 15: Brown

    ; Palette 4: Yellow (town, castle)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03FF             ; 15: Yellow

    ; Palette 5: Red (dungeon, player)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $001F             ; 15: Red

OVERWORLD_PAL_SIZE = * - OverworldPalette ; 192 bytes (6 palettes × 32)

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
; Dungeon tiles — 4bpp, 8x8 B&W wireframe
; 18 tiles: floor, wall, wall-filled, door, floor-pattern, stairs, chest, wall-edge
; monster tiles $08-$11: skeleton, thief, giant rat, orc, viper, carrion crawler, gremlin, mimic, daemon, balrog
; ----------------------------------------------------------------------------

DungeonTiles:

; B&W wireframe dungeon tiles — color 15 (white) on color 0 (black)

; Tile 0: Floor — empty black
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 1: Wall — white outline rectangle
.byte $FF,$FF, $81,$81, $81,$81, $81,$81  ; BP 0,1
.byte $81,$81, $81,$81, $81,$81, $FF,$FF
.byte $FF,$FF, $81,$81, $81,$81, $81,$81  ; BP 2,3
.byte $81,$81, $81,$81, $81,$81, $FF,$FF

; Tile 2: Wall filled — solid white block
.byte $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF  ; BP 0,1
.byte $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF
.byte $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF  ; BP 2,3
.byte $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF

; Tile 3: Door — wireframe arch
.byte $7E,$7E, $C3,$C3, $81,$81, $81,$81  ; BP 0,1
.byte $81,$81, $81,$81, $81,$81, $81,$81
.byte $7E,$7E, $C3,$C3, $81,$81, $81,$81  ; BP 2,3
.byte $81,$81, $81,$81, $81,$81, $81,$81

; Tile 4: Floor pattern — sparse grid dots
.byte $88,$88, $00,$00, $22,$22, $00,$00  ; BP 0,1
.byte $88,$88, $00,$00, $22,$22, $00,$00
.byte $88,$88, $00,$00, $22,$22, $00,$00  ; BP 2,3
.byte $88,$88, $00,$00, $22,$22, $00,$00

; Tile 5: Stairs — wireframe ladder rungs
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E  ; BP 0,1
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E  ; BP 2,3
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E

; Tile 6: Chest — wireframe box with latch
.byte $00,$00, $7E,$7E, $42,$42, $7E,$7E  ; BP 0,1
.byte $4A,$4A, $42,$42, $7E,$7E, $00,$00
.byte $00,$00, $7E,$7E, $42,$42, $7E,$7E  ; BP 2,3
.byte $4A,$4A, $42,$42, $7E,$7E, $00,$00

; Tile 7: Wall edge — vertical line (left side)
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0  ; BP 0,1
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0  ; BP 2,3
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0

; Tile $08: Skeleton — skull + ribcage
.byte $3C,$3C, $42,$42, $3C,$3C, $18,$18  ; BP 0,1
.byte $7E,$7E, $5A,$5A, $3C,$3C, $24,$24
.byte $3C,$3C, $42,$42, $3C,$3C, $18,$18  ; BP 2,3
.byte $7E,$7E, $5A,$5A, $3C,$3C, $24,$24

; Tile $09: Thief — hooded figure with dagger
.byte $18,$18, $3C,$3C, $18,$18, $3C,$3C  ; BP 0,1
.byte $5A,$5A, $18,$18, $24,$24, $24,$24
.byte $18,$18, $3C,$3C, $18,$18, $3C,$3C  ; BP 2,3
.byte $5A,$5A, $18,$18, $24,$24, $24,$24

; Tile $0A: Giant Rat — low quadruped with tail
.byte $00,$00, $00,$00, $38,$38, $7C,$7C  ; BP 0,1
.byte $FE,$FE, $44,$44, $44,$44, $02,$02
.byte $00,$00, $00,$00, $38,$38, $7C,$7C  ; BP 2,3
.byte $FE,$FE, $44,$44, $44,$44, $02,$02

; Tile $0B: Orc — broad squat humanoid
.byte $3C,$3C, $7E,$7E, $3C,$3C, $7E,$7E  ; BP 0,1
.byte $FF,$FF, $7E,$7E, $24,$24, $66,$66
.byte $3C,$3C, $7E,$7E, $3C,$3C, $7E,$7E  ; BP 2,3
.byte $FF,$FF, $7E,$7E, $24,$24, $66,$66

; Tile $0C: Viper — sinuous S-curve snake
.byte $06,$06, $0E,$0E, $1C,$1C, $38,$38  ; BP 0,1
.byte $70,$70, $E0,$E0, $70,$70, $38,$38
.byte $06,$06, $0E,$0E, $1C,$1C, $38,$38  ; BP 2,3
.byte $70,$70, $E0,$E0, $70,$70, $38,$38

; Tile $0D: Carrion Crawler — segmented worm
.byte $00,$00, $7E,$7E, $FF,$FF, $DB,$DB  ; BP 0,1
.byte $FF,$FF, $DB,$DB, $7E,$7E, $00,$00
.byte $00,$00, $7E,$7E, $FF,$FF, $DB,$DB  ; BP 2,3
.byte $FF,$FF, $DB,$DB, $7E,$7E, $00,$00

; Tile $0E: Gremlin — small imp with pointed ears
.byte $42,$42, $3C,$3C, $7E,$7E, $18,$18  ; BP 0,1
.byte $3C,$3C, $18,$18, $24,$24, $00,$00
.byte $42,$42, $3C,$3C, $7E,$7E, $18,$18  ; BP 2,3
.byte $3C,$3C, $18,$18, $24,$24, $00,$00

; Tile $0F: Mimic — chest with teeth
.byte $00,$00, $7E,$7E, $5A,$5A, $7E,$7E  ; BP 0,1
.byte $4A,$4A, $42,$42, $7E,$7E, $00,$00
.byte $00,$00, $7E,$7E, $5A,$5A, $7E,$7E  ; BP 2,3
.byte $4A,$4A, $42,$42, $7E,$7E, $00,$00

; Tile $10: Daemon — winged humanoid
.byte $18,$18, $3C,$3C, $18,$18, $FF,$FF  ; BP 0,1
.byte $DB,$DB, $18,$18, $24,$24, $42,$42
.byte $18,$18, $3C,$3C, $18,$18, $FF,$FF  ; BP 2,3
.byte $DB,$DB, $18,$18, $24,$24, $42,$42

; Tile $11: Balrog — large horned figure
.byte $66,$66, $3C,$3C, $18,$18, $FF,$FF  ; BP 0,1
.byte $7E,$7E, $3C,$3C, $66,$66, $C3,$C3
.byte $66,$66, $3C,$3C, $18,$18, $FF,$FF  ; BP 2,3
.byte $7E,$7E, $3C,$3C, $66,$66, $C3,$C3

DUNGEON_TILES_SIZE = * - DungeonTiles

; ----------------------------------------------------------------------------
; Dungeon palette — B&W: same as overworld
; ----------------------------------------------------------------------------

DungeonPalette:
    ; Palette 0: White (walls, floor, empty)
    .word $0000             ; 0: Black (transparent)
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: White

    ; Palette 1: Brown (doors)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0193             ; 15: Brown

    ; Palette 2: Yellow (stairs, chests)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03FF             ; 15: Yellow

    ; Palette 3: Red (monsters)
    .word $0000
    .word $0000, $0000, $0000
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $001F             ; 15: Red

DUNGEON_PAL_SIZE = * - DungeonPalette ; 128 bytes (4 palettes × 32)
