---
title: "NOTC (SPC700)"
reference_url: https://sneslab.net/wiki/NOTC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:41:33-08:00
cleaned_at: 2026-02-14T17:52:35-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) ED 1 byte 3 cycles

Flags Affected N V P B H I Z C . . . . . . . !C

**NOTC** is an SPC700 instruction that inverts the carry flag.

No other flags are affected.

#### Syntax

```
NOTC
```

### See Also

- SETC
- CLRC
- NOT1
- CLC
- SEC
- NOT

### External Links

- Official Super Nintendo development manual on NOTC: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L516](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L516)
