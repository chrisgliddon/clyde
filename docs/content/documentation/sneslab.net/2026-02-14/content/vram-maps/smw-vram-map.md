---
title: "SMW VRAM Map"
reference_url: https://sneslab.net/wiki/SMW_VRAM_Map
categories:
  - "VRAM_Maps"
downloaded_at: 2026-02-14T16:26:35-08:00
cleaned_at: 2026-02-14T17:55:21-08:00
---

This is the location and allocation of graphics and tilemap resources used by Super Mario World on the VRAM, depending on the game context.

## Levels

Used by Lunar Magic 1.70 and newer. The format was introduced by smkdan for allowing two more graphics slots and by reducing the L1/L2 tilemap to 512x256.

Resource VRAM Address Specifications Layer 1/2 (FG1) $0000 - $07FF 4bpp Layer 1/2 (FG2) $0800 - $0FFF 4bpp Layer 1/2 (BG1) $1000 - $17FF 4bpp Layer 1/2 (FG3) $1800 - $1FFF 4bpp Layer 1/2 (BG2) $2000 - $27FF 4bpp Layer 1/2 (BG3) $2800 - $2FFF 4bpp Layer 1 Tilemap $3000 - $37FF 512x256 Layer 2 Tilemap $3800 - $3FFF 512x256 Layer 3 (LG1/GFX 28) $4000 - $43FF 2bpp Layer 3 (LG2/GFX 29) $4400 - $47FF 2bpp Layer 3 (LG3/GFX 2A) $4800 - $4BFF 2bpp Layer 3 (LG4/GFX 2B) $4C00 - $4FFF 2bpp Layer 3 Tilemap (LT3) $5000 - $5FFF 512x512 Sprites (SP1) $6000 - $67FF 4bpp Sprites (SP2) $6800 - $6FFF 4bpp Sprites (SP3) $7000 - $77FF 4bpp Sprites (SP4) $7800 - $7FFF 4bpp

## Overworld, Credits and Original Levels

Standard format used by Super Mario World. The format was used on levels without smkdan's VRAM patch.

Resource VRAM Address Specifications Layer 1/2 (FG1/FG1) $0000 - $07FF 4bpp Layer 1/2 (FG2/FG2) $0800 - $0FFF 4bpp Layer 1/2 (FG3/BG1) $1000 - $17FF 4bpp Layer 1/2 (FG4/FG3) $1800 - $1FFF 4bpp Layer 1 Tilemap $2000 - $2FFF 512x512 Layer 2 Tilemap $3000 - $3FFF 512x512 Layer 3 (LG1/GFX 28) $4000 - $43FF 2bpp Layer 3 (LG2/GFX 29) $4400 - $47FF 2bpp Layer 3 (LG3/GFX 2A) $4800 - $4BFF 2bpp Layer 3 (LG4/GFX 2B) $4C00 - $4FFF 2bpp Layer 3 Tilemap (LT3) $5000 - $5FFF 512x512 Sprites (SP1) $6000 - $67FF 4bpp Sprites (SP2) $6800 - $6FFF 4bpp Sprites (SP3) $7000 - $77FF 4bpp Sprites (SP4) $7800 - $7FFF 4bpp

## Boss Battles

Used on Mode 7 battles.

Resource VRAM Address Specifications Layer 1 (GFX/Tile) $0000 - $3FFF 1024x1024 tilemap interleaved with 128x128 8bpp linear tiled GFX. Layer 3 (GFX 28) $4000 - $43FF 2bpp Layer 3 (GFX 29) $4400 - $47FF 2bpp Layer 3 (GFX 2A) $4800 - $4BFF 2bpp Layer 3 (GFX 2B) $4C00 - $4FFF 2bpp Layer 3 Tilemap $5000 - $5FFF 512x512 Sprites (SP1) $6000 - $67FF 4bpp Sprites (SP2) $6800 - $6FFF 4bpp Sprites (SP3) $7000 - $77FF 4bpp Sprites (SP4) $7800 - $7FFF 4bpp
