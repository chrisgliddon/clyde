---
title: "ENDX"
reference_url: https://sneslab.net/wiki/ENDX
categories:
  - "Audio"
  - "Registers"
downloaded_at: 2026-02-14T11:53:49-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

**ENDX** is an 8-bit DSPRAM register located at 7ch. Each bit represents one of the 8 voices. The S-DSP sets a voice's corresponding bit when BRR decoding of a block that has the source end flag set is completed.

When a voice is keyed on, its corresponding bit in ENDX is cleared.

If the S-SMP attempts to write to ENDX, all bits of ENDX are cleared.

### See Also

- EFB
- DIR
- OUTX
- ENVX

### Reference

- subparagraph 7.2.2.5 of [page 3-7-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n175) of the official Super Nintendo development manual
