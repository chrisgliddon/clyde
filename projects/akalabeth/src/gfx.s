; gfx.s — Akalabeth graphics: tile data, palettes, VRAM uploads
; VRAM layout:
;   $0000-$0FFF  BG1 tiles (4bpp overworld/dungeon, up to 256 tiles)
;   $1000-$17FF  BG3 tiles (2bpp font, 96 glyphs)
;   $2000-$27FF  BG1 tilemap (32x32)
;   $3000-$37FF  BG3 tilemap (32x32)

.include "macros.s"

.export GfxUploadOverworld, GfxUploadFont, GfxUploadDungeon, SetBackdropColor


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

    ; Enable OBJ + BG1 + BG3 on main screen
    lda #$15
    sta SHADOW_TM

    ; --- Upload player sprite tiles to VRAM $4000 ---
    ; Top row (tiles 0-1): 64 bytes → VRAM word $4000
    lda #$80
    sta VMAIN
    stz VMADDL
    lda #$40                ; VRAM word address $4000
    sta VMADDH
    lda #DMA_2REG_1W
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<PlayerSprTiles
    sta A1T0L
    lda #>PlayerSprTiles
    sta A1T0H
    lda #^PlayerSprTiles
    sta A1B0
    lda #$40                ; 64 bytes
    sta DAS0L
    stz DAS0H
    lda #$01
    sta MDMAEN

    ; Bottom row (tiles 16-17): 64 bytes → VRAM word $4100
    stz VMADDL
    lda #$41                ; VRAM word address $4100
    sta VMADDH
    lda #<(PlayerSprTiles + 64)
    sta A1T0L
    lda #>(PlayerSprTiles + 64)
    sta A1T0H
    lda #^(PlayerSprTiles + 64)
    sta A1B0
    lda #$40
    sta DAS0L
    stz DAS0H
    lda #$01
    sta MDMAEN

    ; --- Upload OBJ palette 0 to CGRAM $80 ---
    lda #$80                ; OBJ palette 0 starts at CGRAM word $80
    sta CGADD
    lda #DMA_1REG_1W
    sta DMAP0
    lda #$22                ; CGDATA
    sta BBAD0
    lda #<ObjPalette0
    sta A1T0L
    lda #>ObjPalette0
    sta A1T0H
    lda #^ObjPalette0
    sta A1B0
    lda #<OBJ_PAL0_SIZE
    sta DAS0L
    lda #>OBJ_PAL0_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN

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

    ; --- Sprite tiles + OBJ palettes (same as overworld) ---
    ; Upload monster sprite tiles to VRAM $4020 (tile 2 top row)
    lda #$80
    sta VMAIN
    lda #$20
    sta VMADDL
    lda #$40                ; VRAM word $4020
    sta VMADDH
    lda #DMA_2REG_1W
    sta DMAP0
    lda #$18
    sta BBAD0
    lda #<MonsterSprTiles
    sta A1T0L
    lda #>MonsterSprTiles
    sta A1T0H
    lda #^MonsterSprTiles
    sta A1B0
    lda #$40                ; 64 bytes (tiles 2-3)
    sta DAS0L
    stz DAS0H
    lda #$01
    sta MDMAEN

    ; Bottom row → VRAM $4120 (tile 18 row)
    lda #$20
    sta VMADDL
    lda #$41                ; VRAM word $4120
    sta VMADDH
    lda #<(MonsterSprTiles + 64)
    sta A1T0L
    lda #>(MonsterSprTiles + 64)
    sta A1T0H
    lda #^(MonsterSprTiles + 64)
    sta A1B0
    lda #$40
    sta DAS0L
    stz DAS0H
    lda #$01
    sta MDMAEN

    ; Upload 4 OBJ palettes (128 bytes → CGRAM $80)
    lda #$80
    sta CGADD
    lda #DMA_1REG_1W
    sta DMAP0
    lda #$22
    sta BBAD0
    lda #<MonsterObjPalettes
    sta A1T0L
    lda #>MonsterObjPalettes
    sta A1T0H
    lda #^MonsterObjPalettes
    sta A1B0
    lda #$80                ; 128 bytes = 4 palettes
    sta DAS0L
    stz DAS0H
    lda #$01
    sta MDMAEN

    ; Enable OBJ on main screen
    lda #$15
    sta SHADOW_TM

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
; SetBackdropColor — write 15-bit color to CGRAM $00 (backdrop)
; Input: A (16-bit) = color value. Call with A16.
; ============================================================================
.proc SetBackdropColor
    SET_A8
    pha                         ; Save low byte
    stz CGADD                   ; CGRAM address 0
    pla
    sta CGDATA                  ; Low byte
    xba
    sta CGDATA                  ; High byte
    rts
