---
title: "SWAP (Super FX)"
reference_url: https://sneslab.net/wiki/SWAP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Byte_Transfer_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
  - "Exchange_Instructions"
downloaded_at: 2026-02-14T16:41:03-08:00
cleaned_at: 2026-02-14T17:53:24-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 4D 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**SWAP** is a Super FX instruction that swaps two bytes. The low byte of the source register is written to the high byte of the destination register, and the high byte of the source register is written to the low byte of the destination register. The source register itself is left unchanged.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
SWAP
```

#### Example

Let:

```
Sreg : R3
Dreg : R13
R3 : 48d0h
```

After executing SWAP:

```
R13 = d048h
```

### See Also

- XBA
- XCE
- XCN
- MERGE

### External Links

- Official Nintendo documentation on SWAP: 9.88 on [page 2-9-120 of Book II](https://archive.org/details/SNESDevManual/book2/page/n276)
