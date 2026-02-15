---
title: "PCALL (SPC700)"
reference_url: https://sneslab.net/wiki/PCALL_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Subroutine_Call_Return_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T15:49:58-08:00
cleaned_at: 2026-02-14T17:52:38-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Uppermost Page 4F 2 bytes 6 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**PCALL** (uPage CALl) is an SPC700 instruction that runs a subroutine in the uppermost page. The operand specifies the low byte of the target address within the uppermost page.

No flags are affected.

#### Syntax

```
PCALL upage
```

PCALL $xx has the same effect as CALL $FFxx.\[2]

### See Also

- TCALL
- RET
- JSR

### External Links

1. Official Nintendo documentation on PCALL: Table C-16 [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
2. [https://forums.nesdev.org/viewtopic.php?t=13313](https://forums.nesdev.org/viewtopic.php?t=13313)
3. [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L534](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L534)
