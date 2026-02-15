---
title: "S-DSP/Pitch Counter"
reference_url: https://sneslab.net/wiki/S-DSP/Pitch_Counter
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T16:15:51-08:00
cleaned_at: 2026-02-14T17:54:32-08:00
---

The **Pitch Counter** is a hidden register (not part of DSPRAM) that the S-DSP is modifying at the speed of 32kHz. It is at least 15 bits wide, of which:

- bits 4-11 are used as an index into the gaussian interpolation table (in one place fullsnes says bit 3 is used to index as well)
- bits 12-15 indicate which 4-bit sample-point within a BRR block

### See Also

- The Infamous Bit-Of-Confusion

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesapudspbrrpitch](https://problemkaputt.de/fullsnes.htm#snesapudspbrrpitch)
