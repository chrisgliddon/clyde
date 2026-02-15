---
title: "S-DSP/Global Counter"
reference_url: https://sneslab.net/wiki/S-DSP/Global_Counter
categories:
  - "SNES_Hardware"
  - "Audio"
  - "Timing"
downloaded_at: 2026-02-14T16:15:35-08:00
cleaned_at: 2026-02-14T17:54:32-08:00
---

The S-DSP's **Global Counter**:

- is initialized to zero on reset
- counts from 0x77FF to zero, decrementing by one on cycle 29 of the Sample Generation Loop
- is examined by the noise sample generator and the volume envelope adjustments

### See Also

- Pitch Counter
- Echo Counter

### External Links

- ares source code for global counter: [https://github.com/ares-emulator/ares/blob/master/ares/sfc/dsp/counter.cpp](https://github.com/ares-emulator/ares/blob/master/ares/sfc/dsp/counter.cpp)

### References

- anomie's APU DSP doc
