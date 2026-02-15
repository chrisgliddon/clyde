---
title: "Revision 1 CPU DMA crash"
reference_url: https://sneslab.net/wiki/Revision_1_CPU_DMA_crash
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T16:14:05-08:00
cleaned_at: 2026-02-14T17:54:29-08:00
---

Little is known about why the **CPU revision 1 DMA crash** happens. In 2015, Ramsis wrote a test rom to trigger it. \[2]

### Trigger

- kicking of an HDMA at about the same time that a General Purpose DMA finishes

### Symptoms

- Sometimes the 5A22 will crash
- Sometimes the HDMA will not happen correctly

### Workarounds

- Use GPDMA only during vblank
- Make sure HDMA starts in the middle of a GPDMA data transfer
- Avoid HDMA
- Adjust the time at which GPDMA begins
- Decrease the number of bytes transferred during GPDMA

### See Also

- Revision 1 PPU1 Time Over Bug

### References

1. [page 2-25-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n111) of the official Super Nintendo development manual, the ICE mentioned likely stands for "[In-Circuit Emulator](https://www.microcontrollertips.com/faq-what-is-ice/)"
2. [https://forums.nesdev.org/viewtopic.php?t=13280](https://forums.nesdev.org/viewtopic.php?t=13280)
