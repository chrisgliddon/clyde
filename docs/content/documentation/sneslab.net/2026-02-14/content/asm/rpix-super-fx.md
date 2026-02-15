---
title: "RPIX (Super FX)"
reference_url: https://sneslab.net/wiki/RPIX_(Super_FX)
categories:
  - "Super_FX"
  - "Plot-related_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T16:10:05-08:00
cleaned_at: 2026-02-14T17:52:57-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D4C 2 byte 24 to 80 cycles 24 to 78 cycles 20 to 74 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**RPIX** (Read PIXel) is a Super FX instruction that loads a color from the Game Pak RAM and stores it in the destination register. It does this by first loading the color into the color matrix and converting it from PPU format.

The X coordinate is specified by R1 and the Y coordinate is specified by R2.

The ALT0 state is restored.

#### Syntax

```
RPIX
```

### See Also

- PLOT
- COLOR
- GETC
- Pixel Cache
- ALT1

### External Links

- Official Nintendo documentation on RPIX: 9.77 on [Page 2-9-107 of Book II](https://archive.org/details/SNESDevManual/book2/page/n263)
- 8.1.3.3 RPIX INSTRUCTION on [page 2-8-9 of Book II](https://archive.org/details/SNESDevManual/book2/page/n148), lbid.
