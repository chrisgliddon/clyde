---
title: "MERGE (Super FX)"
reference_url: https://sneslab.net/wiki/MERGE_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Byte_Transfer_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:47:25-08:00
cleaned_at: 2026-02-14T17:52:23-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 70 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**MERGE** is a Super FX instruction that merges the high bytes of two specific general registers into the destination register.

The high byte of Dreg comes from R7. The low byte of Dreg comes from R8.

The official documentation has several bits labeled "B" not 'D" below the "Flags affected" table.\[1]

The ALT0 state is restored.

The destination register should be specified in advance using WITH or TO. Otherwise, R0 serves as the default. The source register is ignored.

#### Syntax

```
MERGE
```

#### Example

Let:

```
Dreg : R9
R7 = 05aah
R8 = fc33h
```

After executing MERGE:

```
R9 = 05fch
```

and the sign, overflow, carry, and zero flags are set

### See Also

- HIB
- LOB
- SEX

### External Links

- Official Nintendo documentation on MERGE: paragraph 9.56 on [page 2-9-79 of Book II](https://archive.org/details/SNESDevManual/book2/page/n235)
- example: [page 2-9-80 of Book II](https://archive.org/details/SNESDevManual/book2/page/n236), lbid.
