---
title: "NOP (SPC700)"
reference_url: https://sneslab.net/wiki/NOP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Other_SPC700_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:41:02-08:00
cleaned_at: 2026-02-14T17:52:32-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3) 00 1 byte 2 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**NOP** is an SPC700 instruction that does nothing (other than increment the program counter by one).

No flags are affected.

#### Syntax

```
NOP
```

### See Also

- SLEEP
- STOP (SPC700)
- NOP
- WDM
- NOP (Super FX)

### External Links

- Official Nintendo documentation on NOP: Table C-20 in [Appendix C-10](https://archive.org/details/SNESDevManual/book1/page/n235%7Cthumb)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L512](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L512)