.endproc

; ============================================================================
; RODATA — Tile data and palettes
; ============================================================================

.segment "GFXDATA"

; ----------------------------------------------------------------------------
; Overworld tiles — 4bpp, 8x8 pixels, 32 bytes each
; 8 tiles: grass, mountain, water, town, castle, dungeon, forest, player
; Filled tiles using colors 1-3 (bp0/bp1 only, bp2/bp3 = $00):
;   Color 1 (bp0 only): main fill
;   Color 2 (bp1 only): detail/texture
;   Color 3 (bp0+bp1): highlight/accent
; ----------------------------------------------------------------------------

OverworldTiles:

; Tile 0: Grass — solid color 1 fill + scattered color 2 texture dots
;   Rows of $FF with some $22/$44 sprinkled in bp1 for texture
.byte $FF,$00, $FF,$22, $FF,$00, $FF,$44  ; bp0,bp1 rows 0-3
.byte $FF,$00, $FF,$88, $FF,$00, $FF,$11  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3 (all zero)
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 1: Mountain — color 1 body + color 2 dark base + color 3 peak
;   Peak = bp0+bp1, body = bp0, base = bp1
.byte $18,$18, $3C,$18, $7E,$00, $7E,$00  ; bp0,bp1 rows 0-3
.byte $FF,$00, $FF,$00, $FF,$FF, $00,$FF  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 2: Water — color 1 fill + color 3 wave crests
;   All bp0 = $FF (fill), wave lines in bp1
.byte $FF,$66, $FF,$00, $FF,$99, $FF,$00  ; bp0,bp1 rows 0-3
.byte $FF,$66, $FF,$00, $FF,$99, $FF,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 3: Town — color 1 walls + color 3 door/window
;   Building shape in bp0, door/window in bp0+bp1
.byte $18,$00, $3C,$00, $7E,$00, $42,$18  ; bp0,bp1 rows 0-3
.byte $42,$18, $42,$18, $42,$18, $FF,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 4: Castle — color 1 walls + color 3 battlements
;   Battlement pattern = bp0+bp1 at top
.byte $AA,$AA, $FF,$FF, $81,$00, $BD,$00  ; bp0,bp1 rows 0-3
.byte $A5,$00, $BD,$00, $81,$00, $FF,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 5: Dungeon — color 1 fill + color 2 X marker
;   Solid fill in bp0, X pattern in bp1 only
.byte $FF,$81, $FF,$42, $FF,$24, $FF,$18  ; bp0,bp1 rows 0-3
.byte $FF,$18, $FF,$24, $FF,$42, $FF,$81  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 6: Forest — color 1 canopy + color 2 trunk
;   Canopy in bp0, trunk detail in bp1
.byte $18,$00, $3C,$00, $7E,$00, $3C,$00  ; bp0,bp1 rows 0-3
.byte $7E,$00, $FF,$00, $18,$18, $18,$18  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 7: Player crosshair (unused — player is sprite now)
.byte $00,$00, $18,$18, $18,$18, $FF,$FF  ; bp0,bp1 rows 0-3
.byte $FF,$FF, $18,$18, $18,$18, $00,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

OVERWORLD_TILES_SIZE = * - OverworldTiles ; 256 bytes (8 tiles × 32)

; ----------------------------------------------------------------------------
; Overworld palette — multi-shade Ultima-inspired colors
; Colors 1-3: fill, detail, highlight. Color 5: BG3 font (white).
; SNES 15-bit BGR format: %0bbbbbgg gggrrrrr
; ----------------------------------------------------------------------------

