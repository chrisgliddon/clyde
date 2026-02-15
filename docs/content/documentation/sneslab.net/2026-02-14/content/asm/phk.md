---
title: "PHK"
reference_url: https://sneslab.net/wiki/PHK
categories:
  - "Push_Instructions"
  - "One-byte_Instructions"
  - "Three-cycle_Instructions"
downloaded_at: 2026-02-14T15:51:37-08:00
cleaned_at: 2026-02-14T17:52:42-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 4B 1 byte 3 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**PHK** (Push Program BanK) is a 65c816 instruction that pushes the value of the program bank register onto the stack. PHK always pushes a single byte. The stack pointer is decremented by one.

No flags are affected.

#### Syntax

```
PHK
```

Its PLK counterpart does not exist. PHK works even in emulation mode even though all bank addresses are forced to be zero.\[5]

### See Also

- PHB
- PHD
- PHA
- PHX
- PHY

### External Links

1. Eyes & Lichty, [page 479](https://archive.org/details/0893037893ProgrammingThe65816/page/479) on PHK
2. Labiak, [page 163](https://archive.org/details/Programming_the_65816/page/n173) on PHK
3. snes9x implementation of PHK: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1813](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1813)
4. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
5. section 7.8.2 of 65c816 datasheet
