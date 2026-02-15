---
title: "NOP (Super FX)"
reference_url: https://sneslab.net/wiki/NOP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "GSU_Control_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:41:08-08:00
cleaned_at: 2026-02-14T17:52:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 3) 01 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**NOP** (No Operation) is a Super FX instruction that does almost nothing, other than clear some flags and increment the program counter by one.

The ALT0 state is restored.

#### Syntax

```
NOP
```

### See Also

- NOP
- WDM
- NOP (SPC700)

### External Links

- Official Nintendo documentation on NOP: 9.68 on [Page 2-9-95 of Book II](https://archive.org/details/SNESDevManual/book2/page/n251)
