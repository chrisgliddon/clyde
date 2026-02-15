---
title: "REP"
reference_url: https://sneslab.net/wiki/REP
categories:
  - "ASM"
  - "65c816_additions"
  - "Two-byte_Instructions"
  - "Three-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:05:32-08:00
cleaned_at: 2026-02-14T17:52:53-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate C2 2 bytes 3 cycles

Flags Affected N V M X D I Z C emulation mode N V . . D I Z C native mode N V M X D I Z C

**REP** (Reset Status Bits) is a 65c816 instruction that clears bits in the status register that correspond to set bits in the operand.

REP is the only way to clear the m and x flags directly without disturbing the stack (but PLP and RTI may clear them too.)\[1] But, REP can't clear those two flags in emulation mode because they are being forced to be set.\[6]

#### Syntax

```
REP #%nvmxdizc
```

If you only want to clear one flag, CLC, CLV, CLD, and CLI are smaller/faster than REP. Early 65c816 chips had a timing problem with REP and SEP which required a NOP to be inserted after them, or to stretch the clock.\[5]

### See Also

- TRB
- Derailment

### References

1. Eyes & Lichty, [page 489](https://archive.org/details/0893037893ProgrammingThe65816/page/489) on REP
2. Labiak, [page 173](https://archive.org/details/Programming_the_65816/page/n183) on REP
3. snes9x implementation of REP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3145](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3145)
4. undisbeliever on REP: [https://undisbeliever.net/snesdev/65816-opcodes.html#rep-reset-status-bits](https://undisbeliever.net/snesdev/65816-opcodes.html#rep-reset-status-bits)
5. [http://forum.6502.org/viewtopic.php?f=4&t=5196](http://forum.6502.org/viewtopic.php?f=4&t=5196)
6. section 2.8 "Processor Status Register (P)" of 65c816 datasheet
