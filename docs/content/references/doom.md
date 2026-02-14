---
title: "Doom (SNES)"
description: "SNES Doom port — SuperFX/GSU co-processor, multi-bank ROM, conditional assembly"
weight: 2
---

## Overview

Complete SNES port of Doom using the **Acme** assembler. 163 `.a` source files plus `.i` includes. Pushes the SNES to its limits via the **GSU/SuperFX** co-processor for 3D rendering. Advanced multi-bank ROM organization.

**Value: 8/10** — Boot sequence, multi-bank layout, and conditional assembly patterns are directly useful. GSU-specific code is less relevant but shows co-processor integration.

## SNES Features Demonstrated

- GSU/SuperFX co-processor programming
- Multi-bank LoROM organization
- Cold/warm boot detection
- NMI/IRQ handler setup
- Conditional assembly with feature flags
- Music driver integration (SPC700)

## Key Files

| File | What to Study |
|------|---------------|
| `Source/init.a` | Boot sequence — cold/warm detection, register init, RAM clear |
| `Source/rlmain.a` | Main game loop structure |
| `Source/snes.i` | SNES register definitions (comprehensive) |
| `Source/rlmove.a` | GSU-driven movement calculations |
| `Source/rage.i` | Feature flags for conditional assembly |
| `Source/rlcolour.a` | Palette management and lighting system |
| `Source/nmi.a` | NMI (VBlank) handler |
| `Source/musicdrv.a` | SPC700 music driver interface |

## Lessons for Clyde

1. **Boot sequence** — `init.a` is a textbook SNES cold boot. Check signature in RAM to distinguish cold vs warm reset. Adopt this pattern.
2. **Register definitions** — `snes.i` has clean, well-organized hardware constants. Use as reference when defining our own.
3. **Multi-bank layout** — Shows how to split a large game across ROM banks with proper `ORG` directives and far calls.
4. **Conditional assembly** — `rage.i` flags enable/disable features at build time. Useful for debug builds vs release.
