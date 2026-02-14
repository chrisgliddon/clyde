---
title: "SimCity (SNES)"
description: "Complete disassembly — LoROM city simulation with game state management, map generation, SPC700 engine"
weight: 6
---

## Overview

Full disassembly of SimCity (SNES) by Yoshifanatic using asar assembler. Nintendo/Maxis, LoROM layout, ~1MB ROM, no co-processor. 47K lines of disassembled routines. Includes a 2.2K-line SPC700 sound engine — one of the simpler but complete sound implementations available.

**Value: 7/10** — LoROM layout matches ours. Simulation tick architecture and named constants pattern are directly useful. SPC700 engine is a good starting point for sound.

## SNES Features Demonstrated

- LoROM memory layout (~1MB)
- Complex game state management (population, economy, disasters, scenarios)
- Map generation with seed-based procedural algorithms
- COPRt decompression for asset loading
- SPC700 sound engine (complete, 2.2K lines)
- Simulation tick architecture with multiple update frequencies

## Key Files

| File | What to Study |
|------|---------------|
| `Routine_Macros_SIMC.asm` | 47K lines — complete simulation engine |
| `RAM_Map_SIMC.asm` | City data structures, simulation state |
| `Misc_Defines_SIMC.asm` | Named constants for population thresholds, economy, building types |
| `SRAM_Map_SIMC.asm` | Save data structure |
| `SPC700/Engine.asm` | 2.2K-line sound engine — complete and relatively simple |
| `PremadeMaps/` | Pre-built city maps and scenario data |
| `Tables/` | Game balance tables, building properties |

## Lessons for Clyde

1. **Named constants** — `Misc_Defines_SIMC.asm` uses named constants everywhere instead of magic numbers. Population thresholds, tax rates, building costs all have symbolic names. Adopt this discipline.
2. **Simulation tick architecture** — Different subsystems update at different frequencies (population monthly, economy quarterly, disasters randomly). Shows how to manage complex game state with limited CPU time.
3. **LoROM reference** — Same ROM layout as our projects. Good reference for bank organization and memory mapping in a shipping game.
4. **SPC700 entry point** — The 2.2K-line sound engine is the smallest complete SPC700 implementation in our references. Good starting point when we add sound to Clyde.
