---
title: "MULT (Super FX)"
reference_url: https://sneslab.net/wiki/MULT_(Super_FX)
categories:
  - "Arithmetic_Operation_Instructions"
downloaded_at: 2026-02-14T14:56:53-08:00
cleaned_at: 2026-02-14T17:52:29-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 8n 1 byte 3 or 5 cycles 3 or 5 cycles 1 or 2 cycles Immediate 3E8n 2 bytes 6 or 8 cycles 6 or 8 cycles 2 or 3 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**MULT** is a Super FX instruction that performs a signed multiplication. One of the factors is the low byte of the source register. The other factor may be any register from R0 to R15 or an immediate int from 0 to 15. The product is stored in the destination register.

MULT utilizes the 8-bit multiplier only once, so it is fast.\[2]

The exact number of cycles depends on the state of the CFGR register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
MULT Rn
MULT #n
```

#### Example 1

Let:

```
Sreg : R5
Dreg : R2
R5 = 52cfh
R1 = 63cfh
```

After executing MULT R1:

```
R2 = 0961h
```

#### Example 2

Let:

```
Sreg : R3
Dreg : R4
R3 = 95c6h
```

After executing MULT #9:

```
R4 = fdf6h
```

### See Also

- UMULT
- FMULT
- LMULT
- DIV2
- ALT2

### External Links

1. Official Nintendo documentation on MULT: 9.66 on [Page 2-9-93 of Book II](https://archive.org/details/SNESDevManual/book2/page/n249)
2. 8.2 "Multiplication Instructions" on [page 2-8-16 of Book II](https://archive.org/details/SNESDevManual/book2/page/n155), lbid.
