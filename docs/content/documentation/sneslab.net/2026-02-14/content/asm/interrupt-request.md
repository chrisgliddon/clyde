---
title: "Interrupt Request"
reference_url: https://sneslab.net/wiki/Interrupt_Request
categories:
  - "ASM"
  - "Official_Jargon"
downloaded_at: 2026-02-14T13:29:50-08:00
cleaned_at: 2026-02-14T17:52:07-08:00
---

An **interrupt request** (IRQ) is an interrupt that can be ignored. It has the lowest priority out of all the interrupts. \[2]

IRQs can go into the Control Deck through both the Cartridge Slot and the Expansion Port.

The S-SMP has no hardware interrupt sources, but if it did, EI and DI would be useful.

### See Also

- Break Flag
- NMI
- IRQ Flag
- SEI
- CLI
- BRK
- RTI

### External Links

1. snes9x implementation of IRQ: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2588](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2588)
2. 65c816 datasheet
3. [https://problemkaputt.de/fullsnes.htm#snesppuinterrupts](https://problemkaputt.de/fullsnes.htm#snesppuinterrupts)
