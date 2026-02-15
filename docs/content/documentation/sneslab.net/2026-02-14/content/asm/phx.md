---
title: "PHX"
reference_url: https://sneslab.net/wiki/PHX
categories:
  - "Push_Instructions"
  - "One-byte_Instructions"
  - "Three-cycle_Instructions"
downloaded_at: 2026-02-14T15:51:48-08:00
cleaned_at: 2026-02-14T17:52:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) DA 1 byte 3 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**PHX** is a 65c816 instruction that pushes the value of the X index register onto the stack. If X is 16 bits wide, the high byte is pushed first.

The stack pointer is decremented by the number of bytes X is.

No flags are affected.

#### Syntax

```
PHX
```

#### Cycle Penalty

- PHX takes one additional cycle if the index registers are 16 bits wide.

### See Also

- PHY
- PHA
- PLX
- STX

### External Links

- Eyes & Lichty, [page 481](https://archive.org/details/0893037893ProgrammingThe65816/page/481) on PHX
- Labiak, [page 165](https://archive.org/details/Programming_the_65816/page/n175) on PHX
- snes9x implementation of PHX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1878](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1878)
