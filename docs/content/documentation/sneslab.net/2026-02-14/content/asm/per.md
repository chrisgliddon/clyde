---
title: "PER"
reference_url: https://sneslab.net/wiki/PER
categories:
  - "Push_Instructions"
  - "Three-byte_Instructions"
  - "Six-cycle_Instructions"
downloaded_at: 2026-02-14T15:51:06-08:00
cleaned_at: 2026-02-14T17:52:40-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (PC Relative Long) 62 3 bytes 6 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**PER** (Push pc RElative indirect Address) is a 65c816 instruction that pushes a 16-bit sum to the stack. The addends are:

- the program counter after it has been incremented to point to the instruction following PER, and
- the 16-bit displacement following the PER opcode.

The high byte of the sum is pushed before the low byte. PER is useful in writing self-relocatable code.

No flags are affected. Neither the program bank register or program counter are modified either.

#### Syntax

```
PER label
PER #label
```

Assemblers that accept PER with the # syntax are rare.

PER works even in emulation mode.

### See Also

- PEA
- PEI
- return address

### External Links

- Eyes & Lichty, [page 475](https://archive.org/details/0893037893ProgrammingThe65816/page/475) on PER
- Labiak, [page 159](https://archive.org/details/Programming_the_65816/page/n169) on PER
- snes9x implementation of PER: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1685](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1685)
- undisbeliever on PER: [https://undisbeliever.net/snesdev/65816-opcodes.html#per-push-effective-pc-relative-indirect-address](https://undisbeliever.net/snesdev/65816-opcodes.html#per-push-effective-pc-relative-indirect-address)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.1](http://www.6502.org/tutorials/65c816opcodes.html#6.8.1)
