---
title: "S-DSP/Echo Counter"
reference_url: https://sneslab.net/wiki/S-DSP/Echo_Counter
categories:
  - "Audio"
  - "Timing"
downloaded_at: 2026-02-14T16:15:13-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

The **Echo Counter** is a 15-bit unsigned integer. Its value is added to ESA x 100h, yielding the effective address calculation for echo writes. The counter's maximum value is determined by EDL. When the echo counter reaches ESA x 80h, it is reset to zero, but it is the value of ESA at the time of the previous echo counter reset that determines the reset threshold, not the current ESA value. This is to prevent the echo counter from incrementing all the way up to its max if a small ESA is set.

### See Also

- The Infamous Bit-Of-Confusion

### External Links

- The echo counter is implemented by echo.\_offset in ares, and it is incremented/reset in DSP::echo29()

### References

- caution #3 (echo operations) in the official Super Nintendo development manual: [page 3-9-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n189)
