---
title: "Interrupt Enable Flag"
reference_url: https://sneslab.net/wiki/Interrupt_Enable_Flag
categories:
  - "Flags"
  - "SPC700"
  - "ASM"
downloaded_at: 2026-02-14T13:29:34-08:00
cleaned_at: 2026-02-14T17:53:51-08:00
---

The **Interrupt Enable Flag** is bit 2 of the S-SMP's program status word. It can be set by EI and cleared by DI.

Unlike the interrupt disable flag on the 65c816, it performs no particular function. \[1]

### Reference

1. [https://problemkaputt.de/fullsnes.htm#snesapuspc700cpuoverview](https://problemkaputt.de/fullsnes.htm#snesapuspc700cpuoverview)
