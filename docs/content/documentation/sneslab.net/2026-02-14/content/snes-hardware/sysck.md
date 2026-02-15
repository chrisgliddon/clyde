---
title: "SYSCK"
reference_url: https://sneslab.net/wiki/SYSCK
categories:
  - "SNES_Hardware"
  - "Traces"
downloaded_at: 2026-02-14T16:41:21-08:00
cleaned_at: 2026-02-14T17:54:37-08:00
---

**SYSCK** (System Clock) is a signal that is produced by the S-CPU, coming out of pin 72. It goes into:

- pin 6 of WRAM.
- pin pad 57 of the Cartridge Slot (both 46-pin and 62-pin cartridges have this pin)

According to the jwdonal schematic, it is most likely the current memory access cycle clock.

### See Also

- Master Clock
- FastROM
- SlowROM
