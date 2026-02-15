---
title: "Akalabeth Port Debrief"
description: "Post-mortem: what worked, what didn't, and everything learned building a complete SNES game in 65816 assembly"
---

## Project Summary

Faithful SNES port of Richard Garriott's 1979 *Akalabeth: World of Doom*, written entirely in 65816 assembly. Built in a ~24-hour sprint (Feb 13–14 2026) across 15 phases and 27 commits.

**Final metrics:**
- 9 source files, ~6,500 lines of 65816 asm
- 64KB ROM (2-bank LoROM, 65,536 bytes)
- Shared library: init, joypad, NMI handler, macros
- 7 passing E2E tests (Mesen2 Lua harness)
- Mechanically complete: chargen → overworld → 10-floor dungeons → quest victory → SRAM save

## What Went Well

- **Procedural generation from 2-byte seed** — overworld + all dungeon floors deterministic from a single "lucky number." Reproducible worlds made debugging trivial.
- **Grid-based architecture** — 11×11 dungeon grid, 20×20 overworld. Fast lookup, easy collision, debuggable state. No sub-tile complexity.
- **BG3 text overlay** — single 2bpp font drove all UI (stats HUD, messages, menus, shop) without touching sprites. Mode 1 BG3 has its own priority bit — free overlay layer.
- **PPU shadow registers + NMI DMA queue** — game logic writes to ZP shadows ($40–$5D), NMI copies to hardware. Clean separation of game timing from VRAM timing. Matches BS Zelda pattern.
- **Modular `.proc` architecture** — each file self-contained with explicit `.import`/`.export`. No global state leakage between compilation units.
- **Test harness (Mesen2 Lua)** — full-game playthrough test caught regressions across phases 13–15. Teleport-based testing writes directly to ZP vars to set up game state.
- **Incremental complexity** — each phase built on the last. Never rewrote working code. Phase 1 rendering still runs unchanged in the final ROM.
- **SRAM save with XOR checksum** — simple but caught real corruption bugs during development. Magic bytes + checksum validation on load.

## What Went Poorly / Lessons Learned

**Register width tracking** — `.i8`/`.i16` are file-scoped and linear in ca65. They carry across `.proc` boundaries. Every function using `ldx #imm` or `ldy #imm` must explicitly set width at entry. Got burned multiple times: mismatch causes instruction misalignment → total RAM corruption. Hard to diagnose because the symptoms appear far from the cause.

**`.define` scoping** — file-scoped in ca65, cannot cross compilation units. Had to use `.include` for header.inc instead of separate compilation. Also hit this with SFX ID constants — ended up creating shared `.inc` files.

**Symbol export for constants** — `= $xx` equate constants can't be `.export`ed and `.import`ed for use as 8-bit immediates. ca65 treats imported symbols as 16-bit addresses. Fixed by moving constants to shared `.inc` files included by both producer and consumer.

**Phase numbering drift** — phases got renumbered/interleaved (8C, 9B, 9D) as features were split. Should have used feature names instead of sequential numbers.

**dungeon.s grew too large** — 2,400 lines in one file: generation, rendering, AI, combat integration, item interaction all merged. Should have split rendering into its own file earlier.

**No audio from the start** — left SPC700 to the end (phase 15). Even a simple boot beep early on would have proven the APU pipeline and avoided the "totally silent" gap for 14 phases.

## 65816/SNES Knowledge Earned

### CPU

- `sep #$20` / `rep #$20` control accumulator width (M flag); `sep #$10` / `rep #$10` control index width (X flag). `sep #$30` / `rep #$30` do both. ca65 needs `.a8`/`.a16`/`.i8`/`.i16` directives to track this at assemble time.
- Hardware multiply: write operands to `$4202`/`$4203`, wait 8 cycles (4 NOPs), read 16-bit result from `$4216`. Used for monster HP scaling and grid offset calculation.
- 65816 native mode (`clc; xce`) unlocks 16-bit registers and full 24-bit address space. Emulation mode is 6502 compatible but limited to 8-bit registers and 64KB.
- Stack at `$1FFF`, direct page at `$0000` — set once in ResetHandler, never changed.

### PPU

- **Mode 1**: BG1 (4bpp) for game tiles, BG3 (2bpp) for text overlay. BG2 unused — available for parallax or additional layers.
- **Tilemap attributes**: bits 10–12 of tilemap entry = palette number. Per-tile palette assignment via high byte.
- **Scroll registers** are write-twice (low then high byte). Must write both even if high byte is 0.
- **VRAM writes** only safe during VBlank or force blank. Shadow registers + NMI copy is the standard pattern.

### DMA

