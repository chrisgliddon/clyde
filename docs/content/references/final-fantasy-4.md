---
title: "Final Fantasy IV (SNES)"
description: "Complete rebuildable ca65 disassembly — ATB battle, graphics bytecode VM, modular bank layout, multi-language"
weight: 6
---

## Overview

Full modular ca65/ld65 disassembly of Final Fantasy IV (FF2 US) by everything8215. ~2MB of source across 100+ files organized by subsystem: battle, btlgfx, menu, field, sound, cutscene. Supports JP (v1.0/1.1) and US English (v1.0/1.1) ROMs. LoROM layout, Node.js data extraction pipeline, JSON-driven asset management.

**Value: 9/10** — One of only two rebuildable ca65 RPG disassemblies (alongside FF6). Graphics bytecode VM, ATB timer implementation, DP isolation per mode, and modular multi-bank architecture are directly applicable to Clyde.

## SNES Features Demonstrated

- LoROM multi-bank layout (banks 00-1F, 32KB each)
- ATB (Active Time Battle) timer system with status duration tracking
- Graphics script bytecode VM (btlgfx — decouples logic from rendering)
- Direct page isolation per game mode (battle $00-$7F, menu $100+, field $600+)
- SPC700 sound driver with $BBAA handshake boot
- DMA-based VRAM/CGRAM transfers
- Modular ca65 project structure with `_ext` cross-module calling convention
- Multi-language build via conditional `.sprintf()` includes
- 3bpp tile compression for battle graphics

## Key Files

| File | What to Study |
|------|---------------|
| `battle/battle.asm` | ATB battle engine entry, turn management |
| `battle/timer.asm` | ATB timer implementation, speed calculations |
| `battle/ai.asm` + `ai_cond.asm` | Monster AI condition/action system |
| `battle/damage.asm` | Damage formula, element interactions |
| `btlgfx/btlgfx.asm` | Graphics script bytecode VM (136KB — full rendering pipeline) |
| `btlgfx/sprite.asm` | Battle sprite animation system |
| `menu/menu.asm` | Parameterized window system, cursor management |
| `menu/shop.asm` | Shop UI with buy/sell/equip flow |
| `field/event.asm` | Field event scripting, NPC interaction |
| `sound/sound.asm` | SPC700 boot, command interface, song playback |
| `include/macros.inc` | Macro library (`clr_a`, `clr_ax`, register helpers) |
| `include/hardware.inc` | SNES hardware register definitions |
| `ff4-en.lnk` | ld65 linker config — multi-bank LoROM memory map |
| `notes/ff4j-sfc-ram-map.txt` | Complete RAM map with DP isolation per mode |
| `notes/ff4-spc.asm` | SPC700 sound CPU disassembly (76KB) |

## Lessons for Clyde

1. **Graphics script bytecode** — btlgfx implements a bytecode VM that decouples battle logic from rendering. Commands like "animate sprite", "flash palette", "shake screen" are encoded as script bytes interpreted by the graphics engine. Eliminates tight coupling between game state and PPU updates.
2. **ATB timer system** — timer.asm implements the Active Time Battle speed system. Each actor has a timer that increments based on Speed stat; when it overflows, the actor gets a turn. Status effects (Haste/Slow/Stop) modify the increment rate. Clean model for any real-time turn system.
3. **Direct page isolation** — Each game mode (battle, menu, field) uses a different DP base address, giving each mode its own zero-page workspace without conflicts. Battle uses $00-$7F, menu $100+, field $600+. Avoids ZP collision in complex games.
4. **Modular ca65 architecture** — Each subsystem (battle/, btlgfx/, menu/, field/, sound/) is a self-contained module with its own `_data.asm` file. Cross-module calls use `_ext` suffix convention (e.g., `ExecBtlGfx_ext`, `ExecSound_ext`). Clean pattern for scaling ca65 projects.
5. **Multi-language build** — Uses `.sprintf()` to conditionally include `menu_text_en.inc` vs `menu_text_jp.inc`. Single codebase builds both language variants. Good model for localization without code duplication.
6. **Menu window system** — menu.asm implements parameterized windows with configurable position, size, and content. Reusable for any RPG menu system.
