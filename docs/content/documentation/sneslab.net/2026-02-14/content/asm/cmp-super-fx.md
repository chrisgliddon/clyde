---
title: "CMP (Super FX)"
reference_url: https://sneslab.net/wiki/CMP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T11:23:04-08:00
cleaned_at: 2026-02-14T17:51:37-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3F6n 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**CMP** (Compare) is a Super FX instruction that compares the operand register with the source register. Internally, this is done via a subtraction, but the difference is discarded. Thus, the purpose of CMP is to setup the flags.

The operand serves as the subtrahend and can be any register from R0 to R15.

The ALT0 state is restored.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

#### Syntax

```
CMP Rn
```

#### Example

Let:

```
Sreg : R1
R1 = 8000h
R3 = 2fffh
```

After executing CMP R3, the overflow and carry flags are set but the sign and zero flags are clear.

### See Also

- CMP
- SUB
- SBC
- ALT3

### External Links

- Official Nintendo documentation on CMP: 9.29 on [page 2-9-41 of Book II](https://archive.org/details/SNESDevManual/book2/page/n197)
