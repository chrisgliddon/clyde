---
title: "S-DSP"
reference_url: https://sneslab.net/wiki/S-DSP
categories:
  - "SNES_Hardware"
  - "Audio"
  - "ICs_with_unconnected_pins"
  - "Integrated_Circuits"
downloaded_at: 2026-02-14T16:15:00-08:00
cleaned_at: 2026-02-14T17:54:33-08:00
---

The **S-DSP** is the digital signal processor. It produces audio for the DAC and is controlled by the S-SMP. It is clocked by X2.

It has 128 registers (DSPRAM) that can be manipulated by the S-SMP, some of which serve no hard-wired purpose and can be used as general-purpose RAM. Registers with a ∴ before their name are written to by the S-DSP itself during active processing. Here are some of 128:

Address Register 00 VOL (L) 01 VOL (R) 02 P (L) 03 P (H) 04 SRCN 05 ADSR (1) 06 ADSR (2) 07 GAIN 08 ∴ENVX 09 ∴OUTX 0C MVOL (L) 1C MVOL (R) 2C EVOL (L) 3C EVOL (R) 4C KON 5C KOF 6C FLG 7C ∴ENDX 0D EFB 1D --- 2D PMON 3D NON 4D EON 5D DIR 6D ESA 7D EDL xE ---

Many of the 128 registers appear to not be used by the S-DSP directly, but get copied to internal registers the S-SMP does not have access to. The highest sound frequency that the S-DSP can produce is 16kHz, because of the 32kHz rate that sample-points are output. \[1]

The arrowhead for pin 47 on the jwdonal schematic seems to be pointing the wrong way.

### References

1. [https://problemkaputt.de/fullsnes.htm#snesapudspbrrpitch](https://problemkaputt.de/fullsnes.htm#snesapudspbrrpitch)
2. [page 3-7-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n167) of the official Super Nintendo development manual
3. subparagraph 22.5.2 on [page 2-22-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n97), lbid.
