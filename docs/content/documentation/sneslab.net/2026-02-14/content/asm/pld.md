---
title: "PLD"
reference_url: https://sneslab.net/wiki/PLD
categories:
  - "Pull_Instructions"
  - "Five-cycle_Instructions"
downloaded_at: 2026-02-14T15:52:27-08:00
cleaned_at: 2026-02-14T17:52:45-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Pull) 2B 1 byte 5 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**PLD** (PulL Direct page) is a 65c816 instruction that pulls the 16-bit value at the top of the stack into the direct page register, relocating the direct page. The low byte of this register is pulled first and then the high byte. The stack pointer is incremented by two and ends up pointing to where the high byte was, which becomes the next available stack location.

#### Syntax

```
PLD
```

PLD works even in emulation mode, and instructions that used zero page addressing on the 6502 will use direct page addressing instead with the direct offset still added into their effective address.

### See Also

- PHD
- PLB
- PLX
- PLY
- TCD

### External Links

- Eyes & Lichty, [page 485](https://archive.org/details/0893037893ProgrammingThe65816/page/485) on PLD
- Labiak, [page 169](https://archive.org/details/Programming_the_65816/page/n179) on PLD
- snes9x implementation of PLD: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2069](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2069)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
