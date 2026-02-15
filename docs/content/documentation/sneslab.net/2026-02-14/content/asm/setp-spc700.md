---
title: "SETP (SPC700)"
reference_url: https://sneslab.net/wiki/SETP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:21:56-08:00
cleaned_at: 2026-02-14T17:53:08-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 40 1 byte 2 cycles

Flags Affected N V P B H I Z C . . 1 . . . . .

**SETP** (Set Page) is an SPC700 instruction that sets the direct page flag, making the direct page coincident with page one.

No other flags are affected.

#### Syntax

```
SETP
```

### See Also

- CLRP
- SETC

### External Links

- Official Super Nintendo development manual on SETP: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L582](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L582)
