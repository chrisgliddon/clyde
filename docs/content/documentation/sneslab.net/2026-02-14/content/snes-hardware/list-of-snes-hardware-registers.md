---
title: "List of SNES hardware registers"
reference_url: https://sneslab.net/wiki/List_of_SNES_hardware_registers
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T13:42:17-08:00
cleaned_at: 2026-02-14T17:54:18-08:00
---

This is a list of all the hardware registers used by the SNES (including some enhancement chips) and what they are used for. **This list is incomplete.**

Native SNES registers Register Register name/use Size (8/16-bit) Write (once/twice) Bits Usage $2100 Screen Display 8-bit Write-once f---bbbb Bits 0-3: Screen brightness. 0000 is completely black, 1111 is maximum brightness. Bits 4-6: Unused. Bit 7: Force blank. Setting this bit will turn force blank on, which turns the screen display off. $2101 Object Size and Chr Address 8-bit Write-once sssnnbbb Bits 0-2: Name base select. Bits 3-4: Name select. Bits 5-7: Object size.

```
 000: 8x8/16x16 sprites
```

SA-1 registers

You should probably see [http://wiki.superfamicom.org/snes/show/SA-1+Registers](http://wiki.superfamicom.org/snes/show/SA-1+Registers) instead. GSU-1 (SuperFX) registers

To be filled in. GSU-2 (SuperFX) registers

To be filled in. DSP-1 registers

To be filled in. DSP-2 registers

To be filled in. DSP-3 registers

To be filled in. DSP-4 registers

To be filled in. CX4 registers

To be filled in. MSU-1 registers Write registers Register Register name/use Size Bits Usage $2000 Data port 32-bit - Controls the position in the data file. Writing to $2003 sets the D bit in $2000 for a while. $2004 Audio track 16-bit - Sets the current audio track and stops playback if a previous track was playing. Writing to $2005 sets the A bit in $2000 for a while. $2006 Audio volume 8-bit - Sets the volume for audio playback (linear scale: 0 = 0%, 255 = 100%). $2007 Audio state 8-bit 000000rp

r=Audio repeat flag. Mirrored to $2000. p=Audio playing flag. Mirrored to $2000. Writes have no effect if the A bit of $2000 is set. Read registers Register Register name/use Size Bits Usage $2000 Status port 8-bit darpvvvv

d=Data port busy. While this is set, you'll get only #$00 from $2001. a=Audio port busy. While this is set, no sound is playing. r=Audio repeat flag. Mirrors the flag in $2007. p=Audio playing flag. Mirrors the flag in $2007. vvvv=Version. Always 1. $2001 Stream port 8-bit - Returns one byte from the data file. $2002 Identification 48-bit - Returns "S-MSU1" (53 2D 4D 53 55 31).
