---
title: "Table of Gain Modes"
reference_url: https://sneslab.net/wiki/Table_of_Gain_Modes
categories:
  - "Audio"
downloaded_at: 2026-02-14T17:01:23-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

The S-DSP has five gain modes, to which Nintendo gave official names\[1], but they are numbered differently by different emulator authors.

nocash numbers the gain modes with bits 5 & 6 of VxGAIN.\[2] Note that direct gain mode uses these bits for the fixed volume instead and thus has no number in this scheme.

[Near](/mw/index.php?title=Near&action=edit&redlink=1 "Near (page does not exist)") numbers the gain modes with the top 3 bits of ADSR(1).\[3] Note that when bit 7 is clear, bits 5 & 6 are "don't care" and thus Modes 0-3 are actually all the same - direct gain.

Official Nintendo Name nocash numbering/naming Near numbering/naming **Direct Designation** Direct Gain Modes 0-3 (direct) **Increase Mode (Linear)** Mode 2 = Linear Increase Mode 6 (linear increase) **Increase Mode (Bent Line)** Mode 3 = Bent Increase Mode 7 (two-slope linear increase) **Decrease Mode (Linear)** Mode 0 = Linear Decrease Mode 4 (linear decrease) **Decrease Mode (Exponential)** Mode 1 = Exp Decrease Mode 5 (exponential decrease)

### References

1. [page 3-7-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n170), "GAIN" of the official Super Nintendo development manual
2. [https://problemkaputt.de/fullsnes.htm#snesapudspadsrgainenvelope](https://problemkaputt.de/fullsnes.htm#snesapudspadsrgainenvelope)
3. [https://github.com/ares-emulator/ares/blob/master/ares/sfc/dsp/envelope.cpp](https://github.com/ares-emulator/ares/blob/master/ares/sfc/dsp/envelope.cpp)
