# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project
Clyde — SNES homebrew in 65816 Assembly. Multi-project monorepo.
Target: 65816 CPU @ 3.58MHz, 128KB RAM. Named after Shadow (FFVI).

## Ways of Working
1. Be concise. No flowery language. Brevity is key.
2. Use `clyde.db` (SQLite at repo root) as the central project brain — tasks, knowledge, code registry, docs index, decisions. Query before building. Reduces token waste.
3. Be minimalist. As few files as possible. Prefer editing over creating.
4. Be the world-leading expert on SNES development and 65816 Assembly. Verify all opcodes and register addresses against docs. Never hallucinate hardware details.
5. Monorepo. All code, docs, tools, and assets live here.
6. Commit and push early and often with concise, insightful messages.
7. Use agents and skills for parallelism and efficiency.
8. Hugo site in `docs/` for downloaded/curated reference documentation.

## Toolchain
Assembler: ca65 (cc65 suite). Linker: ld65. Install: `brew install cc65`
ROM format: LoROM, 128KB default. Linker configs in each project's config/ dir.
Build: `make -C projects/<name>` produces `build/<name>.smc`
Test with: Mesen2 (primary), bsnes-plus (accuracy verification).

## clyde.db Quick Reference
- `tasks` — backlog/in_progress/blocked/done tracking
- `knowledge` — verified facts, gotchas, patterns about 65816/SNES
- `code_registry` — reusable routines with file paths, params, clobbers
- `documentation` — index of all Hugo docs with quality ratings
- `doc_chunks` — chunked doc content for RAG (heading-aware, SHA-256 hashed)
- `vec_chunks` — sqlite-vec embeddings (nomic-embed-text, 768d) for KNN search
- `project_meta` — architectural decisions, milestones, settings

## Monorepo Structure
projects/     — SNES ROM projects (each self-contained with src/, assets/, Makefile)
lib/          — shared 65816 code (init, macros, header template)
tools/        — build scripts, utilities (includes clyde-cli)
docs/         — Hugo site (reference documentation)
references/   — SNES reference source code (gargoyles_quest, doom, harvest_moon, akalabeth)
clyde.db      — project brain (SQLite + sqlite-vec)

## Shared Lib (lib/)
- `macros.s` — CPU mode switching (SET_A8, SET_A16, SET_AXY16, etc.), PPU/DMA register constants
- `init.s` — SNES cold boot init (native mode, clear registers, DMA clear VRAM/OAM/CGRAM)
- `header.inc` — parameterized LoROM ROM header + vectors (.include after .define GAME_TITLE)

## Projects
- `projects/akalabeth/` — Akalabeth: World of Doom SNES port (active)
- `projects/clyde/` — Clyde RPG (future)

## ca65 Notes
- Use `.p816` for 65816 mode, `.a8`/`.a16`/`.i8`/`.i16` to track register width
- Macros in macros.s include these directives automatically
- `.define` is file-scoped; use `.include` for header template, not separate compilation
- `.exportzp`/`.importzp` for zero page symbols (not `.export`/`.import`)
- `--cpu 65816 -I ../../lib` flags for ca65

## clyde CLI (tools/clyde-cli/)
Go CLI for the project brain. Build: `CGO_ENABLED=1 go build -o clyde .`
- `clyde status` — DB stats dashboard
- `clyde index` — chunk docs, embed via Ollama, store vectors (incremental)
- `clyde search <query>` — semantic KNN search across docs
- `clyde knowledge` — extract SNES facts from doc content
Requires Ollama running with `nomic-embed-text` model.

## Key References
- https://ersanio.gitbook.io/assembly-for-the-snes
- https://en.wikibooks.org/wiki/Super_NES_Programming
- https://wiki.superfamicom.org/learning-65816-assembly
- https://snes.nesdev.org/wiki/Tools
- https://cc65.github.io/doc/ca65.html
