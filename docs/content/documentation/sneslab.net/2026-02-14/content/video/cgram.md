---
title: "CGRAM"
reference_url: https://sneslab.net/wiki/CGRAM
categories:
  - "Address_Spaces"
  - "Buffers"
downloaded_at: 2026-02-14T11:18:55-08:00
cleaned_at: 2026-02-14T17:55:08-08:00
---

**CGRAM** (Color Generator\[2] RAM) is a 512 byte buffer where palettes are stored for indirect color. In 2chip consoles, CGRAM is believed to live in S-PPU2. The SNES uses 15-bit color here. It is word (not byte) addressed. For each of the 256 color entries:

- bits 0 to 4 are the red intensity
- bits 5 to 9 are the green intensity
- bits 10 to 14 are the blue intensity
- bit 15 is unused - reading it returns S-PPU2 open bus

In all background modes, sprites use the second half of CGRAM (addresses 80h to FFh).

When using CGRAM, color entries can be one of 32,768 colors from the master palette.

Direct Color is a technique that does not use CGRAM.

### See Also

- OAM
- VRAM
- PPU
- The Infamous Bit-Of-Confusion

### References

1. [Appendix A-17](https://archive.org/details/SNESDevManual/book1/page/n211) of the official Super Nintendo development manual on CG-RAM
2. [https://problemkaputt.de/fullsnes.htm#snesmemorycgramaccesspalettememory](https://problemkaputt.de/fullsnes.htm#snesmemorycgramaccesspalettememory)
