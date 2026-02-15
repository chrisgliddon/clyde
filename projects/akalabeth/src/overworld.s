; overworld.s — Akalabeth overworld system
; 20x20 tile grid, player movement, BG1 rendering

.include "macros.s"

.export OverworldInit, OverworldUpdate, OverworldRender
.export TilemapBuffer, OverworldMap
.exportzp PlayerX, PlayerY, MapDirty

.importzp JoyPress, GameState, ShopCursor
.importzp PlayerFood, PlayerHP
.importzp ChargenSeed
.import JOY_UP, JOY_DOWN, JOY_LEFT, JOY_RIGHT
.import DungeonInit, PrngByte, SeedPrng, SetAmbience
.import SpriteSetEntry, SpriteClearAll
.importzp SprX, SprY, SprTile, SprAttr, SprSize

; ============================================================================
; Constants
; ============================================================================

MAP_W           = 20
MAP_H           = 20
MAP_SIZE        = MAP_W * MAP_H     ; 400 bytes

TILE_GRASS      = $00
TILE_MOUNTAIN   = $01
TILE_WATER      = $02
TILE_TOWN       = $03
TILE_CASTLE     = $04
TILE_DUNGEON    = $05
TILE_FOREST     = $06
TILE_PLAYER     = $07

RDMPYL          = $4216     ; Division remainder

STATE_OVERWORLD = $01
STATE_DUNGEON   = $02
STATE_SHOP      = $04
STATE_CASTLE    = $05

; ============================================================================
; Zero page
; ============================================================================

.segment "ZEROPAGE"
PlayerX:        .res 1
PlayerY:        .res 1
MapDirty:       .res 1
OW_TempA:       .res 1      ; Candidate Y / general temp
OW_TempB:       .res 1      ; Candidate X / general temp
OW_Offset:      .res 2      ; 16-bit calculated offset
OW_GenRow:      .res 1      ; Current row during generation
OW_GenCol:      .res 1      ; Current col during generation

; ============================================================================
; BSS
; ============================================================================

.segment "BSS"
OverworldMap:   .res MAP_SIZE   ; 400 bytes
TilemapBuffer:  .res 2048       ; 32x32 tilemap (16-bit entries)

; ============================================================================
; Code
; ============================================================================

.segment "CODE"

; ============================================================================
; CalcMapOffset — compute 16-bit map offset from Y-pos in A, X-pos in OW_TempB
; Result in X (16-bit). Clobbers A. Assumes 8-bit A on entry.
; ============================================================================
.proc CalcMapOffset
    ; A (8-bit) = Y position. OW_TempB = X position.
    ; Returns: X (16-bit) = Y*20 + X.  Clobbers A, OW_Offset.
    ; Assumes 8-bit A, 16-bit XY on entry. Returns same.
    stz OW_Offset+1
    sta OW_Offset
    SET_A16
    lda OW_Offset
    asl
    asl
    sta OW_Offset            ; Y*4
    asl
    asl                     ; Y*16
    clc
    adc OW_Offset            ; Y*20
    sta OW_Offset
    SET_A8
    lda OW_TempB
    SET_A16
    and #$00FF
    clc
    adc OW_Offset
    tax
    SET_A8
    rts
.endproc

; ============================================================================
; GetInteriorCoord — random interior map position (row 1-18, col 1-18)
; Returns: OW_GenRow, OW_GenCol set, X = map offset (16-bit)
; Assumes: A8. Returns: A8, XY16.
; ============================================================================
.proc GetInteriorCoord
    jsr PrngByte            ; A = random 0-255 (X/Y untouched)
    sta WRDIVL
    stz WRDIVH
    lda #18
    sta WRDIVB              ; triggers division, wait 16 cycles
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lda RDMPYL              ; remainder = 0-17
    inc a                   ; 1-18
    sta OW_GenRow

    jsr PrngByte
    sta WRDIVL
    stz WRDIVH
    lda #18
    sta WRDIVB
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lda RDMPYL
    inc a
    sta OW_GenCol

    ; Compute map offset
    sta OW_TempB            ; col
    lda OW_GenRow           ; row
    SET_XY16
    jsr CalcMapOffset       ; X = row*20 + col (returns A8, XY16)
    rts
