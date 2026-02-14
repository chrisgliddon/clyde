---
title: "Super Mario RPG (SNES)"
description: "Complete disassembly — SA-1 HiROM 4MB RPG with co-processor, largest SNES disassembly available"
weight: 8
---

## Overview

Full disassembly of Super Mario RPG: Legend of the Seven Stars by Yoshifanatic using asar assembler. Nintendo/Square, SA-1 HiROM layout, 4MB ROM with SA-1 co-processor. 247K lines of disassembled routines — the largest SNES disassembly available. Includes a 3.2K-line SPC700 sound engine and complete BWRAM mapping.

**Value: 7/10** — SA-1 co-processor patterns are advanced/niche for us, but the multi-bank RPG organization, BWRAM usage, and sheer scale provide invaluable reference for large-project planning.

## SNES Features Demonstrated

- SA-1 co-processor with dual-CPU architecture
- HiROM layout at 4MB (maximum standard SNES ROM size)
- BWRAM (battery-backed work RAM) mapping for sprite graphics buffering
- Multi-bank code organization across 64+ banks
- Debug function infrastructure (left in from development)
- SPC700 sound engine (3.2K lines)
- Complex RPG battle system, world map, and event scripting

## Key Files

| File | What to Study |
|------|---------------|
| `SMRPG/Routine_Macros_SMRPG.asm` | 247K lines — complete RPG engine |
| `SMRPG/RAM_Map_SMRPG.asm` | Main RAM allocation and game state |
| `SMRPG/BWRAM_Map_SMRPG.asm` | SA-1 battery-backed RAM — sprite graphics buffer, extended data |
| `SMRPG/Misc_Defines_SMRPG.asm` | Game constants, item/enemy/spell IDs |
| `SMRPG/Notes.txt` | Developer notes on disassembly process |
| `SMRPG/SPC700/Engine.asm` | 3.2K-line sound engine |
| `SMRPG/RomMap/` | Bank-by-bank ROM layout |
| `SMRPG/UnsortedData/` | Data not yet categorized in disassembly |

## Lessons for Clyde

1. **SA-1 co-processor** — The SA-1 is essentially a second 65816 CPU running at 10.74 MHz (3x main CPU). SMRPG uses it for heavy computation (math, decompression, AI). Understanding SA-1 memory mapping (BWRAM at $6000-$7FFF in banks $00-$3F) is essential if we ever target SA-1 cartridges.
2. **Multi-bank RPG at scale** — A 4MB RPG organized across 64+ banks. Shows how to structure a large game: battle engine in one bank set, world map in another, event scripts in another. Planning for bank boundaries prevents painful refactoring later.
3. **BWRAM usage** — SA-1's 256KB battery-backed RAM used as sprite graphics buffer and extended workspace. Even without SA-1, the pattern of using extra RAM for double-buffering is applicable.
4. **Debug infrastructure** — Commercial game with debug functions still in ROM. Shows that professional teams built debugging tools into their engines. We should do the same from day one.
5. **Comparison with Earthbound** — Both are Square/Nintendo RPGs but architecturally different (HiROM vs SA-1 HiROM, 3MB vs 4MB). Comparing their approaches to similar problems (battle systems, NPC scripting) reveals trade-offs.
