---
title: "SNES Dev Guides"
weight: 1
---

Focused, pattern-oriented guides built from our codebase. Written for Claude first — concise, copy-paste-ready, with real code from Clyde projects.

For encyclopedic reference material, see [Documentation](/documentation/) (Wikibooks, Sneslab.net).

## Guides

- [Register Width Cheat Sheet]({{< ref "register-width" >}}) — M/X flags, ca65 directives, the file-scoped gotcha
- [DMA Cookbook]({{< ref "dma-cookbook" >}}) — 5 copy-paste DMA patterns + queue architecture
- [APU Communication Protocol]({{< ref "apu-protocol" >}}) — SPC700 boot, IPL ROM, SNESGSS driver
- [ld65 Linker Config Patterns]({{< ref "linker-configs" >}}) — LoROM memory maps, SRAM, segment layout
- [Mesen2 Lua Test API]({{< ref "mesen2-testing" >}}) — Complete API reference + test framework
- [BRR Encoding Guide]({{< ref "brr-encoding" >}}) — Audio compression format, WAV→BRR pipeline
- [Sprite/OAM Management]({{< ref "sprites-oam" >}}) — OAM structure, size tables, DMA patterns
