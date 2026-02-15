---
title: "CPUK"
reference_url: https://sneslab.net/wiki/CPUK
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Timing"
downloaded_at: 2026-02-14T11:24:11-08:00
cleaned_at: 2026-02-14T17:54:10-08:00
---

**CPUK** is the S-SMP's clock signal, which oscillates at 2.048 MHz with a 50% duty cycle. It is produced by the S-DSP and output on its pin 48, then goes into pin 16 of the S-SMP. It does not connect to anything else.

The official dev manual has a typo that states that the speed is 2.48 MHz. \[2]

### See Also

- Master Clock
- APU Oscillator

### External Links

1. [https://archive.nes.science/nesdev-forums/f12/t10458.xhtml](https://archive.nes.science/nesdev-forums/f12/t10458.xhtml)
2. [Page 3-1-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n152) of the official Super Nintendo development manual
