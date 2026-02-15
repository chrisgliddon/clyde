---
title: "ALT1"
reference_url: https://sneslab.net/wiki/ALT1
categories:
  - "ASM"
  - "Flags"
  - "Super_FX"
  - "Flag_Prefix_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T10:48:08-08:00
cleaned_at: 2026-02-14T17:51:04-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 2) 3D 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B [ALT1]() ALT2 O/V S CY Z . 1 . . . . .

**ALT1** is both the name of a Super FX flag and the flag prefix instruction that sets it. It is bit 8 of the status flag register.

#### Syntax

```
ALT1
```

The following instructions require ALT1:

- ADC Rn
- BIC Rn
- CMODE
- DIV2
- GETBH
- LDB (Rm)
- LJMP
- LM Rn, (xx)
- LMS Rn, (yy)
- LMULT
- RPIX
- SBC Rn
- STB (Rm)
- UMULT Rn
- XOR Rn

Many instructions clear the ALT1 flag, including:

- ADC Rn
- ADC #n
- ADD Rn
- ADD #n
- AND Rn
- AND #n
- ASR
- BIC Rn
- BIC #n
- CACHE
- CMODE
- CMP Rn
- COLOR
- DEC Rn
- DIV2
- FMULT
- GETB
- GETBH
- GETBL
- GETBS
- GETC
- HIB
- IBT Rn, #pp
- INC Rn
- IWT Rn, #xx
- JMP Rn
- LDB (Rm)
- LDW (Rm)
- LEA Rn, xx
- LINK #n
- LJMP Rn
- LM Rn, (xx)
- LMS Rn, (yy)
- LMULT
- LOB
- LOOP
- LSR
- MERGE
- MOVE Rn, Rn'
- MOVES Rn, Rn'
- MULT Rn
- MULT #n
- NOP
- NOT
- OR Rn
- OR #n
- PLOT
- RAMB
- ROL
- ROMB
- ROR
- RPIX
- SBC Rn
- SBK
- SEX
- SM (xx), Rn
- SMS (yy), Rn
- STB (Rm)
- STOP
- STW (Rm)
- SUB Rn
- SUB #n
- SWAP
- UMULT Rn
- and presumably UMULT #n and XOR too

### See Also

- ALT2
- ALT3
- ALT0
- Super\_FX\_Opcode\_Matrices#ALT1\_=\_1,\_ALT2\_=\_0

### External Links

- Official Nintendo documentation on ALT1: 9.8 on [page 2-9-7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n163)
- Table 2-4-2 on [page 2-4-4](https://archive.org/details/SNESDevManual/book2/page/n110), lbid.
- [https://en.wikibooks.org/wiki/Super\_NES\_Programming/Super\_FX\_tutorial#Instruction\_Set\_Table](https://en.wikibooks.org/wiki/Super_NES_Programming/Super_FX_tutorial#Instruction_Set_Table)
