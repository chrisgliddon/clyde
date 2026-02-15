---
title: "PLB"
reference_url: https://sneslab.net/wiki/PLB
categories:
  - "ASM"
  - "65c816_additions"
  - "Pull_Instructions"
  - "One-byte_Instructions"
  - "Four-cycle_Instructions"
downloaded_at: 2026-02-14T15:52:14-08:00
cleaned_at: 2026-02-14T17:52:45-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Pull) AB 1 byte 4 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**PLB** (PulL data Bank) is a 65c816 instruction that pulls the byte at the top of the stack into the data bank register. PLB is the only instruction that modifies that register.\[1]\dubious, see [MVP and MVN] The stack pointer is incremented before the byte it points to is pulled into the register.

#### Syntax

```
PLB
```

PLB works even in emulation mode even though all bank addresses are forced to zero.\[5]

### See Also

- PLA
- PLD
- PLX
- PLY
- PHB

### External Links

1. Eyes & Lichty, [page 484](https://archive.org/details/0893037893ProgrammingThe65816/page/484) on PLB
2. Labiak, [page 168](https://archive.org/details/Programming_the_65816/page/n178) on PLB
3. snes9x implementation of PLB: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2032](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2032)
4. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
5. section 7.8.2 of 65c816 datasheet
