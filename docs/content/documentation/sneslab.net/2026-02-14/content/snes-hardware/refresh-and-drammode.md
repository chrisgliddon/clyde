---
title: "REFRESH and DRAMMODE"
reference_url: https://sneslab.net/wiki/REFRESH_and_DRAMMODE
categories:
  - "SNES_Hardware"
  - "Traces"
downloaded_at: 2026-02-14T16:05:29-08:00
cleaned_at: 2026-02-14T17:54:29-08:00
---

The **REFRESH** line keeps DRAM from forgetting. It comes out of pin 40 of the S-CPU. It goes into:

- pin 7 of S-WRAM
- pin 33 of the Cartridge Slot

The S-CPU is paused for 40 master cycles while a REFRESH happens. \[2]

/**DRAMMODE** is the name of pin 49 on the S-CPU, tied directly to ground (low).

In 2010, 6502freak theorized that setting this pin high disables the refresh cycle logic and frees up CPU time.

In 2013, nocash tested Donkey Kong Country with /DRAMMODE high. The game ran normally, so he hypothesized that when setting REFRESH low the game would still work too.

### See Also

- SRAM

### References

1. [https://forums.nesdev.org/viewtopic.php?p=62572#p62572](https://forums.nesdev.org/viewtopic.php?p=62572#p62572)
2. [https://problemkaputt.de/fullsnes.htm#snestimingoscillators](https://problemkaputt.de/fullsnes.htm#snestimingoscillators)
