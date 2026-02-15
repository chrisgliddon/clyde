---
title: "TSC"
reference_url: https://sneslab.net/wiki/TSC
categories:
  - "ASM"
  - "65c816_additions"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T16:59:47-08:00
cleaned_at: 2026-02-14T17:53:31-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 3B 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TSC** (Transfer Stack to Accumulator) is a 65c816 instruction that transfers the value of the stack pointer to the 16-bit accumulator. TSC always transfers two bytes. An alternate mnemonic is "TSA."

#### Syntax

```
TSC
TSA
```

TSC works even in emulation mode.

### See Also

- TSX
- TCS
- TDC
- PEA
- XBA

### External Links

- Eyes & Lichty, [page 515](https://archive.org/details/0893037893ProgrammingThe65816/page/515) on TSC
- Labiak, [page 196](https://archive.org/details/Programming_the_65816/page/n206) on TSC
- snes9x implementation of TSC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2345](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2345)
- [https://wilsonminesco.com/816myths/65c816\_myths-2\_BDD.pdf](https://wilsonminesco.com/816myths/65c816_myths-2_BDD.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.2](http://www.6502.org/tutorials/65c816opcodes.html#6.10.2)
