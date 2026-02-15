---
title: "RETI (SPC700)"
reference_url: https://sneslab.net/wiki/RETI_(SPC700)
categories:
  - "SPC700"
  - "Subroutine_Call_Return_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:06:31-08:00
cleaned_at: 2026-02-14T17:52:54-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack 7F 1 byte 6 cycles

Flags Affected N V P B H I Z C N V P B H I Z C

**RETI** (RETurn from Interrupt) is an SPC700 instruction that returns from an interrupt handler. All program status word flags are popped off the stack and restored. The program counter is also popped from the stack.

As the S-SMP has no hardware interrupt sources, this generally means returning from a BRK.

#### Syntax

```
RETI
```

### See Also

- EI
- DI
- RET
- RTI
- RTS
- RTL

### References

- Table C-16 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L547](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L547)
