---
title: "Reset Vector"
reference_url: https://sneslab.net/wiki/Reset_Vector
categories:
  - "ASM"
downloaded_at: 2026-02-14T16:13:43-08:00
cleaned_at: 2026-02-14T17:52:53-08:00
---

The **Reset Vector** points to a subroutine that runs when the Control Deck first boots up or comes out of reset.

It is located at $00:FFFC,FD and is only active in emulation mode.

### See Also

- Interrupt Handler

### Reference

- "Table 5-2 Emulation Mode Vector Locations (8-bit Mode)" on 65c816 datasheet, 2024 edition
