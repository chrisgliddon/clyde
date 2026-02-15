---
title: "PEA"
reference_url: https://sneslab.net/wiki/PEA
categories:
  - "ASM"
downloaded_at: 2026-02-14T15:50:56-08:00
cleaned_at: 2026-02-14T17:52:39-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (absolute) F4 3 bytes 5 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**PEA** (Push Effective Address) is a 65c816 instruction that pushes a 16-bit value to the stack. This value need not actually be an address. The stack pointer is decremented by two.

PEA can be thought of as using immediate addressing, although the immediate syntax is not used.

PEA ignores the state of the m and x flags. No flags are affected.

#### Syntax

```
PEA addr
PEA const
```

PEA works even in emulation mode.

### See Also

- PER
- PEI
- PHA
- TSC
- XBA

### External Links

- Eyes & Lichty, [page 473](https://archive.org/details/0893037893ProgrammingThe65816/page/473) on PEA
- Labiak, [page 157](https://archive.org/details/Programming_the_65816/page/n167) on PEA
- snes9x implementation of PEA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1631](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1631)
- undisbeliever on PEA: [https://undisbeliever.net/snesdev/65816-opcodes.html#pea-push-effective-absolute-address](https://undisbeliever.net/snesdev/65816-opcodes.html#pea-push-effective-absolute-address)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.1](http://www.6502.org/tutorials/65c816opcodes.html#6.8.1)
- [https://wilsonminesco.com/816myths/65c816\_myths-2\_BDD.pdf](https://wilsonminesco.com/816myths/65c816_myths-2_BDD.pdf)
