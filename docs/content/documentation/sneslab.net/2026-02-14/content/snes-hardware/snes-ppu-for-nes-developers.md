---
title: "SNES PPU for NES developers"
reference_url: https://sneslab.net/wiki/SNES_PPU_for_NES_developers
categories:
  - "SNES_Hardware"
  - "Video"
downloaded_at: 2026-02-14T16:27:31-08:00
cleaned_at: 2026-02-14T17:54:36-08:00
---

The SNES PPU and NES PPU use very similar concepts for displaying graphics. This article will summarize some important differences and similarities, and lay out some basics before you learn about things more in-depth.

## VRAM

Video RAM is 64KB and contained within the console. Additional video memory cannot be added via cartridge. VRAM contains the tilemaps used for backgrounds as well as the graphics data for background tiles and sprite tiles. You can decide how much VRAM to dedicate to each use, and there are registers that set the base address for different things.

Like the NES, VRAM is accessed by setting an address via registers, and then writing the data you want to store to other registers, with the address automatically increasing after each write. Unlike the NES, the VRAM address is spread across two registers, and VRAM is 16-bit, so the VRAM data is also spread across two registers (for accessing the low and high byte at each VRAM address). This means that you're writing addresses between $0000-$7FFF instead of $0000-$FFFF like you might expect.

## Palettes/CGRAM

The palette consists of 256 RGB colors, with 5 bits used for the red, green and blue values of each color. You can choose to think of it as 8 background palettes and 8 sprite palettes, each with 15 colors plus a "transparency" color, though different Background modes can change the specifics.

VRAM and CGRAM are accessed with different registers. Colors in the palette are RGB values (with 5 bits per color channel).

## DMA

DMA is much more flexible than it is on the NES. You can configure the SNES's DMA unit to write to *any* PPU register, as well as to other registers in the same address range as them. As a result, DMA can transfer data directly from the cartridge (or CPU RAM) into VRAM, CGRAM, OAM, or into CPU RAM.

DMA can work in reverse (copy from VRAM into CPU RAM) as well as do fills. It cannot, however, copy from one section of CPU RAM to another. For that, you can use the new MVN or MVP instructions.

### HDMA

HDMA is a special case of DMA, in which a small amount of data is transferred at the end of a scanline, during HBlank. This makes raster effects much easier, as they no longer require precise timing. Instead, you choose a register and provide a table that lists both a series of values to write into that register, as well a series of scanline counts to wait before the next value is written.

There is still [an interrupt](/mw/index.php?title=H%2FV_IRQ&action=edit&redlink=1 "H/V IRQ (page does not exist)") that allows you to do things the old way, and you can specify a horizontal coordinate to trigger the interrupt at too.

## Background modes

There are a variety of Background modes that change how the background layers work. The most common (mode 1) provides two layers with 16 colors per tile, and a third layer with 4 colors per tile. The third layer may be given priority over everything else, which makes it useful as a HUD or status bar.

## Tilemaps/Nametables

SNES tilemaps consist of a series of 16-bit values, containing the palette, priority bit, horizontal/vertical flips, and a tile number. There is no separate attribute table, and a tilemap can access 2048 different tiles instead of only 256.

Tilemaps are 32x32 (instead of the NES's 32x30) and a background layer can decide to have a single tilemap, arrange two horizontally, arrange two vertically, or have a square of four different tilemaps. A background layer can also choose to have 16x16 tiles instead of 8x8.

## Sprites/OAM

Sprite limits are MUCH higher. There are 128 sprites, and 32 can be on the same scanline before sprite start to disappear. There is additionally a limit of 34 sprite tiles per scanline. Each sprite can be one of two different sizes, and you can choose two different sprite sizes to use, for example 8x8 and 16x16.
