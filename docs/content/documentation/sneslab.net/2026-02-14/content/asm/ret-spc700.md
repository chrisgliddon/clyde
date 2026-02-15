---
title: "RET (SPC700)"
reference_url: https://sneslab.net/wiki/RET_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Subroutine_Call_Return_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:06:35-08:00
cleaned_at: 2026-02-14T17:52:53-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack 6F 1 byte 5 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**RET** (RETurn) is an SPC700 instruction that returns from a subroutine. The program counter is popped from the stack.

No flags are affected.

#### Syntax

```
RET
```

The subroutine is usually called using CALL, TCALL, or PCALL.

### See Also

- RETI
- RTS

### References

- Table C-16 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L546](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L546)
