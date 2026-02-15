---
title: "PHD"
reference_url: https://sneslab.net/wiki/PHD
categories:
  - "ASM"
  - "65c816_additions"
  - "One-byte_Instructions"
  - "Four-cycle_Instructions"
  - "Push_Instructions"
downloaded_at: 2026-02-14T15:51:26-08:00
cleaned_at: 2026-02-14T17:52:41-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 0B 1 byte 4 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**PHD** (PusH Direct Page) is a 65c816 instruction that pushes the value of the direct page register onto the stack. The high byte is pushed before the low byte. The stack pointer is decremented by two.

No flags are affected.

#### Syntax

```
PHD
```

PHD works even in emulation mode, and will not push zero if the direct page has been relocated, as instructions that used zero page addressing on the 6502 will use direct page addressing instead with the direct offset still added into their effective address.

### See Also

- PLD
- PHB
- TDC
- PHK

### External Links

- Eyes & Lichty, [page 478](https://archive.org/details/0893037893ProgrammingThe65816/page/478) on PHD
- Labiak, [page 162](https://archive.org/details/Programming_the_65816/page/n172) on PHD
- snes9x implementation of PHD: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1786](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1786)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
