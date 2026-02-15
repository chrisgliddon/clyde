---
title: "ASR (Super FX)"
reference_url: https://sneslab.net/wiki/ASR_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Shift_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T10:50:36-08:00
cleaned_at: 2026-02-14T17:51:09-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 96 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S CY Z

**ASR** (Arithmetic Shift Right) is a Super FX instruction that shifts all bits of the source register's value to the right one bit while also leaving the most significant bit unchanged, storing the result in the destination register. Bit 0 is shifted into CY.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
ASR
```

#### Example

Let:

```
Sreg : R10
Dreg : R1
CY = 0
R10 = 4f7bh (0100 1111 0111 1011b)
```

After executing ASR:

```
CY = 1
R1 = 27bdh (0010 0111 1011 1101b)
```

The source register itself is not modified despite the arrows in the above image.

### See Also

- LSR (Super FX)
- ASL
- LSR
- DIV2
- ROR (Super FX)
- ROR (SPC700)
- ROR

### External Links

- Official Nintendo documentation on ASR: 9.13 on [Page 2-9-12 of Book II](https://archive.org/details/SNESDevManual/book2/page/n168)
- example: [page 2-9-13 of Book II](https://archive.org/details/SNESDevManual/book2/page/n169), lbid.
