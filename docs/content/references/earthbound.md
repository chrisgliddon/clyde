---
title: "Earthbound (SNES)"
description: "Complete disassembly — HiROM FastROM RPG with DMA tables, OAM double-buffering, copy protection"
weight: 5
---

## Overview

Full disassembly of Earthbound (Mother 2) by Yoshifanatic using asar assembler. Ape/HAL Laboratory, HiROM FastROM layout, 3MB ROM, no co-processor. 83K lines of disassembled routines covering the complete RPG engine. SPC700 sound is placeholder only (not yet disassembled).

**Value: 8/10** — DMA batch table pattern, OAM double-buffering, and RPG data structures are directly applicable to Clyde.

## SNES Features Demonstrated

- HiROM FastROM memory layout (3MB)
- DMA-to-VRAM update table with struct-based batch transfers
- OAM double-buffering for flicker-free sprite rendering
- Compressed text system with variable-width encoding
- Copy detection/protection system
- RPG inventory, stat, and party data structures
- Multi-bank code organization for large ROM

## Key Files

| File | What to Study |
|------|---------------|
| `EB/Routine_Macros_EB.asm` | 83K lines — complete game engine routines |
| `EB/RAM_Map_EB.asm` | RAM struct definitions, OAM buffers, DMA tables |
| `EB/Misc_Defines_EB.asm` | Game constants, item IDs, status flags |
| `EB/SRAM_Map_EB.asm` | Save data structure |
| `EB/Tables/` | RPG data tables (items, enemies, stats) |
| `EB/Script Codes.txt` | Text system encoding reference |
| `EB/SPC700/` | Placeholder only — sound not yet disassembled |

## Lessons for Clyde

1. **DMA batch table** — Earthbound queues DMA transfers into a struct table during game logic, then flushes them all during VBlank. Each entry specifies source, destination, size, and transfer mode. Superior to ad-hoc DMA calls — adopt this pattern for our NMI handler.
2. **OAM double-buffering** — Maintains two OAM buffers in RAM. Game writes to the back buffer while DMA transfers the front buffer to OAM during VBlank. Eliminates sprite flicker/tearing. Essential for any game with >4 sprites.
3. **RPG data architecture** — Inventory, party stats, and enemy data use fixed-size struct arrays in RAM with symbolic offsets. Good model for Clyde's RPG stat system.
4. **Copy protection** — Contains a software-based copy detection system. Interesting study in how commercial SNES games attempted anti-piracy.