OverworldPalette:
    ; Palette 0: Default grey
    .word $0000             ; 0: Black (transparent)
    .word $294A             ; 1: dark grey (fill)
    .word $4A52             ; 2: mid grey (detail)
    .word $7FFF             ; 3: white (highlight)
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: (unused)

    ; Palette 1: Grass green
    .word $0000
    .word $0284             ; 1: rich green R4,G20,B0
    .word $0182             ; 2: dark green R2,G12,B0
    .word $0B48             ; 3: bright green R8,G26,B2
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03E0             ; 15: (unused)

    ; Palette 2: Water blue
    .word $0000
    .word $5100             ; 1: medium blue R0,G8,B20
    .word $3880             ; 2: dark blue R0,G4,B14
    .word $7314             ; 3: light cyan R20,G24,B28
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7C00             ; 15: (unused)

    ; Palette 3: Mountain brown
    .word $0000
    .word $090C             ; 1: brown R12,G8,B2
    .word $04A8             ; 2: dark brown R8,G5,B1
    .word $318C             ; 3: light grey R12,G12,B12
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0193             ; 15: (unused)

    ; Palette 4: Town/Castle tan
    .word $0000
    .word $0193             ; 1: brown
    .word $02DF             ; 2: tan/gold
    .word $7FFF             ; 3: white
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03FF             ; 15: (unused)

    ; Palette 5: Dungeon/Player
    .word $0000
    .word $0C63             ; 1: dark grey
    .word $001F             ; 2: red
    .word $7FFF             ; 3: white
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $001F             ; 15: (unused)

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

; Filled dungeon tiles — colors 1-3 via bp0/bp1, bp2/bp3 = $00
; Color 1 (bp0): fill, Color 2 (bp1): detail, Color 3 (bp0+bp1): highlight

; Tile 0: Floor — subtle texture on color 1 fill
.byte $FF,$00, $FF,$88, $FF,$00, $FF,$22  ; bp0,bp1 rows 0-3
.byte $FF,$00, $FF,$44, $FF,$00, $FF,$11  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 1: Wall — stone block pattern (color 1 fill + color 2 mortar lines)
.byte $FF,$FF, $FF,$00, $FF,$00, $FF,$00  ; bp0,bp1 rows 0-3
.byte $FF,$FF, $FF,$00, $FF,$00, $FF,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 2: Wall filled — solid color 1 (stone)
.byte $FF,$00, $FF,$00, $FF,$00, $FF,$00  ; bp0,bp1
.byte $FF,$00, $FF,$00, $FF,$00, $FF,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 3: Door — color 1 arch + color 3 door frame
.byte $7E,$7E, $C3,$C3, $81,$81, $81,$00  ; bp0,bp1 rows 0-3
.byte $81,$00, $81,$00, $81,$81, $81,$81  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 4: Floor pattern — color 1 fill + color 2 grid dots
.byte $FF,$88, $FF,$00, $FF,$22, $FF,$00  ; bp0,bp1 rows 0-3
.byte $FF,$88, $FF,$00, $FF,$22, $FF,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 5: Stairs — color 1 rails + color 3 rungs
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E  ; bp0,bp1 rows 0-3
.byte $42,$42, $7E,$7E, $42,$42, $7E,$7E  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 6: Chest — color 1 box + color 3 latch highlight
.byte $00,$00, $7E,$00, $42,$00, $7E,$7E  ; bp0,bp1 rows 0-3
.byte $4A,$08, $42,$00, $7E,$00, $00,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile 7: Wall edge — color 1 vertical line (left side)
.byte $C0,$00, $C0,$00, $C0,$00, $C0,$00  ; bp0,bp1
.byte $C0,$00, $C0,$00, $C0,$00, $C0,$00
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $08: Skeleton — color 1 body + color 3 skull highlight
.byte $3C,$3C, $42,$00, $3C,$00, $18,$00  ; bp0,bp1 rows 0-3
.byte $7E,$00, $5A,$00, $3C,$00, $24,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $09: Thief — color 1 body + color 2 hood
.byte $18,$18, $3C,$3C, $18,$00, $3C,$00  ; bp0,bp1 rows 0-3
.byte $5A,$00, $18,$00, $24,$00, $24,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0A: Giant Rat — color 1 body
.byte $00,$00, $00,$00, $38,$00, $7C,$00  ; bp0,bp1 rows 0-3
.byte $FE,$00, $44,$00, $44,$00, $02,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0B: Orc — color 1 body + color 3 head
.byte $3C,$3C, $7E,$7E, $3C,$00, $7E,$00  ; bp0,bp1 rows 0-3
.byte $FF,$00, $7E,$00, $24,$00, $66,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0C: Viper — color 1 body
.byte $06,$00, $0E,$00, $1C,$00, $38,$00  ; bp0,bp1 rows 0-3
.byte $70,$00, $E0,$00, $70,$00, $38,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0D: Carrion Crawler — color 1 body + color 2 segments
.byte $00,$00, $7E,$00, $FF,$00, $DB,$24  ; bp0,bp1 rows 0-3
.byte $FF,$00, $DB,$24, $7E,$00, $00,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0E: Gremlin — color 1 body + color 3 ears
.byte $42,$42, $3C,$3C, $7E,$00, $18,$00  ; bp0,bp1 rows 0-3
.byte $3C,$00, $18,$00, $24,$00, $00,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $0F: Mimic — color 1 box + color 3 teeth highlight
.byte $00,$00, $7E,$00, $5A,$5A, $7E,$7E  ; bp0,bp1 rows 0-3
.byte $4A,$08, $42,$00, $7E,$00, $00,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $10: Daemon — color 1 body + color 3 wings
.byte $18,$00, $3C,$00, $18,$00, $FF,$E7  ; bp0,bp1 rows 0-3
.byte $DB,$C3, $18,$00, $24,$00, $42,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

