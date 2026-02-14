---
title: "Harvest Moon (SNES)"
description: "WIP decompilation of Harvest Moon SNES — RPG data architecture, dialog system, entity structures"
weight: 3
---

## Overview

Work-in-progress decompilation of **Harvest Moon (SNES USA)** by dzik87. 122+ commits, actively maintained (last activity Aug 2025). Uses the **Asar** assembler with **LoROM** layout across 30+ banks. The most directly relevant reference for Clyde — it's a complete RPG with dialog, NPCs, and tile-based world.

**Value: 9/10** — RPG data architecture, dialog system, entity/object structures, and tile management at scale.

## SNES Features Demonstrated

- LoROM bank structure (30+ banks)
- Dialog/text rendering system
- Entity/NPC data structures
- Sprite and tile management
- Palette bank organization
- Enum/structure-based data definitions

## Key Files & Directories

| Path | What to Study |
|------|---------------|
| `main.asm` | Entry point, bank includes, ROM layout |
| `enums.asm` | Game-wide enumerations — item IDs, NPC types, states |
| `structures.asm` | Data structure definitions — entity fields, save data |
| `DIALOGS/` | Complete dialog system (US/JP/EU/DE localizations) |
| `DIALOGS/helpers.asm` | Dialog rendering and text processing |
| `DATA/objects/` | Entity/object data tables (banks 86-87) |
| `SOURCE/` | Per-bank source (bank_80 through bank_85) |
| `SOURCE/helpers.asm` | Common routines shared across banks |
| `snes.asm` | SNES hardware register definitions |

## Lessons for Clyde

1. **RPG data architecture** — `enums.asm` and `structures.asm` show how a real RPG organizes game data. Enum-driven design keeps magic numbers out of logic code.
2. **Dialog system** — The `DIALOGS/` directory is a complete text engine with multi-language support. Study for Clyde's own dialog implementation.
3. **Entity structures** — `DATA/objects/` defines NPC/entity data tables. Shows field layout, pointer tables, and how to pack entity state efficiently.
4. **Bank organization** — 30+ banks with clear separation of code, data, graphics, and audio. Good model for scaling Clyde's ROM as content grows.
