---
title: "TCD"
reference_url: https://sneslab.net/wiki/TCD
categories:
  - "ASM"
  - "65c816_additions"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T16:57:28-08:00
cleaned_at: 2026-02-14T17:53:27-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 5B 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TCD** (Transfer aCcumulator to Direct page register) is a 65c816 instruction that transfers the value of the 16-bit accumulator to the direct page register. An alternate mnemonic is "TAD."

TCD ignores the m flag. If the accumulator is only 8 bits wide, the transfer still happens as if it were 16 bits wide.

TCD works even in 6502 emulation mode.

#### Syntax

```
TCD
TAD
```

### See Also

- TDC
- PHD
- PLD
- XBA
- TCS

### External Links

- Eyes & Lichty, [page 510](https://archive.org/details/0893037893ProgrammingThe65816/page/510) on TCD
- Labiak, [page 191](https://archive.org/details/Programming_the_65816/page/n201) on TCD
- snes9x implementation of TCD: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2320](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2320)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.2](http://www.6502.org/tutorials/65c816opcodes.html#6.10.2)