.endproc

; ============================================================================
; OverworldInit — procedural map generation from ChargenSeed
; Same seed = same map. Distribution matches original Apple II algorithm.
; ============================================================================
.proc OverworldInit
    ; Re-seed PRNG from ChargenSeed for reproducible maps
    SET_A16
    lda ChargenSeed
    jsr SeedPrng
    .a8                     ; SeedPrng returns A8; resync assembler

    ; === Fill map with grass ===
    SET_XY16
    ldx #$0000
    lda #TILE_GRASS
@fill:
    sta OverworldMap,x
    inx
    cpx #MAP_SIZE
    bne @fill

    ; === Border mountains: top and bottom rows ===
    ldx #$0000
@border_tb:
    lda #TILE_MOUNTAIN
    sta OverworldMap,x
    sta OverworldMap + (MAP_H-1)*MAP_W,x
    inx
    cpx #MAP_W
    bne @border_tb

    ; === Border mountains: left and right columns ===
    ldx #$0000
@border_lr:
    lda #TILE_MOUNTAIN
    sta OverworldMap,x
    sta OverworldMap + (MAP_W - 1),x
    SET_A16
    txa
    clc
    adc #MAP_W
    tax
    SET_A8
    cpx #MAP_SIZE
    bcc @border_lr

    ; === Generate interior terrain (rows 1-18, cols 1-18) ===
    ; Distribution: grass 73%, mountain 12%, forest 8%, castle 2.5%, dungeon 1.2%
    lda #1
    sta OW_GenRow
@gen_row:
    lda #1
    sta OW_TempB
    lda OW_GenRow
    SET_XY16
    jsr CalcMapOffset       ; X = row*20+1 (returns A8, XY16)
    lda #1
    sta OW_GenCol
@gen_col:
    jsr PrngByte            ; A = random 0-255, X/Y untouched
    cmp #188
    bcs @not_grass
    lda #TILE_GRASS
    bra @write_tile
@not_grass:
    cmp #219
    bcs @not_mountain
    lda #TILE_MOUNTAIN
    bra @write_tile
@not_mountain:
    cmp #240
    bcs @not_forest
    lda #TILE_FOREST
    bra @write_tile
@not_forest:
    cmp #253
    bcs @is_dungeon
    ; Castle range (240-252): 50% coin flip → castle or grass
    jsr PrngByte            ; X/Y still untouched
    cmp #128
    bcs @is_castle
    lda #TILE_GRASS
    bra @write_tile
@is_castle:
    lda #TILE_CASTLE
    bra @write_tile
@is_dungeon:
    lda #TILE_DUNGEON
@write_tile:
    sta OverworldMap,x
    inx
    inc OW_GenCol
    lda OW_GenCol
    cmp #19                 ; cols 1 through 18
    bcc @gen_col

    inc OW_GenRow
    lda OW_GenRow
    cmp #19                 ; rows 1 through 18
    bcc @gen_row

    ; === Force one town at random interior position ===
    jsr GetInteriorCoord
    lda #TILE_TOWN
    sta OverworldMap,x

    ; === Force one castle at random interior position ===
@force_castle:
    jsr GetInteriorCoord
    lda OverworldMap,x
    cmp #TILE_TOWN
    beq @force_castle       ; retry if overlapping town
    lda #TILE_CASTLE
    sta OverworldMap,x
    ; Save castle position for player placement
    lda OW_GenRow
    pha
    lda OW_GenCol
    pha

    ; === Ensure at least one dungeon ===
    SET_XY16
    ldx #$0000
@scan_dung:
    lda OverworldMap,x
    cmp #TILE_DUNGEON
    beq @has_dungeon
    inx
    cpx #MAP_SIZE
    bne @scan_dung
    ; No dungeon found — force-place one
@force_dungeon:
    jsr GetInteriorCoord
    lda OverworldMap,x
    cmp #TILE_TOWN
    beq @force_dungeon
    cmp #TILE_CASTLE
    beq @force_dungeon
    lda #TILE_DUNGEON
    sta OverworldMap,x

@has_dungeon:
    ; === Place player adjacent to forced castle ===
    SET_AXY8
    pla                     ; castle X (last pushed)
    sta OW_TempB
    pla                     ; castle Y
    sta PlayerY
    lda OW_TempB
    cmp #1
    beq @castle_left
    dec a
    sta PlayerX
    bra @init_done
