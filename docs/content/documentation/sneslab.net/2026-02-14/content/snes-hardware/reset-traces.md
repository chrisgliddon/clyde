---
title: "Reset Traces"
reference_url: https://sneslab.net/wiki/Reset_Traces
categories:
  - "SNES_Hardware"
  - "Traces"
downloaded_at: 2026-02-14T16:13:37-08:00
cleaned_at: 2026-02-14T17:54:29-08:00
---

The SNES has a few traces used in system resetting:

/**RESOUT0** allows S-PPU2 to reset S-PPU1. It is produced by pin 33 of PPU2 and goes into pin 98 (/RESET) of PPU1. It is not connected to anything else.

/**RESOUT1** is produced by pin 28 of S-PPU2 and passes through R74 before combining with the voltage supervisor reset output. Then, /RESOUT1 goes into these pins, all of which are labled /RESET:

- S-CPU pin 50
- WRAM pin 8
- Cartridge Slot pin 26
- S-SMP pin 37
- Expansion Port pin 19
- S-DSP pin 47

The trace (not pin) labeled /**RESET** on the jwdonal schematic is produced by pin 10 (P10) of the CIC and is what actually resets PPU2 (going into pin 34).

### See Also

- Reset Button
- STP
