---
title: "Sprite/OAM Management"
weight: 70
---

## OAM Structure

Object Attribute Memory (OAM) defines up to 128 sprites. Total size: **544 bytes** (512 main + 32 auxiliary).

### Main Table (512 bytes = 128 entries × 4 bytes)

Each entry:

```
Byte 0: X position (bits 7-0)
Byte 1: Y position (0-239 visible, wraps at 256)
Byte 2: Tile number (index into sprite character data)
Byte 3: Attributes
         v h o o p p p c
         | | | | | | | +-- Name table (tile page: 0 or 1)
         | | | | +-+-+---- Palette (0-7, selects from CGRAM $80-$FF)
         | | +-+---------- Priority (0-3, relative to BG layers)
         | +-------------- Horizontal flip
         +----------------- Vertical flip
```

### Auxiliary Table (32 bytes)

Packs 2 bits per sprite (128 sprites × 2 bits = 256 bits = 32 bytes). Each byte covers 4 sprites:

```
Byte layout: ddccbbaa
             ||||||++-- Sprite N+0: size(1) X-high(1)
             ||||++---- Sprite N+1: size(1) X-high(1)
             ||++------ Sprite N+2: size(1) X-high(1)
             ++-------- Sprite N+3: size(1) X-high(1)

Per sprite (2 bits):
  Bit 0: X position bit 8 (allows X range 0-511; screen is 256 wide)
  Bit 1: Size select (0 = small, 1 = large)
```

## Sprite Sizes

OBSEL register (`$2101`) bits 7-5 select which size pair is active:

| OBSEL[7:5] | Small | Large |
|------------|-------|-------|
| `000` | 8×8 | 16×16 |
| `001` | 8×8 | 32×32 |
| `010` | 8×8 | 64×64 |
| `011` | 16×16 | 32×32 |
| `100` | 16×16 | 64×64 |
| `101` | 32×32 | 64×64 |
| `110` | 16×32 | 32×64 |
| `111` | 16×32 | 32×32 |

Only two sizes at a time. The auxiliary table's size bit selects which one each sprite uses.

### OBSEL Register ($2101)

```
sssnnbbb
|||||||+-- Name base address (bits 0-2): character data base in VRAM
|||+++----- (bits 3-4): gap between name tables (page 0 and page 1)
+++-------- (bits 5-7): size combination select (table above)
```

## Sprite Graphics in VRAM

Sprites always use **4bpp** (4 bits per pixel), regardless of BG mode. Each 8×8 tile = 32 bytes.

Character data base address from OBSEL bits 0-2:
- Base = `OBSEL[2:0] × $4000` (word address in VRAM)

Name table 1 offset from OBSEL bits 3-4:
- Page 1 start = Base + `(OBSEL[4:3] + 1) × $2000`

The tile number in OAM byte 2, combined with the name table bit (byte 3 bit 0), indexes into this VRAM region.

## Sprite Palettes in CGRAM

Sprites use CGRAM colors **128-255** (the upper half). The 3-bit palette field in OAM selects which 16-color group:

| Palette | CGRAM Range |
|---------|-------------|
| 0 | $80-$8F (colors 128-143) |
| 1 | $90-$9F (colors 144-159) |
| ... | ... |
| 7 | $F0-$FF (colors 240-255) |

Color 0 of each palette is transparent.

## Priority System

Sprites have 4 priority levels (0-3). Priority interacts with BG layer priorities:

**Mode 1 priority order** (front to back):
1. BG3 tiles with priority=1 (if BG3 priority bit set in BGMODE)
2. Sprite priority 3
3. BG1 priority 1
4. BG2 priority 1
5. Sprite priority 2
6. BG1 priority 0
7. BG2 priority 0
8. Sprite priority 1
9. BG3 priority 1 (normal)
10. BG3 priority 0
11. Sprite priority 0
12. Backdrop

Within the same priority level, **lower OAM index wins** (sprite 0 is frontmost).

