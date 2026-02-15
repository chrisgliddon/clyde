---
title: "Page"
reference_url: https://sneslab.net/wiki/Page
categories:
  - "ASM"
  - "Official_Jargon"
downloaded_at: 2026-02-14T15:55:43-08:00
cleaned_at: 2026-02-14T17:52:38-08:00
---

A **Page** in the 65x architecture is 256 contiguous bytes.

A **page boundary** occurs between byte $FF of one page and byte $00 of the next. In emulation mode, crossing a page boundary incurs a one cycle penalty.

The zeropage is located at $00:0000.

Most pages begin at an address of the form $xx:yy00, where xx is the bank number and yy is the page number, but the direct page can begin anywhere in bank zero.

CGRAM and lowoam are exactly two pages.

### See Also

- Uppermost Page
