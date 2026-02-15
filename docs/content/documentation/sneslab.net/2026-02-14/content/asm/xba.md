---
title: "XBA"
reference_url: https://sneslab.net/wiki/XBA
categories:
  - "Exchange_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Three-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T17:19:49-08:00
cleaned_at: 2026-02-14T17:53:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) EB 1 byte 3 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**XBA** is a 65c816 instruction that exchanges the values of the high byte (B) and low byte (typically called A) of the C accumulator. It works even in 6502 emulation mode. In 65816 native mode, its standard mnemonic is still "XBA" even when the accumulator is 16-bits wide. An alternative mnemonic is "SWA."

XBA can be used to convert big endian data to little endian and vice versa. XBA appears to be the only direct way to access the high B byte when the M flag is set without losing any register values, with TCD, TCS, TAX, and TAY providing less direct access.

The negative flag will match the most significant bit of the new low byte (A) of the accumulator. The zero flag will be set if and only if the new low byte (A) of the accumulator is zero, otherwise it is cleared. In other words, XBA ignores the M flag.

#### Syntax

```
XBA
SWA
```

Even though the hidden B byte is colloquially considered to be a second, more limited accumulator, XBA still isn't considered to use accumulator addressing. As of 2025 it is unknown whether XBA uses register renaming, but it would be surprising if it did because it should only take two cycles to flip a flip-flop.

### See Also

- XCE
- XCN
- SWAP

### External Links

- Eyes & Lichty, [page 524](https://archive.org/details/0893037893ProgrammingThe65816/page/524) on XBA
- Labiak, [page 204](https://archive.org/details/Programming_the_65816/page/n214) on XBA
- snes9x implementation of XBA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3261](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3261)
- undisbeliever on XBA: [https://undisbeliever.net/snesdev/65816-opcodes.html#xba-exchange-the-b-and-a-accumulators](https://undisbeliever.net/snesdev/65816-opcodes.html#xba-exchange-the-b-and-a-accumulators)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.3](http://www.6502.org/tutorials/65c816opcodes.html#6.10.3)
