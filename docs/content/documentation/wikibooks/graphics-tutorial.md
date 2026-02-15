---
title: "Super NES Programming/Graphics tutorial"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Graphics_tutorial
categories:
  - "Wikibooks_pages_with_to-do_lists"
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:16:42-08:00
---

This tutorial will cover how to map tiles to the SNES background.

In order to render background, program has to set few things for each background, remember to set this for every background you want to render:

- BG Mode (affects number of planes, bitdepth), set in register 0x2105
- Size of tile (8x8 or 16x16), set in register 0x2105
- Set background map
- Set background tileset

## Tile Map

The map is a 2 dimensional array (32x32, 64x32, 32x64 or 64x64) of tile indexes. The SNES goes through the array and for each index in the map renders a tile specified in the array. Since tiles can be either 8x8 or 16x16 pixels, we can end up with background image dimensions ranging from 256 to 1024 pixels (size\_of\_map * size\_of\_tile).

A member of an array is a two bytes long structure(two bytes long = 16 bits):

High byte Low byte

vhopppcc cccccccc

- c is the index of a tile in the tileset (tileset is specified per BG), SNES will get the address of a tile as (base\_tileset\_bits &lt;&lt; 13) + (8 * color\_depth * tile\_number)
- h: horizontal flip
- v: vertical flip
- p: palette number
- o: priority bit

Use registers $2107-$210A to set map for your background.

Structure of registers $2107-$210A

aaaaaass

a: address of the map in VRAM. Multiply the number by 2048 (or shift 11 bits) in order to get the byte location of the map.

s: size of the map

```
* 00=32x32 
* 01=64x32
* 10=32x64 
* 11=64x64
```

If the map has a dimension greater than 32 (e.g. 64x32), array doesn't have 64 tile indexes per row, instead it will store two 32x32 maps right after each other in VRAM. The first map (32x32 tiles = 2\*32\*32 bytes) will represent the left part of the map and the second one (same size as the first one) will represent the right side of the map.

## Tileset

Tile is a small 8x8 or 16x16 image that is used to construct larger images.

## Technical info

To employ the SNES's PPU, one must understand exactly how it processes graphic data.

### Bit Depths

- Mode 0: 4 colors, 2 bit per pixel(bpp)
- Mode 1: 8 colors, 3 bpp (you may see this in some tile editors but the SNES doesn't display 3bpp graphics. They have to be expanded to the 4bpp format before being used.)
- Mode 2: 16 colors, 4 bpp
- Mode 3: 128/256 colors, 8bpp (only in Mode 7)

### Tile format

The SNES uses an odd interleaved format for its tile data. Consider this "x" pattern with the palette

The tile data itself will consist of these bytes:

```
.db $00, $81, $81, $42, $C3, $24, $E7, $18, $E7, $18, $C3, $24, $81, $42, $00, $81
```

"How exactly does this correspond to that tile?" I hear you wonder.

Each row of pixels is represented by two bytes. Take the first row ($00, $81). It consists of the colors 2,0,0,0,0,0,0,2. In binary form:

```
0 0 0 0 0 0 0 0 
1 0 0 0 0 0 0 1 
```

Each of the bits in byte 0 are equivalent to **bit** 0 in it's corresponding pixel. Take the next row ($81, $42):

```
12000021        colors,
10000001	$81, 
01000010	$42,
```

You may hear people refer to **bitplanes**. Those mean sets of bytes corresponding to bit **?'**s of all the pixels, where ? is from 0 to the number of bits per pixel minus 1. Thus, in this case, bitplane 0 would refer to the odd bytes in the tile data($00,$81,$C3,etc.).

Does this make sense? I'm not so sure myself..

- [common console graphic formats](http://mrclick.zophar.net/TilEd/download/consolegfx.txt)

### Palette format

Colors for the SNES are 15 bits each, and stored in bgr format.

```
?bbbbbgg gggrrrrr
```

The color full green like this would be stored as:

```
%00000011, %11100000
```

In HEX:

```
$03, $E0
```

Palettes are simply arrays of colors. The palette shown above would be stored in the ROM as (one color being "$xx, $xx"):

```
.db $EE, $00, $10, $02, $4A, $01, $00, $00
```

### Tile maps
