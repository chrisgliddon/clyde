---
title: "HVCMODE"
reference_url: https://sneslab.net/wiki/HVCMODE
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Video"
  - "Pins"
downloaded_at: 2026-02-14T13:18:46-08:00
cleaned_at: 2026-02-14T17:54:16-08:00
---

**HVCMODE** appears to be a remnant of the planned (but scrapped) backwards compatibility with the NES, because the Super Famicom has the similarly named Nintendo identity code: SHVC. It is theorized that when switched to a high level, the HVCMODE pins were supposed to switch the Super Famicom into Famicom mode. There are three such pins, all grounded:

- 74 on the S-CPU
- 23 on the S-PPU1
- 98 on the S-PPU2

In 2010, d4s performed the following experiment on the HVCMODE pins:

1. hooking them all up to a switch
2. writing a test ROM
3. booting the SNES into normal SHVC mode
4. filling VRAM and CGRAM with garbage
5. writing to some NES display and sound register addresses in a loop
6. switching into HVC mode.

The screen immediately went black when HVC mode was enabled, but the SNES would continue exactly where it left off when switched back to normal SHVC mode. Therefore, d4s hypotheized that in HVC mode, either:

1. the PPU stops generating NMIs, or
2. the CPU is temporarily halted

d4s also tried toggling into HVCMODE while playing some normal SNES games, but did not investigate with an oscilloscope.

With these results, 6502freak also theorized:

- (3) the S-CPU switches to its /NMI pin (which is connected to VCC and thus is never triggered by vblank) upon entering HVC mode.
- (4) assuming (2), the PPU ignores Famicom register writes until the HVC pin is activated

### Reference

- [https://forums.nesdev.org/viewtopic.php?t=6474](https://forums.nesdev.org/viewtopic.php?t=6474)
