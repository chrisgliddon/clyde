---
title: "HDMA Table"
reference_url: https://sneslab.net/wiki/HDMA_Table
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T13:17:33-08:00
cleaned_at: 2026-02-14T17:54:15-08:00
---

An **HDMA Table** is a list of zero or more entries that hold the data that can be transferred by HDMA. The structure of an HDMA table is described in Appendix B-2 of the official Super Nintendo development manual\[1], which is summarized below:

HDMA tables end with a zero terminating byte.

The first byte of each entry consists of a scanline count in the bottom 7 bits, and a continue flag in the top bit.

### Reference

1. [Appendix B-2](https://archive.org/details/SNESDevManual/book1/page/n219)
