---
title: "ADC (Super FX)"
reference_url: https://sneslab.net/wiki/ADC_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T10:46:50-08:00
cleaned_at: 2026-02-14T17:51:01-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D5n 2 bytes 6 cycles 6 cycles 2 cycles Immediate 3F5n 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**ADC** (Add with carry) is a Super FX instruction that performs an addition. The source register is always the first addend. The second addend may be any of the 16 R registers or an immediate value. The third addend is CY. The sum is stored in the destination register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
ADC Rn
ADC #n
```

#### Example 1

```
ADC   R1    ; R0 + R1 + CY -> R0
WITH  R2    ; set the source/destination regs to R2
ADC   R3    ; R2 + R3 + CY -> R2
ADC   R2    ; R0 + R2 + CY -> R0
```

#### Example 2

```
ADC    #9h             ; R0 + 0009h + CY -> R0
FROM   R3              ; set the source reg to R3
ADC    #5h             ; R3 + 0005h + CY -> R0
ADC    #0ah            ; R0 + 000ah + CY -> R0
```

### See Also

- ADD
- ADC (65c816)
- SUB
- ALT1
- ALT3

### External Links

- Official Nintendo documentation on ADC: [Page 2-9-3 of Book II](https://archive.org/details/SNESDevManual/book2/page/n159)
- ADC with immediate addressing: [Page 2-9-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n160), lbid.
