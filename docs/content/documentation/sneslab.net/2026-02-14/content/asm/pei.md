---
title: "PEI"
reference_url: https://sneslab.net/wiki/PEI
categories:
  - "Push_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T15:51:03-08:00
cleaned_at: 2026-02-14T17:52:39-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Direct Page Indirect) D4 2 bytes 6 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**PEI** (Push Effective Indirect address) is a 65c816 instruction that pushes a 16-bit value to the stack. This value need not actually be an address. This value is found at the address formed by adding the operand byte to the direct page register. The high byte (found at the effective address plus one) is pushed first, then the low byte.

No flags are affected.

PEI works even in emulation mode.

#### Syntax

```
PEI (dp)
PEI dp
```

##### Cycle Penalty

- PEI takes one extra cycle if the low byte of the direct page register is nonzero.

### See Also

- PEA
- PER
- PHA

### External Links

- Eyes & Lichty, [page 474](https://archive.org/details/0893037893ProgrammingThe65816/page/474) on PEI
- Labiak, [page 158](https://archive.org/details/Programming_the_65816/page/n168) on PEI
- snes9x implementation of PEI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1658](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1658)
- undisbeliever on PEI: [https://undisbeliever.net/snesdev/65816-opcodes.html#pei-push-effective-indirect-address](https://undisbeliever.net/snesdev/65816-opcodes.html#pei-push-effective-indirect-address)
- how PEI behaves in emulation mode - section 7.2 of 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.1](http://www.6502.org/tutorials/65c816opcodes.html#6.8.1)
