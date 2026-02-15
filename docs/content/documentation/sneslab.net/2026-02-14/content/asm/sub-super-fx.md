---
title: "SUB (Super FX)"
reference_url: https://sneslab.net/wiki/SUB_(Super_FX)
categories:
  - "Arithmetic_Operation_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:40:43-08:00
cleaned_at: 2026-02-14T17:53:23-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 6n 1 byte 3 cycles 3 cycles 1 cycle Immediate 3E6n 2 bytes 6 cycles 6 cycles 2 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**SUB** is a Super FX instruction that performs a subtraction between the source register and an operand. The difference is stored in the destination register. The subtrahend may be any register from R0 to R15 or any immediate value from 0 to 15. The source register is the minuend.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

If an unsigned borrow occurred, CY is set, otherwise it is cleared.

#### Syntax

```
SUB Rn
SUB #n
```

#### Example 1

Let:

```
Sreg : R5
Dreg : R4
R5 = 735ah
R8 = 426bh
```

After executing SUB R8:

```
R4 = 30efh
```

#### Example 2

Let:

```
Sreg : R0
Dreg : R0
R0 = 329bh
```

After executing SUB #10:

```
R0 = 3291h
```

### See Also

- ADD
- ADC (Super FX)
- ADC
- CMP (Super FX)
- SBC (Super FX)
- ALT2

### External Links

- Official Nintendo documentation on SUB: 9.86 on [page 2-9-118 of Book II](https://archive.org/details/SNESDevManual/book2/page/n274)
- SUB with immediate addressing: 9.87 on [page 2-9-119 of Book II](https://archive.org/details/SNESDevManual/book2/page/n275)
