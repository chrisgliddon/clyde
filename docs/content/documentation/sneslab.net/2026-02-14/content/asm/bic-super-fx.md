---
title: "BIC (Super FX)"
reference_url: https://sneslab.net/wiki/BIC_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Logical_Operation_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T11:03:02-08:00
cleaned_at: 2026-02-14T17:51:16-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D7n 2 bytes 6 cycles 6 cycles 2 cycles Immediate 3F7n 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**BIC** (BIt Clear mask) is a Super FX instruction that performs a logical AND between the source register and the 1's complement of the operand. The conjunction is stored in the destination register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
BIC Rn
BIC #n
```

#### Example 1

Let:

```
Sreg : R2
Dreg : R0
R2 = 75ceh (0111 0101 1100 1110b)
R1 = 3846h (0011 1000 0100 0110b)
```

After executing BIC R1:

```
R0 = 4588h (0100 0101 1000 1000b)
```

#### Example 2

Let:

```
Sreg : R4
Dreg : R5
R4 = 364bh (0011 0110 0100 1011b)
```

After BIC #F is executed:

```
R5 = 3640h (0011 0110 0100 0000b)
```

### See Also

- AND (Super FX)
- OR (Super FX)
- XOR (Super FX)
- ALT1
- ALT3

### External Links

- Official Nintendo documentation on BIC: 9.18 on [Page 2-9-22 of Book II](https://archive.org/details/SNESDevManual/book2/page/n178)
- immediate BIC: 9.19 on [page 2-9-23](https://archive.org/details/SNESDevManual/book2/page/n179), lbid.
