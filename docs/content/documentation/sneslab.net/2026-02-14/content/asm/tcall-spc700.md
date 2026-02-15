---
title: "TCALL (SPC700)"
reference_url: https://sneslab.net/wiki/TCALL_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Subroutine_Call_Return_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:57:22-08:00
cleaned_at: 2026-02-14T17:53:27-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** **Vector Address** Implied (type 3) 01 1 byte 8 cycles $FFDE Implied (type 3) 11 1 byte 8 cycles $FFDC Implied (type 3) 21 1 byte 8 cycles $FFDA Implied (type 3) 31 1 byte 8 cycles $FFD8 Implied (type 3) 41 1 byte 8 cycles $FFD6 Implied (type 3) 51 1 byte 8 cycles $FFD4 Implied (type 3) 61 1 byte 8 cycles $FFD2 Implied (type 3) 71 1 byte 8 cycles $FFD0 Implied (type 3) 81 1 byte 8 cycles $FFCE Implied (type 3) 91 1 byte 8 cycles $FFCC Implied (type 3) A1 1 byte 8 cycles $FFCA Implied (type 3) B1 1 byte 8 cycles $FFC8 Implied (type 3) C1 1 byte 8 cycles $FFC6 Implied (type 3) D1 1 byte 8 cycles $FFC4 Implied (type 3) E1 1 byte 8 cycles $FFC2 Implied (type 3) F1 1 byte 8 cycles $FFC0

Flags Affected N V P B H I Z C . . . . . . . .

**TCALL** (Table CALl) is an SPC700 instruction that calls a subroutine whose 16-bit address is stored in the uppermost page. The low byte of the address of the vector (pointer to subroutine) is a function of the high nybble of the opcode, equal to $DE - n\*2. The high byte of the vector address is always $FF.

No flags are affected.

### Syntax

```
TCALL n
```

where n is the **vector call number**, a decimal integer from 0 to 15, which becomes the high nybble of the opcode.

### See Also

- CALL
- PCALL
- RET
- SPC700/IPL ROM

### External Links

- Official Nintendo documentation on TCALL: Table C-16 [Appendix C-9](https://archive.org/details/SNESDevManual/book1/page/n234)
- [anomie's SPC700 doc](https://www.romhacking.net/documents/197)
- [https://forums.nesdev.org/viewtopic.php?t=13313](https://forums.nesdev.org/viewtopic.php?t=13313)
