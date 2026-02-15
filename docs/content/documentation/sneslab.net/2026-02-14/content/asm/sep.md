---
title: "SEP"
reference_url: https://sneslab.net/wiki/SEP
categories:
  - "ASM"
  - "Two-byte_Instructions"
  - "Three-cycle_Instructions"
downloaded_at: 2026-02-14T16:21:27-08:00
cleaned_at: 2026-02-14T17:53:06-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate E2 2 bytes 3 cycles

Flags Affected N V M X D I Z C emulation mode N V . . D I Z C native mode N V M X D I Z C

**SEP** (Set Status Bits) is a 65c816 instruction that sets bits in the status register that correspond to set bits in the operand.

SEP is the only way to set the m and x flags directly without disturbing the stack (but PLP and RTI may set them too.)\[1] But, SEP can't modify those two flags in emulation mode because they are being forced to be set.\[6]

#### Syntax

```
SEP #%nvmxdizc
```

If you only want to set one flag, SED, SEI, or SEC are smaller/faster than SEP. Early 65c816 chips had a timing problem with SEP and REP which required a NOP to be inserted after them, or to stretch the clock.\[5]

### See Also

- TSB
- Derailment

### References

1. Eyes & Lichty, [page 502](https://archive.org/details/0893037893ProgrammingThe65816/page/502) on SEP
2. Labiak, [page 183](https://archive.org/details/Programming_the_65816/page/n193) on SEP
3. snes9x implementation of SEP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3203](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3203)
4. undisbeliever on SEP: [https://undisbeliever.net/snesdev/65816-opcodes.html#sep-set-status-bits](https://undisbeliever.net/snesdev/65816-opcodes.html#sep-set-status-bits)
5. [http://forum.6502.org/viewtopic.php?f=4&t=5196](http://forum.6502.org/viewtopic.php?f=4&t=5196)
6. section 2.8 "Processor Status Register (P)" of 65c816 datasheet
