---
title: "CLRP (SPC700)"
reference_url: https://sneslab.net/wiki/CLRP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:21:34-08:00
cleaned_at: 2026-02-14T17:51:34-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 20 1 byte 2 cycles

Flags Affected N V P B H I Z C . . 0 . . . . .

**CLRP** (Clear Page) is an SPC700 instruction that clears the direct page flag, making the direct page coincident with the zero page.

No other flags are affected.

#### Syntax

```
CLRP
```

### See Also

- SETP
- CLRV
- CLRC

### External Links

- Official Super Nintendo development manual on CLRP: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L385](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L385)
