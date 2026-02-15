---
title: "DI (SPC700)"
reference_url: https://sneslab.net/wiki/DI_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Program_Status_Flag_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:36:01-08:00
cleaned_at: 2026-02-14T17:51:46-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) C0 1 byte 3 cycles

Flags Affected N V P B H I Z C . . . . . 0 . .

**DI** (Disable Interrupts) is an SPC700 instruction that clears the interrupt enable flag.

As the S-SMP has no hardware interrupt sources, DI is not very useful.

No other flags are affected.

#### Syntax

```
DI
```

The official manual has a typo where the zero flag is cleared instead.

### See Also

- EI
- RETI
- BRK (SPC700)
- SEI
- CLI

### External Links

- Official Super Nintendo development manual on DI: Table C-19 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L424](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L424)
