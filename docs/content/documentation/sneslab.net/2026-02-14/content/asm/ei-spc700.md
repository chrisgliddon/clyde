---
title: "EI (SPC700)"
reference_url: https://sneslab.net/wiki/EI_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:53:35-08:00
cleaned_at: 2026-02-14T17:51:52-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) A0 1 byte 3 cycles

Flags Affected N V P B H I Z C . . . . . 1 . .

**EI** (Enable Interrupts) is an SPC700 instruction that sets the interrupt enable flag.

As the S-SMP has no hardware interrupt sources, EI is not very useful.

No other flags are affected.

#### Syntax

```
EI
```

The official manual has a typo where the zero flag is set instead.

### See Also

- DI
- RETI
- BRK (SPC700)
- CLI
- SEI

### External Links

- Official Super Nintendo development manual on EI: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L428](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L428)
