---
title: "TXY"
reference_url: https://sneslab.net/wiki/TXY
categories:
  - "ASM"
  - "65c816_additions"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:00:47-08:00
cleaned_at: 2026-02-14T17:53:36-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 9B 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TXY** is a 65c816 instruction that transfers the value of the X index register to the Y index register. TXY always transfers one or two bytes depending on how wide the index registers are. They are both always the same size. TXY always takes two cycles, regardless of whether one or two bytes are transferred.

#### Syntax

```
TXY
```

TXY works even in emulation mode where one byte is always transfered.

### See Also

- TYX
- TXA
- STX
- TXS

### External Links

- Eyes & Lichty, [page 519](https://archive.org/details/0893037893ProgrammingThe65816/page/519) on TXY
- Labiak, [page 200](https://archive.org/details/Programming_the_65816/page/n210) on TXY
- snes9x implementation of TXY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2424](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2424)