- Channel 0 for general transfers. Mode `$01` (2-reg, 1-write) for VRAM, `$00` (1-reg, 1-write) for CGRAM, `$02` (1-reg, 2-write) for OAM.
- **Fixed-source DMA** (`$08` OR'd with mode) for clearing — point at a zero byte, transfer N bytes. Used in init to zero VRAM/OAM/CGRAM.

### APU / SPC700

- 4 bidirectional I/O ports at `$2140`–`$2143` (CPU side) / `$F4`–`$F7` (SPC side). Each direction has its own register — writing doesn't affect the read value.
- **IPL ROM boot protocol**: SPC signals ready with `$AA`/`$BB` on ports 0/1. CPU sends destination address on ports 2/3, then streams bytes with counter echo handshake.
- SPC700 is a separate 8-bit CPU (Sony, 1.024 MHz) with its own 64KB RAM. No shared memory with 65816 — all communication via 4 ports.
- **BRR compression**: 4-bit ADPCM, 9-byte blocks (1 header + 8 data bytes = 16 samples). Loop and end flags in header byte.

### LoROM Layout

- Bank 0: `$8000`–`$FFFF` mapped to first 32KB of ROM. Header at CPU `$FFC0` (file offset `$7FC0`). Vectors at `$FFE0`–`$FFFF`.
- Bank 1: `$018000`–`$01FFFF` mapped to second 32KB. Used for AUDIODATA segment.
- SRAM at `$700000` (bank `$70`). Size declared in ROM header (`$03` = 8KB).
- In ld65 config, MEMORY start values are **CPU addresses**, not file offsets.

## Toolchain Knowledge

### ca65 / ld65

- `--cpu 65816` flag required. `.p816` directive at top of files enables 65816 instructions.
- `-I ../../lib` for include path to shared library.
- `.exportzp` / `.importzp` for zero page symbols — using `.export`/`.import` causes linker warnings about address size mismatch.
- ca65 does NOT support `:` as instruction separator (unlike WLA-DX/asar). One instruction per line.
- `.proc`/`.endproc` creates local label scoping. Use `@label` for truly local labels within a proc.

### Mesen2 Test Harness

- Flags: `--testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true`
- Lua API: `emu.read(addr, memType.cpuDebug)`, `emu.addEventCallback(fn, eventType.startFrame)`, `emu.execute(count, execType.cpuInstructions)`.
- Symbol file parsing (`build/akalabeth.sym`) provides address lookup for ZP variables.
- Teleport-based testing: write directly to ZP variables to set up game state, then verify outcomes.

### Build System

- `make -C projects/<name>` from repo root. Pattern rules compile lib sources to `build/lib_%.o`.
- Object file order matters for ld65 — list in dependency order in Makefile's SRC variable.
- header.inc must be `.include`d (not compiled separately) because `.define` is file-scoped.

## Knowledge Gaps for Next Project

- **HDMA** — not used. Needed for gradient backgrounds, water effects, parallax scrolling, scanline effects.
- **Sprites (OAM)** — only used BG tiles. No sprite rendering, OAM management, or sprite priority/flipping. Essential for any action game.
- **Mode 7** — not explored. Needed for world maps, rotation effects, racing views.
- **IRQ timing** — only used NMI. H/V-count IRQs needed for mid-frame effects (raster splits, status bars).
- **Multi-bank code** — all code fits in bank 0. Larger projects need far-call (`jsl`/`rtl`) across banks, proper segment management.
- **SPC700 programming** — used binary blob approach. No experience writing actual SPC700 assembly, DSP register configuration, or BRR sample creation from scratch.
- **BRR encoding pipeline** — no working WAV→BRR→tracker→exporter→ROM pipeline. SNESGSS tracker is Windows-only (needs Wine).
- **Palette animation** — static palettes only. No color cycling, flash effects, or dynamic palette updates during gameplay.
- **Window registers** — not used (`$2123`–`$212B`). Needed for HUD masks, spotlight effects, transitions.
- **Hardware division** — used hardware multiply but not division (`$4204`–`$4206`). Division has 16-cycle latency.

## Recommended Future Documentation

Based on what was most frequently needed and hardest to find:

1. **Register width cheat sheet** — one-page reference: which instructions are affected by M/X flags, what happens when you get it wrong, canonical entry pattern for every function
2. **DMA cookbook** — copy-paste patterns for every common DMA operation (VRAM upload, CGRAM upload, OAM upload, RAM clear, tilemap transfer)
3. **APU communication protocol** — step-by-step with timing diagrams. The Wikibooks tutorial is good but verbose; need a condensed reference
4. **Linker config patterns** — LoROM layouts for 128KB, 256KB, 512KB ROMs. Multi-bank code + data segments. SRAM configuration
5. **Mesen2 Lua API reference** — the official docs are sparse. Document every function used in our test harness with examples
6. **BRR encoding guide** — WAV→BRR pipeline, loop point calculation, quality tradeoffs. Currently no consolidated reference
7. **Sprite/OAM management** — allocation strategies, size tables, priority handling. Critical for Clyde RPG

## Architecture Decisions Worth Preserving

| Decision | Rationale | Keep? |
|----------|-----------|-------|
| Mode 1 (BG1 tiles + BG3 text) | Simple, reliable, plenty of layers for RPG UI | Yes |
| PPU shadow registers in ZP $40–$5D | Fast writes, clean NMI handler, matches BS Zelda pattern | Yes |
| DMA queue in NMI | Decouples game logic timing from VRAM transfer timing | Yes |
| Grid-based maps (not scrolling) | Perfect for dungeon crawlers; won't scale to scrolling action | Context-dependent |
| Single PRNG (16-bit LFSR) | Simple, fast, deterministic from seed. Adequate for RPG | Yes |
| SRAM save with XOR checksum | Minimal but effective. CRC16 more robust for larger saves | Upgrade for Clyde |
| Shared lib as separate compilation units | Clean separation, but `.define` forced `.include` for header | Yes, with .inc for constants |
| Constants in .inc files (not exported symbols) | Works around ca65's symbol-as-address limitation for 8-bit immediates | Yes |
