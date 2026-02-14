---
title: "Final Fantasy V (SNES)"
description: "Complete address-format disassembly — event scripting VM, job system, text engine with DTE, compression"
weight: 7
---

## Overview

Single-file 97K-line address-format disassembly of Final Fantasy V. Format: `C0/0000: 78  SEI` with bank/offset, hex bytes, mnemonics, and comments. Not rebuildable — reference-only. LoROM layout covering the complete game: battle engine with job/ability system, event scripting VM, text engine with escape codes and DTE compression, SPC700 sound interface.

**Value: 7/10** — Not rebuildable, but excellent reference for event scripting VM architecture, job/ability system mechanics, text engine with dynamic substitution, and compression algorithms (RLE + LZSS).

## SNES Features Demonstrated

- LoROM memory map with bank-prefixed disassembly format
- Event scripting bytecode interpreter (field events, cutscenes)
- Job/ability system with class-specific commands and stat modifiers
- Text engine with DTE (Dual Tile Encoding), MTE, escape codes, dynamic substitution
- RLE + LZSS compression for graphics and data
- SPC700 command interface for music/SFX
- Multi-layer scrolling and parallax
- Battle command system with configurable ability slots

## Key Sections

| Bank Range | What to Study |
|------------|---------------|
| `C0/0000-C0/FFFF` | Boot, init, core engine, hardware setup |
| `C1/xxxx` | Battle engine, damage formulas, command execution |
| `C2/xxxx` | Event scripting VM, NPC routines, cutscene logic |
| `C3/xxxx` | Menu system, job/ability selection, equip |
| `C4/xxxx` | Field engine, map loading, tile animation |
| `C5/xxxx-C9/xxxx` | Data tables, compressed graphics, map data |
| `CA/xxxx+` | Text data, font, dialog scripts |

## Lessons for Clyde

1. **Event scripting VM** — Bank C2 contains a bytecode interpreter for field events. Script commands control NPC movement, dialog, screen transitions, party changes, and cutscene sequencing. Each command is a byte opcode followed by variable-length parameters. The interpreter runs a fetch-decode-execute loop on a script pointer per event.
2. **Job/ability system** — The battle engine supports swappable ability sets per character. Each job defines which command slots are available and modifies base stats. Abilities learned from jobs persist across job changes. Good architecture for any class-based RPG.
3. **Text engine with escape codes** — The text system uses escape byte sequences for: variable substitution (character names, item names), text speed control, line breaks, window positioning, and conditional branching. DTE compresses common letter pairs into single bytes.
4. **SPC700 command interface** — Communication with the SPC700 uses a command byte + parameter protocol through APU I/O ports ($2140-$2143). Commands include: play song, play SFX, set volume, fade, stop. The handshake waits for the SPC to acknowledge each command.
5. **Compression** — Graphics and map data use RLE (run-length encoding) for repeated tiles and LZSS (sliding window) for general compression. Decompression routines are in the boot bank for early access.
