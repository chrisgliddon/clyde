---
title: "HIB (Super FX)"
reference_url: https://sneslab.net/wiki/HIB_(Super_FX)
categories:
  - "Byte_Transfer_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
  - "One-byte_Instructions"
  - "Super_FX"
downloaded_at: 2026-02-14T13:18:12-08:00
cleaned_at: 2026-02-14T17:52:02-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) C0 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**HIB** (High Byte) is a Super FX instruction that moves the high byte of the source register into the low byte of the destination register. The high byte of the destination register is zeroed.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
HIB
```

#### Example

Let:

```
Sreg : R11
Dreg : R1
R11 = 8a43h
```

After executing HIB:

```
R1 = 008ah
```

and the sign flag is set.

### See Also

- LOB
- MERGE
- SEX

### External Links

- Official Nintendo documentation on HIB: paragraph 9.40 on [Page 2-9-58 of Book II](https://archive.org/details/SNESDevManual/book2/page/n214)
- example: [page 2-9-59 of Book II](https://archive.org/details/SNESDevManual/book2/page/n215), lbid.
