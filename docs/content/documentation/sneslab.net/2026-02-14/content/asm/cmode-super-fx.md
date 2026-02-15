---
title: "CMODE (Super FX)"
reference_url: https://sneslab.net/wiki/CMODE_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Plot-related_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:22:28-08:00
cleaned_at: 2026-02-14T17:51:36-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D4E 2 bytes 6 cycles 6 cycles 2 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

Color/Plot flags Plot Transparent Plot Dither Color Src High Color Frz High Object Mode Bit 0 of src Bit 1 of src Bit 2 of src Bit 3 of src Bit 4 of src

**CMODE** is a Super FX instruction that specifies [execution modes](/mw/index.php?title=execution_modes&action=edit&redlink=1 "execution modes (page does not exist)"). It sets plot and color related flags based on the low 5 bits of the source register.

The ALT0 state is restored.

#### Syntax

```
CMODE
```

#### Example

Let:

```
Sreg : R0
R0 = 0002h
```

After CMODE runs, the transparency and dither modes are set.

### See Also

- Transparency Flag
- Dither Flag
- ALT1
- Plot Options Register
- COLOR

### External Links

- Official Nintendo documentation on CMODE: 9.28 on [Page 2-9-39 of Book II](https://archive.org/details/SNESDevManual/book2/page/n195)
- example: [Page 2-9-40](https://archive.org/details/SNESDevManual/book2/page/n196), lbid.
- 8.1.4 Plot Function and CMODE on page 2-8-9, lbid.
