---
title: "APU Oscillator"
reference_url: https://sneslab.net/wiki/APU_Oscillator
categories:
  - "Audio"
  - "Timing"
downloaded_at: 2026-02-14T10:49:36-08:00
cleaned_at: 2026-02-14T17:54:06-08:00
---

The **APU oscillator** (X2) is clocked at 24.6 MHz, slightly faster than the master clock.

- Side 1 is XTALO, connected to pin 45 of the S-DSP and C72.
- Side 2 is XTALI, connected to pin 46 of the S-DSP and C71.

It is not connected to anything else. XTAL stands for "crystal," but according to a board photo\[3] X2 is actually a ceramic oscillator. It does not clock the S-SMP directly.

### See Also

- OSC
- Bit Clock

### References

1. [http://problemkaputt.de/fullsnes.htm#snestimingoscillators](http://problemkaputt.de/fullsnes.htm#snestimingoscillators)
2. [Figure 2-22-1 on page 2-22-2](https://archive.org/details/SNESDevManual/book1/page/n98) of the official Super Nintendo development manual
3. Sanglard, Fabien. The Hearts of the Super Nintendo. [https://fabiensanglard.net/snes\_hearts](https://fabiensanglard.net/snes_hearts)