@castle_left:
    inc a
    sta PlayerX
@init_done:
    lda #$01
    sta MapDirty
    rts
.endproc

; ============================================================================
; OverworldUpdate — handle D-pad movement, collision, food
; ============================================================================
.proc OverworldUpdate
    SET_AXY8
    SET_XY16

    ; 16-bit joypad test
    SET_A16
    lda JoyPress
    bit #JOY_UP
    bne @move_up
    bit #JOY_DOWN
    bne @move_down
    bit #JOY_LEFT
    bne @move_left
    bit #JOY_RIGHT
    bne @move_right
    SET_A8
    rts

@move_up:
    SET_A8
    lda PlayerY
    beq @ret
    dec a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_down:
    SET_A8
    lda PlayerY
    cmp #MAP_H - 1
    beq @ret
    inc a
    sta OW_TempA
    lda PlayerX
    sta OW_TempB
    jmp @try_move

@move_left:
    SET_A8
    lda PlayerX
    beq @ret
    lda PlayerY
    sta OW_TempA
    lda PlayerX
    dec a
    sta OW_TempB
    jmp @try_move

@move_right:
    SET_A8
    lda PlayerX
    cmp #MAP_W - 1
    beq @ret
    lda PlayerY
    sta OW_TempA
    lda PlayerX
    inc a
    sta OW_TempB
    jmp @try_move

@ret:
    rts

@try_move:
    ; Calculate map offset (16-bit X) for candidate position
    lda OW_TempA            ; Y position
    jsr CalcMapOffset       ; X = Y*20 + OW_TempB

    lda OverworldMap,x      ; Tile at candidate pos

    cmp #TILE_MOUNTAIN
    beq @blocked
    cmp #TILE_WATER
    beq @blocked

    ; Accept move
    lda OW_TempA
    sta PlayerY
    lda OW_TempB
    sta PlayerX
    lda #$01
    sta MapDirty

    ; Consume food
    SET_A16
    lda PlayerFood
    beq @no_food
    dec a
    sta PlayerFood
    SET_A8
    jmp @check_tile

@no_food:
    lda PlayerHP
    beq @starve
    dec a
    sta PlayerHP
@starve:
    SET_A8

@check_tile:
    ; Get tile at new position
    lda OW_TempA
    jsr CalcMapOffset

    lda OverworldMap,x
    cmp #TILE_DUNGEON
    beq @enter_dungeon
    cmp #TILE_CASTLE
    beq @enter_castle
    cmp #TILE_TOWN
    beq @enter_town
    rts

@enter_dungeon:
    jsr SpriteClearAll          ; hide player sprite
    lda #$02
    jsr SetAmbience             ; dungeon ambient drone
    lda #STATE_DUNGEON
    sta GameState
    jsr DungeonInit
    rts
@enter_castle:
    lda #STATE_CASTLE
    sta GameState
    rts
@enter_town:
    stz ShopCursor
    lda #STATE_SHOP
    sta GameState
    rts

@blocked:
    rts
.endproc

; ============================================================================
; OverworldRender — 3x3 local view on BG1 (matches original game)
; Shows tiles surrounding player in a 3x3 grid of 8x8-tile cells.
; Player crosshair stamped at center cell.
; ============================================================================
.proc OverworldRender
    ; --- Clear tilemap to black (tile 0) ---
    SET_AXY16
    ldx #$0000
    lda #$0000
@clear:
    sta TilemapBuffer,x
    inx
    inx
    cpx #2048
    bne @clear

    ; --- Draw 9 cells ---
    SET_A8                  ; A=8-bit, XY still 16-bit
    lda #$00
    sta OW_TempA            ; cell counter (0-8)

