---
title: "Direct Page Flag"
reference_url: https://sneslab.net/wiki/Direct_Page_Flag
categories:
  - "ASM"
  - "Flags"
  - "SPC700"
downloaded_at: 2026-02-14T11:47:01-08:00
cleaned_at: 2026-02-14T17:51:48-08:00
---

The **Direct Page Flag** (P) is bit 5 of the S-SMP's program status word:

- When clear, the direct page is the zeropage (located at 0000h to 00FFh).
- When set, the direct page is page one (located at 0100h to 01FFh).

The direct page flag is set by SETP and cleared by CLRP.

### Reference

- [Appendix C-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n227) of the official Super Nintendo development manual
