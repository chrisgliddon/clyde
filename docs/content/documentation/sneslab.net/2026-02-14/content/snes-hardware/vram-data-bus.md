---
title: "VRAM Data Bus"
reference_url: https://sneslab.net/wiki/VRAM_Data_Bus
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Buses"
downloaded_at: 2026-02-14T17:13:09-08:00
cleaned_at: 2026-02-14T17:54:39-08:00
---

The **VRAM Data Bus** is the data bus that connects S-PPU1 and S-PPU2 to the VRAM chips. It consists of two 8-bit data buses: VDA and VDB.

- VDA0-VDA7 connects to the VRAM chip which has VAA going to it
- VDB0-VDB7 connects to the other VRAM chip, which has VDB going to it.

It is drawn in blue in the colorized jwdonal schematic.

### See Also

- VRAM Bus Control

### External Links

1. Figure 2-22-1 on [page 2-22-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n98)