@cell_loop:
    SET_XY8
    ldy OW_TempA            ; Y = cell index

    ; mapY = PlayerY + CellDY[cell]
    lda CellDY,y
    clc
    adc PlayerY
    cmp #MAP_H
    bcs @oob
    pha                     ; push mapY (8-bit)

    ; mapX = PlayerX + CellDX[cell]
    lda CellDX,y
    clc
    adc PlayerX
    cmp #MAP_W
    bcs @oob_pop

    ; --- In bounds: compute map offset = mapY*20 + mapX ---
    sta OW_TempB            ; mapX
    pla                     ; A = mapY
    stz OW_Offset+1
    sta OW_Offset
    SET_A16
    lda OW_Offset
    asl
    asl
    sta OW_Offset           ; mapY * 4
    asl
    asl                     ; mapY * 16
    clc
    adc OW_Offset           ; mapY * 20
    sta OW_Offset
    SET_A8
    lda OW_TempB
    SET_A16
    and #$00FF
    clc
    adc OW_Offset           ; mapY*20 + mapX
    SET_XY16
    tax
    SET_A8
    lda OverworldMap,x
    jmp @got_tile

@oob_pop:
    pla                     ; discard mapY
@oob:
    lda #TILE_MOUNTAIN      ; border = mountain

@got_tile:
    ; A = tile type
    pha                     ; save tile

    ; --- Get tilemap offset from CellOfs word table ---
    lda OW_TempA            ; cell index
    asl                     ; * 2 for word index
    SET_XY16
    tay                     ; Y = cell*2 (zero-extended to 16-bit)
    SET_A16
    lda CellOfs,y           ; 16-bit tilemap byte offset
    tax                     ; X = tilemap offset
    SET_A8

    pla                     ; A = tile type

    ; --- Look up palette attribute for this tile ---
    phx                     ; Save tilemap offset (16-bit)
    SET_XY8
    tax                     ; X = tile type (8-bit index)
    lda TilePalette,x       ; A = palette attribute byte
    sta OW_TempB            ; Save attribute in ZP
    txa                     ; A = tile type again
    SET_XY16
    plx                     ; Restore tilemap offset (16-bit)

    ; --- Write 2x2 tile block with palette attribute ---
    sta TilemapBuffer,x
    lda OW_TempB
    sta TilemapBuffer+1,x
    lda TilemapBuffer,x     ; Re-read tile type from buffer
    sta TilemapBuffer+2,x
    lda OW_TempB
    sta TilemapBuffer+3,x
    lda TilemapBuffer,x
    sta TilemapBuffer+64,x
    lda OW_TempB
    sta TilemapBuffer+65,x
    lda TilemapBuffer,x
    sta TilemapBuffer+66,x
    lda OW_TempB
    sta TilemapBuffer+67,x

    ; --- Next cell ---
    inc OW_TempA
    lda OW_TempA
    cmp #$09
    bcs :+
    jmp @cell_loop
:

    ; --- Player sprite at screen center (16x16, red, OBJ palette 0) ---
    lda #120                ; X pixel = center cell col 15 * 8
    sta SprX
    lda #88                 ; Y pixel = center cell row 11 * 8
    sta SprY
    stz SprTile             ; tile 0 in sprite name table
    lda #$20                ; priority 2 (above BG1), palette 0, no flip
    sta SprAttr
    lda #$01                ; large size (16x16)
    sta SprSize
    lda #$00                ; sprite index 0
    jsr SpriteSetEntry

    rts
.endproc

; ============================================================================
; RODATA
; ============================================================================

.segment "RODATA"

; Tile palette attribute table — BG1 palette index shifted into attr bits 10-12
; Index by overworld tile type (0-7)
; Palette: 0=white, 1=green, 2=blue, 3=brown, 4=yellow, 5=red
;            grass  mount  water  town   castle dungeon forest player
TilePalette: .byte $04,   $0C,   $08,   $10,   $10,   $14,   $04,   $14

; 3x3 cell layout: dy/dx offsets from player position
CellDY: .byte $FF, $FF, $FF, $00, $00, $00, $01, $01, $01
CellDX: .byte $FF, $00, $01, $FF, $00, $01, $FF, $00, $01

; Tilemap byte offsets for center of each 8x8-tile cell
; Cell grid starts at tilemap (row=0, col=4), each cell = 8x8 tiles
; Center of cell (cy,cx) at row=cy*8+3, col=4+cx*8+3 = cx*8+7
; Byte offset = (row*32 + col) * 2
CellOfs: .word 206, 222, 238, 718, 734, 750, 1230, 1246, 1262
