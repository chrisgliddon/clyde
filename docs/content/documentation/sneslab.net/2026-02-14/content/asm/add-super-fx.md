---
title: "ADD (Super FX)"
reference_url: https://sneslab.net/wiki/ADD_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T10:47:14-08:00
cleaned_at: 2026-02-14T17:51:03-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 5n 1 bytes 3 cycles 3 cycles 1 cycle Immediate 3E5n 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**ADD** is Super FX instruction that performs an addition. The source register is always an addend. The other addend may be any of the 16 general registers or an immediate value. The sum is stored in the destination register.

Unlike with ADC, CY is not an addend.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
ADD Rn
ADD #n
```

#### Example 1

Let:

```
Sreg : R0
Dreg : R0
R0 = 4283h
R4 = 2438h
```

After executing ADD R4:

```
R0 = 66bbh
```

#### Example 2

Let:

```
Sreg : R4
Dreg : R7
R4 = 3682h
```

After executing ADD #8h:

```
R7 = 368ah
```

### See Also

- ADC (65c816)
- ADC (Super FX)
- SUB
- ALT2

### External Links

- Official Nintendo documentation on ADD: 9.6 [Page 2-9-5 of Book II](https://archive.org/details/SNESDevManual/book2/page/n161)
- ADD with immediate addressing: 9.7 [Page 2-9-6 of Book II](https://archive.org/details/SNESDevManual/book2/page/n162)