## Scanline Limits

| Limit | Name | Triggered By |
|-------|------|-------------|
| 32 sprites per scanline | Range overflow | Too many sprites with Y positions overlapping one scanline |
| 34 tiles (8×8) per scanline | Time overflow | Too many sprite tiles (a 16×16 sprite = 4 tiles) |

When exceeded, lower-priority sprites (higher OAM index) are dropped. The PPU sets status flags in `$213E` bits 6-7.

**Mitigation**: Rotate OAM start address each frame (`$2102`/`$2103`) to cycle which sprites get priority. This distributes flicker evenly.

## DMA Pattern for OAM Upload

Mode `$02` (1 register, 2 writes) to OAMDATA (`$2104`), 544 bytes total.

```asm
    SET_A8
    stz OAMADDL             ; Start at OAM address 0
    stz OAMADDH

    lda #$02                ; DMA mode: 1-reg, 2 writes
    sta DMAP0
    lda #$04                ; B-bus = OAMDATA ($2104)
    sta BBAD0
    lda #<OamBuffer         ; Source: RAM buffer
    sta A1T0L
    lda #>OamBuffer
    sta A1T0H
    lda #^OamBuffer
    sta A1B0
    lda #$20                ; Size: $0220 = 544 bytes
    sta DAS0L
    lda #$02
    sta DAS0H
    lda #$01                ; Enable channel 0
    sta MDMAEN
```

## OAM Buffer Layout in RAM

Typical approach: maintain a 544-byte buffer in low RAM, DMA the whole thing during VBlank.

```asm
.segment "BSS"
OamMain:    .res 512        ; 128 entries × 4 bytes
OamAux:     .res 32         ; Size/X-high bits
```

### Writing a Sprite Entry

```asm
    ; Write sprite N (N × 4 offset into OamMain)
    SET_A8
    lda #<xpos
    sta OamMain + (N * 4) + 0   ; X low
    lda #ypos
    sta OamMain + (N * 4) + 1   ; Y
    lda #tile
    sta OamMain + (N * 4) + 2   ; Tile number
    lda #attr                    ; vhoopppc
    sta OamMain + (N * 4) + 3   ; Attributes
```

### Setting Size/X-High Bits

Each byte covers 4 sprites. For sprite N:

```
Byte index  = N / 4
Bit offset  = (N % 4) * 2
Bit 0       = X position bit 8
Bit 1       = Size select (0=small, 1=large)
```

## Allocation Strategies

| Strategy | Pros | Cons | Use Case |
|----------|------|------|----------|
| **Static slots** | Simple, predictable | Wastes slots when not in use | Fixed-count objects (player, HUD) |
| **Ring buffer** | Dynamic allocation | Fragmentation possible | Particle effects, projectiles |
| **Priority-based** | Important sprites always visible | Complex sorting | RPG battles, dense scenes |

## Hiding Sprites

To hide a sprite, set its Y position to **224** or higher (off-screen below). Alternatively, set Y to **$F0** (240) which is safely below the visible area (0-223 visible on NTSC).

To hide all 128 sprites at init, DMA-clear OAM with zeros (our `lib/init.s` does this — Y=0 for all sprites places them at top, but with tile 0 and no graphics they're invisible).

## Practical Note

Akalabeth used no sprites — it's entirely BG-based (tile-only rendering). This guide is preparation for the Clyde RPG project which will need sprite management for characters, NPCs, projectiles, and effects.

## See Also

- [Sneslab: Sprite (hardware)]({{< ref "/documentation/sneslab.net/2026-02-14/content/video/sprite-hardware" >}}) — hardware reference
- [DMA Cookbook]({{< ref "dma-cookbook" >}}) — OAM DMA pattern
- `lib/macros.s:48-51` — OBSEL, OAMADDL, OAMADDH, OAMDATA constants
- `lib/init.s:145-160` — OAM clear during init
