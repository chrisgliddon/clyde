---
title: "STOP (Super FX)"
reference_url: https://sneslab.net/wiki/STOP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "GSU_Control_Instructions"
  - "One-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:39:54-08:00
cleaned_at: 2026-02-14T17:53:17-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 2) 00 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**STOP** is a Super FX instruction that clears the Go flag, stopping the processor. An IRQ is generated.

The ALT0 state is restored.

#### Syntax

```
STOP
```

### See Also

- STP
- STOP (SPC700)

### External Links

- Official Super Nintendo development manual on STOP: 9.84 on [page 2-9-116 of Book II](https://archive.org/details/SNESDevManual/book2/page/n272)
- 6.8.4 GSU Exclusive Operation in Cache RAM on page 2-6-12 of Book II
- bsnes implementation: [https://github.com/bsnes-emu/bsnes/blob/master/bsnes/sfc/coprocessor/superfx/core.cpp#L1](https://github.com/bsnes-emu/bsnes/blob/master/bsnes/sfc/coprocessor/superfx/core.cpp#L1)
