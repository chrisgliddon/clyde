---
title: "TDC"
reference_url: https://sneslab.net/wiki/TDC
categories:
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T16:58:23-08:00
cleaned_at: 2026-02-14T17:53:29-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 7B 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TDC** (Transfer Direct page register to aCcumulator) is a 65c816 instruction that transfers the value of the direct page register to the 16-bit accumulator. An alternate mnemonic is "TDA."

TDC ignores the m flag and always transfers 16 bits, even in 6502 emulation mode.

#### Syntax

```
TDC
TDA
```

TDC is a good way to zero the accumulator, but only works when the direct page has not be relocated, of course.

### See Also

- TCD
- PHD
- PLD
- XBA

### External Links

- Eyes & Lichty, [page 512](https://archive.org/details/0893037893ProgrammingThe65816/page/512) on TDC
- Labiak, [page 193](https://archive.org/details/Programming_the_65816/page/n203) on TDC
- snes9x implementation of TDC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2337](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2337)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.2](http://www.6502.org/tutorials/65c816opcodes.html#6.10.2)
