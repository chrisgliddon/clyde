---
title: "SEX (Super FX)"
reference_url: https://sneslab.net/wiki/SEX_(Super_FX)
categories:
  - "Super_FX"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:22:19-08:00
cleaned_at: 2026-02-14T17:53:09-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 95 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**SEX** is a Super FX instruction that performs a sign extension of an 8-bit value. Bit 7 (the sign of the lower 8 bits) of the source register is copied into all the bits in the high byte of the destination register. The low byte of the source register is copied directly into the low byte of the destination register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
SEX
```

#### Example

Let:

```
Sreg : R5
Dreg : R1
R5 : 9284h
```

After executing SEX:

```
R1 = ff84h
```

### See Also

- LOB
- HIB
- MERGE

### External Links

- Official Nintendo documentation on SEX: paragraph 9.80 on [page 2-9-110 of Book II](https://archive.org/details/SNESDevManual/book2/page/n266)

<!--THE END-->

- example: [page 2-9-111](https://archive.org/details/SNESDevManual/book2/page/n267), lbid.
