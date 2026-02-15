---
title: "Filter Setting Examples"
reference_url: https://sneslab.net/wiki/Filter_Setting_Examples
categories:
  - "Audio"
  - "Tables"
downloaded_at: 2026-02-14T12:02:42-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

Filter Setting Example 1: low pass filter on the echo

Register Numerical Value C0 FF C1 08 C2 17 C3 24 C4 24 C5 17 C6 08 C7 FF

Filter Setting Example 2: echo has same tone color as original

Register Numerical Value C0 7F C1 00 C2 00 C3 00 C4 00 C5 00 C6 00 C7 00

### See Also

- FIR Filter

### Reference

- [page 3-7-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n176) of the official Super Nintendo development manual
