---
title: "Non-Maskable Interrupt"
reference_url: https://sneslab.net/wiki/Non-Maskable_Interrupt
categories:
  - "SNES_Hardware"
  - "Official_Jargon"
downloaded_at: 2026-02-14T15:43:15-08:00
cleaned_at: 2026-02-14T17:52:31-08:00
---

A **non-maskable interrupt** (NMI) is an interrupt that cannot be ignored. The PPU normally generates an NMI at the beginning of the vertical blanking period, which is received by the Ricoh CPU. This is the only hardware NMI source on the SNES.\[2]

BRK causes a software NMI.

NMIs have higher priority than IRQs, but lower priority than Reset.

### See Also

- NMI Enable Flag
- SEI
- CLI
- DI
- EI
- BRK (SPC700)

### References

1. 7.19 Interrupt Priorities, page 53: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
2. [https://problemkaputt.de/fullsnes.htm#snesppuinterrupts](https://problemkaputt.de/fullsnes.htm#snesppuinterrupts)

### External Links

- snes9x implementation of NMI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2663](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2663)
