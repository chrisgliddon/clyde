---
title: "OR (Super FX)"
reference_url: https://sneslab.net/wiki/OR_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Logical_Operation_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T15:46:02-08:00
cleaned_at: 2026-02-14T17:52:36-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate 3ECn 2 bytes 6 cycles 6 cycles 2 cycle Implied (type 1) Cn 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**OR** is a Super FX instruction that performs a logical bitwise OR between the source register and its operand. The disjunction is stored in the destination register. The operand may be any register from R1 to R15 or any immediate value from 1 to 15.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
OR Rn
OR #n
```

#### Example 1

Let:

```
Sreg : R4
Dreg : R5
R4 = 6368h (0110 0011 0110 1000b)
R2 = 168ch (0001 0110 1000 1100b)
```

After executing OR R2:

```
R5 = 77ech (0111 0111 1110 1100b)
```

#### Example 2

Let:

```
Sreg : R7
Dreg : R5
R7 = 5fa2h (0101 1111 1010 0010b)
```

After executing OR #5h:

```
R5 = 5fa7h (0101 1111 1010 0111b)
```

### See Also

- AND (Super FX)
- XOR (Super FX)
- ORA
- EOR
- ALT2
- OR (SPC700)

### External Links

- Official Nintendo documentation on OR: 9.70 on [page 2-9-97 of Book II](https://archive.org/details/SNESDevManual/book2/page/n253)
- example 1: [page 2-9-98 of Book II](https://archive.org/details/SNESDevManual/book2/page/n254), lbid.
- immediate OR: 9.71 on [page 2-9-99 of Book II](https://archive.org/details/SNESDevManual/book2/page/n255)
