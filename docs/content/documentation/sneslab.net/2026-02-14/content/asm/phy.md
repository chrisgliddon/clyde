---
title: "PHY"
reference_url: https://sneslab.net/wiki/PHY
categories:
  - "ASM"
  - "65c02_additions"
  - "Push_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:51:52-08:00
cleaned_at: 2026-02-14T17:52:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 5A 1 byte 3 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**PHY** is a 65c816 instruction that pushes the value of the Y index register onto the stack. If Y is 16 bits wide, the high byte is pushed first.

The stack pointer is decremented by the number of bytes Y is.

No flags are affected.

#### Syntax

```
PHY
```

#### Cycle Penalty

- PHY takes one additional cycle if the index registers are 16 bits wide.

### See Also

- PHX
- PHA
- PLY
- STY

### External Links

- Eyes & Lichty, [page 482](https://archive.org/details/0893037893ProgrammingThe65816/page/482) on PHY
- Labiak, [page 166](https://archive.org/details/Programming_the_65816/page/n176) on PHY
- snes9x implementation of PHY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1921](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1921)
