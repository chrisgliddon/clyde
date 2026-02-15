---
title: "H/V Count Timer"
reference_url: https://sneslab.net/wiki/H/V_Count_Timer
categories:
  - "Video"
  - "Timing"
downloaded_at: 2026-02-14T13:15:54-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

The **H/V Count Timer** can be programmed to generate an IRQ when the CRT's raster beam reaches a particular position.

The desired horizontal position should be written to HTIMEL and HTIMEH.

The desired vertical position should be written to VTIMEL and VTIMEH.

The IRQ this timer generates is sometimes called an **HV-IRQ** if it fires at a particular point, a **V-IRQ** if it fires at a particular scanline (but the dot/horizontal position is not important), or an **H-IRQ** if it fires at a particular dot (but the scanline is not important).

### See Also

- H/V Counter Latch

### Reference

- [page 2-16-1](https://archive.org/details/SNESDevManual/book1/page/n82) of the official Super Nintendo development manual
