---
title: "BRL"
reference_url: https://sneslab.net/wiki/BRL
categories:
  - "Three-byte_Instructions"
  - "Four-cycle_Instructions"
  - "Relocatable_Instructions"
downloaded_at: 2026-02-14T11:05:32-08:00
cleaned_at: 2026-02-14T17:51:25-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative Long 82 3 bytes 4 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**BRL** (Branch Long) is a 65c816 instruction that performs an unconditional jump. The target can be anywhere within the current bank.

The 16 bit operand is not an absolute address, but a signed displacement from -32768 to 32767.

BRL is relocatable. No flags are affected.

#### Syntax

```
BRL label
```

BRL works even in emulation mode.

### See Also

- BRA
- JMP

### External Links

- Eyes & Lichty, [page 438](https://archive.org/details/0893037893ProgrammingThe65816/page/438) on BRL
- Labiak, [page 127](https://archive.org/details/Programming_the_65816/page/n137) on BRL
- snes9x implementation of BRL: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1405](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1405)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.2](http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.2)
