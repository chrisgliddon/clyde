---
title: "STP"
reference_url: https://sneslab.net/wiki/STP
categories:
  - "ASM"
  - "65c02_additions"
  - "One-byte_Instructions"
  - "Control_Instructions"
  - "Implied_Instructions"
  - "Three-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:39:59-08:00
cleaned_at: 2026-02-14T17:53:18-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3) DB 1 byte 3 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**STP** (SToP-the-clock)\[1] is an instruction that halts the 65c816, putting it into a low power state until it is reset. The PHI2 clock is held high.

No flags are affected.

Recall that the cartridge slot and expansion port can both reset the control deck.

#### Syntax

```
STP
```

Eyes & Lichty (at the bottom of page 504) claims that STP was first introduced on the 65802/816, but it is on the 65c02 datasheet.

### See Also

- WAI
- NOP
- WDM
- STOP (SPC700)
- STOP (Super FX)
- Reset Traces

### External Links

- Eyes & Lichty, [page 504](https://archive.org/details/0893037893ProgrammingThe65816/page/504) on STP
- Labiak, [page 185](https://archive.org/details/Programming_the_65816/page/n195) on STP
- snes9x implementation of STP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3328](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3328)
- undisbeliever on STP: [https://undisbeliever.net/snesdev/65816-opcodes.html#stp-stop-the-processor](https://undisbeliever.net/snesdev/65816-opcodes.html#stp-stop-the-processor)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.9](http://www.6502.org/tutorials/65c816opcodes.html#6.9)

### References

1. Although "Stop The Processor" fits, all the letters in this mnemonic are from the word "stop." See row 58 of Table 5-1, "Instruction Set Table" on Page 21 of the official 65c02 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c02s.pdf)
