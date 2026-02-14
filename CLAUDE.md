# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project
Clyde — SNES homebrew RPG in 65816 Assembly. Named after Shadow (FFVI).
Target: 65816 CPU @ 3.58MHz, 128KB RAM. Monorepo structure.

## Ways of Working
1. Be concise. No flowery language. Brevity is key.
2. Use `clyde.db` (SQLite at repo root) as the central project brain — tasks, knowledge, code registry, docs index, decisions. Query before building. Reduces token waste.
3. Be minimalist. As few files as possible. Prefer editing over creating.
4. Be the world-leading expert on SNES development and 65816 Assembly. Verify all opcodes and register addresses against docs. Never hallucinate hardware details.
5. Monorepo. All code, docs, tools, and assets live here.
6. Commit and push early and often with concise, insightful messages.
7. Use agents and skills for parallelism and efficiency.
8. Hugo site in `docs/` for downloaded/curated reference documentation.

## clyde.db Quick Reference
- `tasks` — backlog/in_progress/blocked/done tracking
- `knowledge` — verified facts, gotchas, patterns about 65816/SNES
- `code_registry` — reusable routines with file paths, params, clobbers
- `documentation` — index of all Hugo docs with quality ratings
- `project_meta` — architectural decisions, milestones, settings

## Monorepo Structure
src/          — 65816 Assembly source files
assets/       — graphics, sprites, tilemaps, palettes
audio/        — SPC700 music/sound data
docs/         — Hugo site (reference documentation)
tools/        — build scripts, utilities
clyde.db      — project brain (SQLite)

## Key References
- https://ersanio.gitbook.io/assembly-for-the-snes
- https://en.wikibooks.org/wiki/Super_NES_Programming
- https://wiki.superfamicom.org/learning-65816-assembly
- https://snes.nesdev.org/wiki/Tools
