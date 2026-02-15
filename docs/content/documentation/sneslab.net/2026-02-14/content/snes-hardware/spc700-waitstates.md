---
title: "SPC700/Waitstates"
reference_url: https://sneslab.net/wiki/SPC700/Waitstates
categories:
  - "SNES_Hardware"
  - "Audio"
  - "Timing"
downloaded_at: 2026-02-14T16:36:58-08:00
cleaned_at: 2026-02-14T17:54:36-08:00
---

This table shows how many [waitstates](/mw/index.php?title=waitstate&action=edit&redlink=1 "waitstate (page does not exist)") the internal cycles of all the SPC700 opcodes have.

x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF **0x** 0 3 0 1 0 0 0 1 0 0 1 0 0 1 0 2 **1x** 2 3 0 3 1 1 1 1 0 0 0 1 0 0 0 1 **2x** 0 3 0 1 0 0 0 1 0 0 1 0 0 1 3 2 **3x** 0 3 0 3 1 1 1 1 0 0 0 1 0 0 0 3 **4x** 0 3 0 1 0 0 0 1 0 0 0 0 0 1 0 3 **5x** 2 3 0 3 1 1 1 1 0 0 0 1 0 0 0 0 **6x** 0 3 0 1 0 0 0 1 0 1 0 0 0 1 2 1 **7x** 0 3 0 3 1 1 1 1 1 1 1 1 0 0 0 1 **8x** 0 3 0 1 0 0 0 1 0 0 1 0 0 0 1 0 **9x** 2 3 0 3 1 1 1 1 0 0 1 1 0 0 10 3 **Ax** 1 3 0 1 0 0 0 1 0 0 0 0 0 0 1 1 **Bx** 0 3 0 3 1 1 1 1 0 0 1 1 0 0 1 1 **Cx** 1 3 0 1 0 0 0 1 0 0 1 0 0 0 1 7 **Dx** 2 3 0 3 1 1 1 1 0 1 0 1 0 0 4 1 **Ex** 0 3 0 1 0 0 0 1 0 0 0 0 0 1 1 0 **Fx** 0 3 0 3 1 1 1 1 0 1 0 1 0 0 3 0

### See Also

- WS1 Area
- WS2 Area
- SPC700 Opcode Matrix

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports](https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports)
