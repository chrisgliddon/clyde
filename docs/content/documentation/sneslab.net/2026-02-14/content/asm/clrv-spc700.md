---
title: "CLRV (SPC700)"
reference_url: https://sneslab.net/wiki/CLRV_(SPC700)
categories:
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:21:45-08:00
cleaned_at: 2026-02-14T17:51:35-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) E0 1 byte 2 cycles

Flags Affected N V P B H I Z C . 0 . . 0 . . .

**CLRV** (Clear Overflow) is an SPC700 instruction that clears the overflow flag and half-carry flag.

No other flags are affected.

#### Syntax

```
CLRV
```

### See Also

- CLRP
- CLRC
- CLV
- BVC (SPC700)

### External Links

- Official Super Nintendo development manual on CLRV: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L386](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L386)
