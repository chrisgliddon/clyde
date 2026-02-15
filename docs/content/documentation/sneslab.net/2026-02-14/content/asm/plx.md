---
title: "PLX"
reference_url: https://sneslab.net/wiki/PLX
categories:
  - "Pull_Instructions"
  - "One-byte_Instructions"
  - "Four-cycle_Instructions"
downloaded_at: 2026-02-14T15:53:00-08:00
cleaned_at: 2026-02-14T17:52:47-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Pull) FA 1 byte 4 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**PLX** (PulL X) is a 65x instruction that pulls the value at the top of the stack into the X index register. PLX increments the stack pointer before the pull.

The Labiak textbook seems to have omitted the fact that according to the datasheet, PLX affects the zero flag.

#### Syntax

```
PLX
```

#### Cycle Penalty

- PLX takes one additional cycle if the index registers are 16 bits wide.

### See Also

- PLY
- PLA
- PHX
- LDX

### External Links

- Eyes & Lichty, [page 487](https://archive.org/details/0893037893ProgrammingThe65816/page/487) on PLX
- Labiak, [page 171](https://archive.org/details/Programming_the_65816/page/n181) on PLX
- snes9x implementation of PLX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2156](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2156)