; Tile $11: Balrog — color 1 body + color 3 horns
.byte $66,$66, $3C,$3C, $18,$00, $FF,$00  ; bp0,bp1 rows 0-3
.byte $7E,$00, $3C,$00, $66,$00, $C3,$00  ; bp0,bp1 rows 4-7
.byte $00,$00, $00,$00, $00,$00, $00,$00  ; bp2,bp3
.byte $00,$00, $00,$00, $00,$00, $00,$00

DUNGEON_TILES_SIZE = * - DungeonTiles

; ----------------------------------------------------------------------------
; Dungeon palette — brown/earthy stone tones
; Colors 1-3: fill, detail, highlight. Color 5: BG3 font (white).
; ----------------------------------------------------------------------------

DungeonPalette:
    ; Palette 0: Stone walls/floor
    .word $0000             ; 0: Black (transparent)
    .word $090A             ; 1: brown stone
    .word $04C8             ; 2: dark stone
    .word $0D4E             ; 3: light stone
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: (unused)

    ; Palette 1: Doors (warm brown)
    .word $0000
    .word $0193             ; 1: warm brown
    .word $00C2             ; 2: dark brown
    .word $02DF             ; 3: tan
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0193             ; 15: (unused)

    ; Palette 2: Stairs/chests (gold/tan)
    .word $0000
    .word $02DF             ; 1: gold/tan
    .word $0193             ; 2: brown
    .word $7FFF             ; 3: white highlight
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03FF             ; 15: (unused)

    ; Palette 3: Monsters (red)
    .word $0000
    .word $001F             ; 1: red
    .word $0C63             ; 2: dark grey
    .word $7FFF             ; 3: white
    .word $0000
    .word $7FFF             ; 5: White (BG3 font)
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $001F             ; 15: (unused)

DUNGEON_PAL_SIZE = * - DungeonPalette ; 128 bytes (4 palettes × 32)

; ----------------------------------------------------------------------------
; Player sprite tiles — 4bpp 16x16 crosshair (4 × 8x8 tiles = 128 bytes)
; Arranged as: tiles 0,1 (top row) then tiles 16,17 (bottom row)
; Color 15 (all bitplanes set) for crosshair pixels
; 2-pixel-wide cross centered in the 16x16 area
; ----------------------------------------------------------------------------

PlayerSprTiles:

; Tile 0 (top-left): vertical bar right edge + horizontal bar bottom
; Pattern: $03 (rows 0-5), $FF (rows 6-7)
.byte $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $FF,$FF, $FF,$FF
.byte $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $FF,$FF, $FF,$FF

; Tile 1 (top-right): vertical bar left edge + horizontal bar bottom
; Pattern: $C0 (rows 0-5), $FF (rows 6-7)
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $FF,$FF, $FF,$FF
.byte $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $FF,$FF, $FF,$FF

; Tile 2 (bottom-left = VRAM tile 16): horizontal bar top + vertical bar right
; Pattern: $FF (rows 0-1), $03 (rows 2-7)
.byte $FF,$FF, $FF,$FF, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03
.byte $FF,$FF, $FF,$FF, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03

