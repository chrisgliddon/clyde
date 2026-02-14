---
title: "Gargoyles Quest (SNES)"
description: "Complete SNES platformer — sprites, DMA, Mode 7, scrolling, object system"
weight: 1
---

## Overview

Complete SNES platformer source code from a commercial team. Uses the **asm658** assembler with `.658` source files. One of the most complete SNES game sources available — covers nearly every PPU/DMA feature the hardware offers.

**Value: 9/10** — Directly applicable patterns for sprites, DMA, Mode 7, and entity management.

## SNES Features Demonstrated

- Mode 7 rotation/scaling
- DMA transfers (heap queue pattern)
- Multi-layer background scrolling
- Sprite/object lifecycle management
- Full PPU register configuration
- RAM memory layout conventions

## Key Files

| File | What to Study |
|------|---------------|
| `MACROS.658` | CPU mode switching macros (8/16-bit), common patterns |
| `GG_DMA.658` | DMA transfer queue — heap-based batching |
| `GG_MODE7.658` | Mode 7 setup and matrix transforms |
| `GG_SCRL.658` | Multi-layer parallax scrolling |
| `GG_OBJ.658` | Entity/object system — spawn, update, destroy lifecycle |
| `PPU_REG.658` | Complete PPU register definitions and constants |
| `GG_RAM.658` | RAM allocation map — how a real game lays out 128KB |

## Lessons for Clyde

1. **Macro patterns** — Mode switching macros (`rep #$30`, `sep #$20`) wrapped in readable names. Adopt this convention.
2. **DMA queue** — Don't DMA inline. Queue transfers during game logic, flush during VBlank. Critical for avoiding tearing.
3. **Object system** — Entity table with fixed-size slots, state machine per object. Good model for NPCs/enemies.
4. **Scrolling** — Per-layer scroll registers updated from camera position. Shows the standard approach for overworld maps.
