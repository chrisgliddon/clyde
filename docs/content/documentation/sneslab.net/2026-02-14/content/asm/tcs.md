---
title: "TCS"
reference_url: https://sneslab.net/wiki/TCS
categories:
  - "ASM"
  - "65c816_additions"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T16:57:48-08:00
cleaned_at: 2026-02-14T17:53:28-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 1B 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**TCS** (Transfer Accumulator to Stack Pointer) is a 65c816 instruction that transfers the value of the accumulator to the stack pointer. An alternative mmenonic for this instruction is "TAS." TCS always transfers 16 bits in native mode and 8 bits in emulation mode. TCS ignores the M flag. TCS always takes two cycles, regardless of whether one or two bytes are transferred.

No flags are affected.

#### Syntax

```
TCS
TAS
```

### See Also

- TXS
- TSC
- TCD
- TAX
- TAY
- XBA

### External Links

- Eyes & Lichty, [page 511](https://archive.org/details/0893037893ProgrammingThe65816/page/511) on TCS
- Labiak, [page 192](https://archive.org/details/Programming_the_65816/page/n202) on TCS
- snes9x implementation of TCS: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2328](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2328)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.2](http://www.6502.org/tutorials/65c816opcodes.html#6.10.2)
