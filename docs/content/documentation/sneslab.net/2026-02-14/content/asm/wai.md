---
title: "WAI"
reference_url: https://sneslab.net/wiki/WAI
categories:
  - "One-byte_Instructions"
  - "Control_Instructions"
  - "Implied_Instructions"
  - "Three-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T17:16:37-08:00
cleaned_at: 2026-02-14T17:53:40-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3) CB 1 byte 3 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**WAI** (WAit for Interrupt) is a 65x instruction that waits until an interrupt is received. The processor consumes less power while waiting. The RDY pin is pulled low during the third cycle and the bus is freed up. The interrupt is serviced immediately.

If the interrupt disable flag is set, then the way servicing occurs is for control to simply fall through to the instruction following WAI. This is a very efficient way to service because the ISR is inlined and there is no need to RTI.

If that flag is clear, control instead jumps through a vector into the interrupt handler. Use RTI at the end of this ISR to return control to the instruction following WAI.

No flags are affected.

#### Syntax

```
WAI
```

Eyes & Lichty (at the bottom of page 522) claims that WAI was first introduced on the 65802/816, but it is on the 65c02 datasheet.

### See Also

- IRQ
- STP
- NOP
- SLEEP
- BE
- Interrupt Disable Flag
- SEI
- CLI

### External Links

- Eyes & Lichty, [page 522](https://archive.org/details/0893037893ProgrammingThe65816/page/522) on WAI
- Labiak, [page 203](https://archive.org/details/Programming_the_65816/page/n213) on WAI
- snes9x implementation of WAI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3313](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3313)
- undisbeliever on WAI: [https://undisbeliever.net/snesdev/65816-opcodes.html#wai-wait-for-interrupt](https://undisbeliever.net/snesdev/65816-opcodes.html#wai-wait-for-interrupt)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.9](http://www.6502.org/tutorials/65c816opcodes.html#6.9)
