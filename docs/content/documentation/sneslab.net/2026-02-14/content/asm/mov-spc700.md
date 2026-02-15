---
title: "MOV (SPC700)"
reference_url: https://sneslab.net/wiki/MOV_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Data_Transmission_Commands"
downloaded_at: 2026-02-14T13:48:55-08:00
cleaned_at: 2026-02-14T17:52:23-08:00
---

Basic Info (Group 1) **Addressing Mode** **Opcode** **Length** **Speed** Immediate E8 2 bytes 3 cycles Implied (type 1) E6 1 byte 3 cycles Implied (type 1) BF 1 byte 4 cycles Direct Page E4 2 bytes 3 cycles Direct Page Indexed by X F4 2 bytes 4 cycles Absolute E5 3 bytes 4 cycles Absolute Indexed by X F5 3 bytes 5 cycles Absolute Indexed by Y F6 3 bytes 5 cycles Direct Page Indexed Indirect by X E7 2 bytes 6 cycles Direct Page Indirect Indexed by Y F7 2 bytes 6 cycles Immediate CD 2 bytes 2 cycles Direct Page F8 2 bytes 3 cycles Direct Page Indexed by Y F9 2 bytes 4 cycles Absolute E9 3 bytes 4 cycles Immediate 8D 2 bytes 2 cycles Direct Page EB 2 bytes 3 cycles Direct Page Indexed by X FB 2 bytes 4 cycles Absolute EC 3 bytes 4 cycles

Flags Affected (Group 1) N V P B H I Z C N . . . . . Z .

Basic Info (Group 2) **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) C6 1 byte 4 cycles Implied (type 1) AF 1 byte 4 cycles Direct Page C4 2 bytes 4 cycles Direct Page Indexed by X D4 2 bytes 5 cycles Absolute C5 3 bytes 5 cycles Absolute Indexed by X D5 3 bytes 6 cycles Absolute Indexed by Y D6 3 bytes 6 cycles Direct Page Indexed Indirect by X C7 2 bytes 7 cycles Direct Page Indirect Indexed by Y D7 2 bytes 6 cycles Direct Page D8 2 bytes 4 cycles Direct Page Indexed by Y D9 2 bytes 5 cycles Absolute C9 3 bytes 5 cycles Direct Page CB 2 bytes 4 cycles Direct Page Indexed by X DB 2 bytes 5 cycles Absolute CC 3 bytes 5 cycles

Flags Affected (Group 2) N V P B H I Z C . . . . . . . .

Basic Info (Group 3) **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 7D 1 byte 2 cycles Implied (type 1) DD 1 byte 2 cycles Implied (type 1) 5D 1 byte 2 cycles Implied (type 1) FD 1 byte 2 cycles Implied (type 1) 9D 1 byte 2 cycles

Flags Affected (Group 3) N V P B H I Z C N . . . . . Z .

Basic Info (Group 3 cont.) **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) BD 1 byte 2 cycles Direct Page FA 3 bytes 5 cycles Direct Page Immediate 8F 3 bytes 5 cycles

Flags Affected (Group 3 cont.) N V P B H I Z C . . . . . . . .

**MOV** is an SPC700 instruction that moves a value. There are a large number of variations for this instruction, and they are divided into three groups:

- In Group 1, MOV moves values from ARAM to registers.
- In Group 2, MOV moves values from registers to ARAM.
- In Group 3, MOV moves values from registers to registers or from ARAM to ARAM.

Most MOV variations that target memory perform a read cycle on the destination, which will reset T2OUT.\[3] The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

The official manual is missing a "." after each Z in the NVPBHIZC column for Groups 1 & 3.

### Syntax

```
Group 1:

MOV A, #imm
MOV A, (X)
MOV A, (X)+
MOV A, dp
MOV A, dp+X
MOV A, !abs
MOV A, !abs+X
MOV A, !abs+Y
MOV A, [dp+X]
MOV A, [dp]+Y
MOV X, #imm
MOV X, dp
MOV X, dp+Y
MOV X, !abs
MOV Y, #imm
MOV Y, dp
MOV Y, dp+X
MOV Y, !abs

Group 2:

MOV (X), A
MOV (X)+, A
MOV dp, A
MOV dp+X, A
MOV !abs, A
MOV !abs+X, A
MOV !abs+Y, A
MOV [dp+X], A
MOV [dp]+Y, A
MOV dp, X
MOV dp+Y, X
MOV !abs, X
MOV dp, Y
MOV dp+X, Y
MOV !abs, Y

Group 3:

MOV A, X
MOV A, Y
MOV X, A
MOV Y, A
MOV X, SP
MOV SP, X
MOV dp<d>, dp<s>
MOV dp, #imm
```

Some people find the official MOV mnemonic cumbersome and prefer to use an assembler that supports 65c816-style mnemonics such as TAX and TAY.

### See Also

- MOVW
- MOV1

### External Links

1. Official Super Nintendo development manual on MOV: [Appendix C-3 of Book I](https://archive.org/details/SNESDevManual/book1/page/n228)
2. [Appendix C-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n229) lbid
3. [anomie's SPC700 doc](https://www.romhacking.net/documents/197)