; Tile 3 (bottom-right = VRAM tile 17): horizontal bar top + vertical bar left
; Pattern: $FF (rows 0-1), $C0 (rows 2-7)
.byte $FF,$FF, $FF,$FF, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0
.byte $FF,$FF, $FF,$FF, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0, $C0,$C0

PLAYER_SPR_SIZE = * - PlayerSprTiles ; 128 bytes

; ----------------------------------------------------------------------------
; OBJ palette 0 — white crosshair (visible on green overworld)
; CGRAM $80-$8F (16 colors × 2 bytes = 32 bytes)
; ----------------------------------------------------------------------------

ObjPalette0:
    .word $0000             ; 0: transparent
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: White

OBJ_PAL0_SIZE = * - ObjPalette0 ; 32 bytes

; ----------------------------------------------------------------------------
; Monster sprite tiles — 4bpp 16x16 generic creature (4 × 8x8 = 128 bytes)
; VRAM tiles 2,3 (top) + 18,19 (bottom)
; Body shape: pointed head, wide torso, narrow legs
; Color 15 for outline/fill (palette-colored per monster type)
; ----------------------------------------------------------------------------

MonsterSprTiles:

; Tile 2 (top-left): head + left torso
;   Row 0: ..XXXX.. = $3C
;   Row 1: .XXXXXX. = $7E
;   Row 2: .XXXXXX. = $7E
;   Row 3: .XXXXXX. = $7E
;   Row 4: XXXXXXXX = $FF
;   Row 5: XXXXXXXX = $FF
;   Row 6: XXXXXXXX = $FF
;   Row 7: XXXXXXXX = $FF
.byte $3C,$3C, $7E,$7E, $7E,$7E, $7E,$7E, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF
.byte $3C,$3C, $7E,$7E, $7E,$7E, $7E,$7E, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF

; Tile 3 (top-right): head + right torso
.byte $3C,$3C, $7E,$7E, $7E,$7E, $7E,$7E, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF
.byte $3C,$3C, $7E,$7E, $7E,$7E, $7E,$7E, $FF,$FF, $FF,$FF, $FF,$FF, $FF,$FF

; Tile 18 (bottom-left): lower torso + left leg
;   Row 0: XXXXXXXX = $FF
;   Row 1: XXXXXXXX = $FF
;   Row 2: .XXXXXX. = $7E
;   Row 3: .XXXXXX. = $7E
;   Row 4: ..XXXX.. = $3C
;   Row 5: ..XX.XX. = $36
;   Row 6: ..XX..XX = $33
;   Row 7: ..XX..XX = $33
.byte $FF,$FF, $FF,$FF, $7E,$7E, $7E,$7E, $3C,$3C, $36,$36, $33,$33, $33,$33
.byte $FF,$FF, $FF,$FF, $7E,$7E, $7E,$7E, $3C,$3C, $36,$36, $33,$33, $33,$33

; Tile 19 (bottom-right): lower torso + right leg
.byte $FF,$FF, $FF,$FF, $7E,$7E, $7E,$7E, $3C,$3C, $6C,$6C, $CC,$CC, $CC,$CC
.byte $FF,$FF, $FF,$FF, $7E,$7E, $7E,$7E, $3C,$3C, $6C,$6C, $CC,$CC, $CC,$CC

MONSTER_SPR_SIZE = * - MonsterSprTiles ; 128 bytes

; ----------------------------------------------------------------------------
; Monster OBJ palettes — 4 palettes × 32 bytes = 128 bytes
; Uploaded to CGRAM $80-$FF during dungeon
; Pal 0: White (skeleton, mimic)
; Pal 1: Red (orc, daemon, balrog)
; Pal 2: Green (rat, viper, carrion)
; Pal 3: Brown (thief, gremlin)
; ----------------------------------------------------------------------------

MonsterObjPalettes:
    ; OBJ Palette 0: White
    .word $0000             ; 0: transparent
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $7FFF             ; 15: White
    ; OBJ Palette 1: Red
    .word $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $001F             ; 15: Red
    ; OBJ Palette 2: Green
    .word $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $03E0             ; 15: Green
    ; OBJ Palette 3: Brown
    .word $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0000, $0000, $0000, $0000, $0000, $0000, $0000
    .word $0193             ; 15: Brown
