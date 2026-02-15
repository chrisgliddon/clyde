---
title: "PLOT (Super FX)"
reference_url: https://sneslab.net/wiki/PLOT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Plot-related_Instructions"
  - "One-byte_Instructions"
  - "Video"
downloaded_at: 2026-02-14T15:52:49-08:00
cleaned_at: 2026-02-14T17:52:46-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 4C 1 byte 3 to 48 cycles 3 to 51 cycles 1 to 48 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**PLOT** is a Super FX instruction that plots a single pixel. The X coordinate is specified by R1. The Y coordinate is specified by R2. The color is specified by COLOR or GETC.

The PLOT circuitry exists inside the Game Pak RAM Controller.

R1 is automatically incremented after the pixel is plotted.

The ALT0 state is restored.

#### Syntax

```
PLOT
```

### See Also

- RPIX

### External Links

- Official Nintendo documentation on PLOT: 9.72 on [Page 2-9-100 of Book II](https://archive.org/details/SNESDevManual/book2/page/n256)
- 8.1.3 "Plot Processing (Plot)" on [page 2-8-4](https://archive.org/details/SNESDevManual/book2/page/n143), lbid.
