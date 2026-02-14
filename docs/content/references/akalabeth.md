---
title: "Akalabeth: World of Doom"
description: "Richard Garriott's 1979 RPG — Applesoft BASIC source, SNES port reference"
weight: 4
---

## Overview

Richard Garriott's first commercial RPG (1979). 676 lines of Applesoft BASIC targeting the Apple II. Predecessor to the Ultima series.

**Value: 9/10** — Complete, small game with all core RPG systems. Ideal first SNES port project.

## Source

- `references/akalabeth/AKLABETH.TXT` — full Applesoft BASIC source (676 lines)
- `references/akalabeth/*.GIF` — screenshots from the original game

## Core Systems

- **Overworld**: 20x20 tile grid (grass, mountains, towns, castle, dungeon entrances)
- **Dungeons**: 10x10 grid per floor, 10 floors deep, procedurally generated from seed
- **Combat**: Turn-based, 10 monster types with escalating difficulty
- **Stats**: STR, DEX, STA, WIS, HP, food, gold
- **Weapons**: Rapier, axe, bow, shield
- **Quests**: Lord British assigns 10 sequential monster-kill quests

## Translation Challenges (BASIC → 65816)

| Original (Apple II) | SNES Port |
|---|---|
| HGR wireframe graphics | Pre-drawn 8x8 tiles on BG layers |
| BASIC line numbers + GOTO | Labels + JMP/JSR |
| Float variables | Fixed-point or integer math |
| No save system | SRAM save |
| 40-column text | Mode 1 text layer |
| Keyboard input | Joypad D-pad + buttons |
| RND() function | LFSR or seed-based PRNG |
