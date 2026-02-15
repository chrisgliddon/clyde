---
title: "LOB (Super FX)"
reference_url: https://sneslab.net/wiki/LOB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Byte_Transfer_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:36:22-08:00
cleaned_at: 2026-02-14T17:52:20-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 9E 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**LOB** (Low Byte) is a Super FX instruction that moves the low byte of the source register into the low byte of the destination register. The high byte of the destination register is zeroed.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
LOB
```

#### Example

Let:

```
Sreg : R10
Dreg : R12
R10 = fb23h
```

After executing LOB:

```
R12 = 0023h
```

### See Also

- HIB
- SEX
- MERGE
- COLOR

### External Links

- Official Nintendo documentation on LOB: paragraph 9.53 on [Page 2-9-75 of Book II](https://archive.org/details/SNESDevManual/book2/page/n231)
- example: [page 2-9-76 of Book II](https://archive.org/details/SNESDevManual/book2/page/n232), lbid.
