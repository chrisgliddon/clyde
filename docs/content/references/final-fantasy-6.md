---
title: "Final Fantasy VI (SNES)"
description: "Complete rebuildable ca65 disassembly — event scripting VM, monster AI DSL, HDMA effects, Mode 7, SPC700 boot"
weight: 3
---

## Overview

Full modular ca65/ld65 disassembly of Final Fantasy VI (FF3 US) — Shadow's home game. ~323KB of source across 100+ files organized by subsystem: field, battle, btlgfx, menu, world, sound, cutscene, event, gfx, text. Builds 3 ROM variants (JP, EN v1.0, EN v1.1) from a single codebase using ROM_VERSION/LANG_EN defines. Python asset pipeline for text encoding, BRR audio, MML music compilation, LZSS compression.

**Value: 10/10** — The most complete rebuildable ca65 SNES RPG disassembly available. Event scripting VM with 60+ opcodes, monster AI DSL, HDMA line effects, Mode 7 world map rotation, SPC700 boot sequence, multi-language build system. Direct template for Clyde's architecture.

## SNES Features Demonstrated

- LoROM multi-bank layout (banks C0-EE)
- Event scripting VM with 60+ command opcodes
- Monster AI DSL (condition/action scripts per enemy)
- HDMA line-by-line effects (parallax, color gradients, window shaping)
- Mode 7 world map with real-time rotation
- SPC700 boot sequence ($BBAA handshake + IPL transfer)
- DMA batch transfers for VRAM/OAM/CGRAM
- Multi-language build (JP/EN) with conditional assembly
- Python asset toolchain (text encoding, BRR, MML, LZSS)
- Modular ca65 architecture with `_ext` cross-module convention

## Key Files

| File | What to Study |
|------|---------------|
| `src/field/event.asm` | Event scripting routines, NPC interaction |
| `include/event_cmd.inc` | Event VM opcode definitions (60+ commands) |
| `src/battle/battle_main.asm` | Battle loop, turn control, command dispatch |
| `src/battle/ai_script.asm` | Monster AI script interpreter |
| `include/battle/ai_script.inc` | AI target enums (MONSTER_SLOT, RAND_MONSTER) |
| `src/field/hdma.asm` | H-DMA channel setup, parallax scrolling |
| `src/world/rotate.asm` | Mode 7 world map rotation math |
| `src/world/world_main.asm` | World map controller |
| `src/sound/sound_main.asm` | SPC700 boot, command protocol, song control |
| `include/macros.inc` | CPU mode macros (shortA, longA), register helpers |
| `include/const.inc` | Global constants, ROM_VERSION, STATUS flags |
| `cfg/ff6-en.cfg` | ld65 linker config — multi-bank segment mapping |
| `Makefile` | Build system — ca65/ld65 + Python asset pipeline |
| `src/menu/shop.asm` | Shop UI system |
| `src/text/text.asm` | Text engine with DTE compression |
| `tools/encode_text.py` | Text encoding pipeline |

## Lessons for Clyde

1. **Event scripting VM** — event_cmd.inc defines 60+ bytecode commands for field events: dialog, NPC movement, party changes, screen effects, branching, loops, timers. The interpreter in event.asm runs a fetch-decode-execute loop with a script pointer, call stack, and local variables. Essential pattern for any RPG with scripted sequences.
2. **Monster AI DSL** — ai_script.asm interprets per-monster scripts written as condition/action pairs. Conditions check HP thresholds, status flags, turn count, element weakness. Actions select attacks, spells, or behaviors. Scripts are data-driven — adding new monsters requires only new script data, no code changes.
3. **HDMA line effects** — hdma.asm sets up H-DMA channels for per-scanline register writes. Used for parallax scrolling (different scroll speeds per line), color gradients (sky transitions), and window shaping. Each effect is a table of per-line values DMA'd to PPU registers during HBlank.
4. **Mode 7 world map** — rotate.asm implements real-time rotation/scaling for the Mode 7 world map. Precomputes sin/cos lookup tables, calculates per-scanline rotation parameters, writes to Mode 7 matrix registers via HDMA. The math is fixed-point 16-bit.
5. **SPC700 boot sequence** — sound_main.asm implements the full SPC700 initialization: wait for $BBAA ready signal, transfer driver code via IPL protocol, then switch to command mode. Commands use the 4-port APU interface ($2140-$2143) with acknowledge handshake.
6. **Modular ca65 architecture** — Each subsystem lives in its own directory with dedicated source and data files. Cross-module calls use `_ext` suffix naming convention. Linker config maps each subsystem to specific banks. Makefile compiles each .asm independently. Scalable pattern for large ca65 projects.
7. **Shadow/Interceptor mechanics** — const.inc defines STATUS4::INTERCEPTOR flag. Shadow's dog Interceptor has a chance to block attacks (based on status flag check) and counter-attack. The mechanic is data-driven through status bit checks in the battle engine.
