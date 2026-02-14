---
title: "SNES ROM Framework"
description: "Yoshifanatic's asar-based framework for managing SNES disassemblies and homebrew ROMs"
weight: 10
---

## Overview

Build system and organizational framework for asar-based SNES disassemblies by Yoshifanatic. Provides standardized structure for managing ROM versions, asset extraction, memory maps, and reassembly. Used as the scaffold for the Earthbound, SimCity, BS Zelda, and Super Mario RPG disassemblies in this repo.

**Value: 6/10** — Not directly usable (asar, not ca65), but the organizational patterns and hardware register definitions are excellent reference material.

## SNES Features Demonstrated

- Memory map configurations for LoROM, HiROM, ExLoROM, ExHiROM, SA-1, SuperFX, SDD1, SPC7110, Satellaview
- Complete hardware register definitions ($2100-$21FF PPU, $4200-$43FF CPU/DMA)
- Standardized ROM header and vector table generation
- "Routine macro" system for managing disassembled code at fixed addresses
- Asset pipeline (graphics, palettes, tilemaps, tables) with compression/decompression tools

## Key Files

| File | What to Study |
|------|---------------|
| `Global/Global_Definitions.asm` | Hardware register constants, memory map defines |
| `Global/Global_Macros.asm` | Common asar macros for ROM assembly |
| `Global/HardwareRegisters/` | Per-register documentation and constants |
| `Global/MemoryMap/` | Config files for every ROM layout type |
| `Global/Controllers/` | Joypad register definitions |
| `GAMEX_Homebrew_Sample_ROM/` | Template for new projects using the framework |
| `Firmware/` | SNES boot firmware handling |

## Memory Map Support

The framework includes configs for every SNES memory layout:
- **LoROM** — 32KB banks, $8000-$FFFF (our Akalabeth layout)
- **HiROM** — 64KB banks, $0000-$FFFF
- **ExLoROM/ExHiROM** — Extended addressing for >4MB ROMs
- **SA-1** — Co-processor with BWRAM mapping (used by Super Mario RPG)
- **SuperFX** — GSU co-processor mapping
- **Satellaview** — BS-X download format (used by BS Zelda)

## Lessons for Clyde

1. **Standardized file naming** — `RAM_Map_XX.asm`, `Routine_Macros_XX.asm`, `Misc_Defines_XX.asm` convention makes every disassembly navigable. Consider adopting similar naming for our own projects.
2. **Hardware register reference** — The `HardwareRegisters/` directory is a complete, well-organized PPU/DMA register reference. Cross-reference against our `macros.s` constants.
3. **ROM layout configs** — Concrete examples of every SNES memory map variant. Useful when planning multi-bank expansion or co-processor projects.
4. **Sample ROM template** — `GAMEX_Homebrew_Sample_ROM` shows minimal project structure — useful for understanding how asar projects are organized even though we use ca65.
