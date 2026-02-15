---
title: "Akalabeth: World of Doom"
description: "SNES port status — implemented features, test coverage, known gaps"
---

## Overview

Faithful SNES port of Richard Garriott's 1979 Apple II dungeon crawler, written entirely in 65816 assembly. Seven source files totaling ~6,300 lines, plus shared library (init, joypad, NMI). The game loop is mechanically complete from character generation through quest victory, with SRAM save persistence and per-tile color palettes. LoROM 128KB ROM with a colored wireframe aesthetic inspired by the original.

## Architecture

| File | Lines | Handles |
|------|------:|---------|
| `main.s` | 658 | 8-state game loop, chargen (seed/stats/class), shop, castle/quest, game over, fade transitions between states |
| `dungeon.s` | 2381 | 10-floor procedural generation, first-person wireframe renderer (depth 1–4), per-tile palette attributes, stairs/traps/chests/doors, monster spawning |
| `ui.s` | 1418 | BG3 text engine (96 ASCII glyphs, 2bpp), stats HUD row 0, message system row 26 with 120-frame auto-clear, all menu screens |
| `gfx.s` | 776 | Tile data (8 overworld + 9 dungeon tiles, 4bpp wireframe), 10 unique monster wireframe tiles, font, DMA uploads, 6 overworld palettes, 4 dungeon palettes, 5 UI text color palettes |
| `overworld.s` | 615 | 20×20 procedural map from seed, 7 tile types, 3×3 viewport, per-tile palette lookup, movement/collision, food/hunger |
| `combat.s` | 186 | Hit%/damage formulas, weapon priority, monster damage, amulet magic, PRNG |
| `save.s` | 252 | SRAM save/load at $700000, magic bytes + XOR checksum validation, auto-save on state transitions |

Shared lib provides: `init.s` (cold boot, clear VRAM/OAM/CGRAM/RAM), `joypad.s` (ReadJoypad, button press detection), `nmi.s` (PPU shadow copy, DMA queue, frame counter). Mode 1 graphics: BG1 for game tiles, BG3 for text overlay.

## Implemented Features

### Character Generation
Lucky number seed (determines overworld map + dungeon layouts). Stat rolling with approximate square-root distribution via hardware multiplier — STR, DEX, STA, WIS in range 4–24. Fighter/Mage class toggle. Difficulty selection 1–10.

### Overworld
20×20 procedural map generated from seed. 7 tile types with weighted distribution (73% grass, 12% mountain, 8% forest, 2.5% castle, 1.2% dungeon). Guaranteed exactly 1 town and 1 castle per map. 3×3 local viewport centered on player. Movement costs 1 food per step; starvation drains HP instead.

### Dungeon
10 floors (0–9), each an 11×11 procedural grid using room-grid algorithm with random wall/door/chest/trap placement. First-person wireframe view at depths 1–4 rendering walls, doors, chests, stairs, and monsters at varying scales. Stairs up/down, traps (HP damage), chests (gold rewards).

### Combat
10 monster types with scaling HP = (type+1)×2 + (floor+1)×2×difficulty:

| # | Monster | Special |
|---|---------|---------|
| 0 | Skeleton | — |
| 1 | Thief | 40% chance steals gold |
| 2 | Giant Rat | — |
| 3 | Orc | — |
| 4 | Viper | — |
| 5 | Carrion Crawler | — |
| 6 | Gremlin | 50% chance eats half food |
| 7 | Mimic | Never moves |
| 8 | Daemon | — |
| 9 | Balrog | — |

Hit formula: random < DEX×8. Damage by weapon: Rapier (0–15 + STR/4), Axe (0–7 + STR/4), Bow (0–3 + STR/4), Shield (0–1 + STR/4), bare hands (STR/4 only). Monster damage = (1 + type) + floor.

### Magic
Amulet with class-specific effects. Mage gets 3 random outcomes (ladder up, ladder down, magic kill). Fighter gets magic kill only. 4% backfire chance (halves HP or turns to toad). 25% crumble on use.

### Quest System
Kill a target monster type. WIS-based initial quest assignment. Difficulty ratchets up on victory (capped at 10), awards +5 HP and +2 STR per quest accepted.

