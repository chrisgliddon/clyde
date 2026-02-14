---
title: "BS Zelda no Densetsu (SNES)"
description: "Complete disassembly — Satellaview Zelda with PPU shadow registers, sprite system, joypad patterns"
weight: 7
---

## Overview

Full disassembly of BS Zelda no Densetsu (BS The Legend of Zelda) by Yoshifanatic using asar assembler. Nintendo, Satellaview format, 113K lines of disassembled routines. Includes a 3.2K-line SPC700 sound engine. The largest Zelda engine disassembly available — based on the original Zelda remade for Satellaview broadcast.

**Value: 9/10** — PPU shadow register pattern, sprite entity system, and joypad handling are immediately applicable. The most architecturally instructive disassembly in our collection.

## SNES Features Demonstrated

- Satellaview ROM layout and memory mapping
- PPU shadow registers in RAM ($1F00+ mirrors of $2100+)
- Sprite table entity system with state machines
- Joypad held/pressed/disabled pattern (three-state input)
- 16-byte linear feedback shift register RNG
- OAM buffer management with priority sorting
- SPC700 sound engine (3.2K lines)

## Key Files

| File | What to Study |
|------|---------------|
| `Routine_Macros_BSZ1.asm` | 113K lines — complete Zelda engine |
| `RAM_Map_BSZ1.asm` | PPU shadow registers at $1F00+, sprite tables, game state |
| `Misc_Defines_BSZ1.asm` | Item IDs, enemy types, tile constants |
| `SRAM_Map_BSZ1.asm` | Save data layout |
| `SPC700/SPC700_Engine_BSZ1.asm` | 3.2K-line sound engine |
| `Map16/` | Tilemap data for overworld and dungeons |
| `GarbageData/` | Leftover debug/unused data from development |

## Lessons for Clyde

1. **PPU shadow registers** — BS Zelda maintains a RAM mirror of every PPU register ($1F00+ = shadow of $2100+). Game logic writes to RAM shadows; NMI handler copies shadows to real PPU registers via DMA. This prevents mid-frame PPU corruption and is the standard pattern used by most commercial SNES games. **Adopt this immediately.**
2. **Sprite entity system** — Entities stored in parallel arrays (X pos, Y pos, type, state, timer). State machine per entity type. Clean pattern for NPCs, enemies, projectiles.
3. **Joypad three-state input** — Tracks held (current frame), pressed (edge-triggered), and disabled (locked) states separately. Prevents accidental double-inputs. Better than our current simple read.
4. **16-byte RNG** — Linear feedback shift register using 16 bytes of state. Fast, good distribution, deterministic. Drop-in replacement for any RNG we need.
5. **Satellaview format** — Understanding the broadcast ROM format helps with understanding non-standard memory maps and the flexibility of the SNES address bus.
