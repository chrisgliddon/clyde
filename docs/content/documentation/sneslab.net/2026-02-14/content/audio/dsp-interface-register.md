---
title: "DSP Interface Register"
reference_url: https://sneslab.net/wiki/DSP_Interface_Register
categories:
  - "Audio"
  - "Registers"
downloaded_at: 2026-02-14T11:42:29-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

The **DSP Interface Register** allows for the S-SMP to communicate with the S-DSP. This register is inside the S-DSP.\[2] It is 16 bits wide, consisting of two 8-bit subregisters:

- 00F2h holds the target DSPRAM address
- 00F3h holds the data byte 00F2h points to

Its value is indeterminate upon reset.

### See Also

- Zero Page

### Reference

1. [page 3-6-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n166%20page%203-6-1) of the official Super Nintendo development manual
2. [page 3-3-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n159), lbid.
