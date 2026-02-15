---
title: "TYX"
reference_url: https://sneslab.net/wiki/TYX
categories:
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:01:07-08:00
cleaned_at: 2026-02-14T17:53:38-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) BB 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TYX** is a 65c816 instruction that transfers the value of the Y index register to the X index register. The x flag determines whether 8 or 16 bits are transferred. TYX always takes two cycles, regardless of whether one or two bytes are transferred.

The negative flag will then match the most significant bit of the transferred value. The zero flag will indicate whether the transferred value is zero (set if zero).

#### Syntax

```
TYX
```

TYX works even in emulation mode where one byte is always transferred.

### See Also

- TXY
- TYA
- STY

### External Links

- Eyes & Lichty, [page 521](https://archive.org/details/0893037893ProgrammingThe65816/page/521) on TYX
- Labiak, [page 202](https://archive.org/details/Programming_the_65816/page/n212) on TYX
- snes9x implementation of TYX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2486](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2486)
