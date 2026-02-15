---
title: "CLRC (SPC700)"
reference_url: https://sneslab.net/wiki/CLRC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:21:24-08:00
cleaned_at: 2026-02-14T17:51:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 60 1 byte 2 cycles

Flags Affected N V P B H I Z C . . . . . . . 0

**CLRC** is an SPC700 instruction that clears the carry flag.

No other flags are affected.

#### Syntax

```
CLRC
```

### See Also

- SETC
- CLRP
- CLRV
- NOTC
- ADC (SPC700)
- CLC
- SEC

### External Links

- Official Nintendo documentation on CLRC: [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L384](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L384)