### Economy
6-item shop: Food (1gp ×10), Rapier (8gp), Axe (5gp), Shield (6gp), Bow (3gp), Amulet (15gp). Gold from dungeon chests and combat drops. Cursor-navigated shop menu.

### UI
BG3 text engine with 96 ASCII glyphs (2bpp, $20–$7E). Stats bar (HP/Food/Gold) on row 0. Combat/event messages on row 26 with 120-frame auto-clear timer. Full text-driven screens for title, chargen, shop, castle, and game over.

### Fade Transitions
FadeOut/FadeIn routines ramp INIDISP brightness across frames. Applied to 5 state transitions: overworld↔dungeon, overworld↔shop, overworld↔castle, chargen→overworld, and death→game over.

### SRAM Save
29-byte save block at $700000 with magic byte header and XOR checksum. Persists full character state (stats, inventory, quest progress, map seed, dungeon floor). Auto-saves on state transitions. Validated on load — corrupted or missing saves start fresh.

### Per-Tile Color Palettes
6 overworld palettes (grass, mountain, forest, water, castle, dungeon entrance) and 4 dungeon palettes assigned per-tile via BG1 tilemap attributes. BG3 UI text colors update dynamically by game state — 5 palettes for overworld, dungeon, shop, castle, and combat contexts.

### Monster Sprites
10 unique 4bpp wireframe tile sets, one per monster type (Skeleton through Balrog). Rendered in the first-person dungeon view at appropriate depth scale.

## Automated Tests

7 Lua unit tests plus 1 full-playthrough diagnostic, run via Mesen2's scripting API:

```
bash tools/mesen-test.sh akalabeth all
```

| Test | Validates |
|------|-----------|
| `test_chargen` | Title→seed→stats→class→overworld flow; stats in range 4–24; class toggle; quest assignment; starts with rapier |
| `test_overworld` | Player spawns adjacent to castle; castle entry changes state; B-button exits back to overworld |
| `test_dungeon` | Dungeon tile found procedurally; entry sets floor 0 at position (1,1); B-button exits to overworld |
| `test_shop_buy` | Town tile found; food purchase costs 1gp/adds 10 food; rapier purchase costs 8gp/increments count; B-button returns to overworld |
| `test_messages` | Attack triggers BG3 row 26 message; MsgTimer set; message persists ~120 frames then auto-clears |
| `test_debug` | Lua helper/symbol path resolution sanity check |
| `test_minimal` | Mesen2 API availability — emu object, memType/eventType enums, memory read, event callbacks |

`playthrough.lua` (378 lines) is a teleport-based full-game diagnostic that exercises chargen through quest victory, capturing 12 screenshots at key moments. Runs via `bash tools/mesen-diag.sh akalabeth tests/playthrough.lua`.

## Confirmed Working Flows

- Full game loop: chargen → overworld → dungeon → combat → quest → victory
- Shop purchasing all 6 items with correct gold deduction
- Dungeon navigation across all 10 floors via stairs
- Food starvation → HP drain → game over
- Procedural overworld regeneration from different seeds
- Amulet magic with backfire and crumble mechanics
- Quest difficulty ratchet across multiple victories
- SRAM save persistence across resets
- Fade transitions on all 5 state changes

## Known Gaps

- **Audio** — no SPC700 driver, total silence
- **Combat visual feedback** — no hit flash (palette swap on damage), no monster death animation
- **Advanced spells** — only amulet magic, no wizard spell list from the original
- **Title screen** — text only, no artwork or logo

## Next Steps

**Tier 1 — Highest impact:**
1. **SPC700 audio** — The single biggest remaining gap. Even minimal SFX (sword hit, miss, stairs, quest jingle) would transform the feel. Requires an SPC driver, BRR sample encoding, and APU communication.

**Tier 2 — Polish:**
2. **Combat visual feedback** — Hit flash (brief palette swap on damage), monster death animation (dissolve/flash). Low effort, noticeable improvement.
3. **Mage spell system** — Original Akalabeth had spells beyond the amulet for Mages. Adds gameplay depth. Contained to combat.s + ui.s.

**Tier 3 — Nice-to-have:**
4. **Title screen art** — Wireframe logo or castle graphic to replace the plain text title.
5. **Overworld visual variety** — Animated water tiles, day/night palette rotation.
