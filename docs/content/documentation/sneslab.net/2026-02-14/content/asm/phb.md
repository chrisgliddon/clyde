---
title: "PHB"
reference_url: https://sneslab.net/wiki/PHB
categories:
  - "ASM"
  - "65c816_additions"
  - "Push_Instructions"
  - "One-byte_Instructions"
  - "Three-cycle_Instructions"
downloaded_at: 2026-02-14T15:51:15-08:00
cleaned_at: 2026-02-14T17:52:41-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 8B 1 byte 3 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**PHB** (PusH data Bank register) is a 65c816 instruction that pushes the value of the data bank register to the stack. PHB always pushes one byte. The stack pointer is decremented by one and ends up pointing directly below the byte pushed.

No flags are affected.

#### Syntax

```
PHB
```

PHB works even in emulation mode even though all bank addresses are forced to zero.\[4]

### See Also

- PHD
- PHK
- PLB

### External Links

1. Eyes & Lichty, [page 477](https://archive.org/details/0893037893ProgrammingThe65816/page/477) on PHB
2. Labiak, [page 161](https://archive.org/details/Programming_the_65816/page/n171) on PHB
3. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
4. section 7.8.2 of 65c816 datasheet
