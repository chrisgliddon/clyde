---
title: "UMULT (Super FX)"
reference_url: https://sneslab.net/wiki/UMULT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T17:09:21-08:00
cleaned_at: 2026-02-14T17:53:38-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D8n 2 bytes 6 or 8 cycles 6 or 8 cycles 2 or 3 cycles Immediate 3F8n\[4] 2 bytes 6 or 8 cycles 6 or 8 cycles 2 or 3 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**UMULT** is an unsigned multiplication Super FX instruction. The factors are the low byte of the source register and the low byte of the register specified in the operand or an immediate value. The product is stored in the destination register.

UMULT utilizes the 8-bit multiplier only once, so it is fast.\[2]

The exact number of cycles depends on the state of the CONFIG register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

The page of documentation on the immediate addressing mode of UMULT appears to be missing from the official dev manual. As the SNES scene has access to the two manual pages with page numbers adjacent to UMULT Rn, it appears to have been printed that way. The information on this page for that addressing mode comes from \[4].

#### Syntax

```
UMULT Rn
UMULT #n
```

#### Example

Let:

```
Sreg : R3
Dreg : R0
R3 = 364fh
R8 = b2cfh
```

After executing UMULT R8:

```
R0 = 3fe1h
```

### See Also

- FMULT
- LMULT
- MULT
- MUL
- DIV2
- ALT1

### External Links

1. Official Nintendo documentation on UMULT: 9.90 on [page 2-9-122 of Book II](https://archive.org/details/SNESDevManual/book2/page/n278)
2. 8.2 "Multiplication Instructions" on [page 2-8-16 of Book II](https://archive.org/details/SNESDevManual/book2/page/n155), lbid.
3. Table 2-2-2 Instruction Set (Sheet 1) on [page 2-2-6 of Book II](https://archive.org/details/SNESDevManual/book2/page/n100), lbid.
4. [https://en.wikibooks.org/wiki/Super\_NES\_Programming/Super\_FX\_tutorial#Instruction\_Set\_Table](https://en.wikibooks.org/wiki/Super_NES_Programming/Super_FX_tutorial#Instruction_Set_Table)
