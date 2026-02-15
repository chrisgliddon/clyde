---
title: "IRQ Flag"
reference_url: https://sneslab.net/wiki/IRQ_Flag
categories:
  - "Flags"
downloaded_at: 2026-02-14T13:24:24-08:00
cleaned_at: 2026-02-14T17:53:51-08:00
---

The **IRQ Flag** lives at bit 7 of TIMEUP (4211h).

[IRQ Handlers](/mw/index.php?title=IRQ_Handler&action=edit&redlink=1 "IRQ Handler (page does not exist)") should read this flag (which will cause it to automatically be cleared) otherwise the IRQ will fire again immediately after RTI.

### See Also

- IRQ Disable Flag

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesppuinterrupts](https://problemkaputt.de/fullsnes.htm#snesppuinterrupts)
