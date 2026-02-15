---
title: "AND (Super FX)"
reference_url: https://sneslab.net/wiki/AND_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Logical_Operation_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T10:49:12-08:00
cleaned_at: 2026-02-14T17:51:06-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate 3E7n 2 bytes 6 cycles 6 cycles 2 cycles Implied (type 1) 7n 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**AND** is a Super FX instruction that performs a logical AND on the source register and Rn. The conjunction is stored in the destination register. The operand cannot be R0.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
AND Rn
AND #n
```

#### Example 1

```
AND  R8   ; R0 AND R8 -> R0
          ; 163ah and 00ffh -> 003ah
FROM R9   ; set the source reg to R9
TO   R10  ; set the dest reg to R10
AND  R7   ; R9 AND R7 -> R10
          ; 55aah and ff00h -> 5500h
```

#### Example 2

Let:

```
R0 = 3e5dh (0011 1110 0101 1101b)
```

After executing AND #6h:

```
R0 = 0004h (0000 0000 0000 0100b)
```

### See Also

- OR (Super FX)
- XOR (Super FX)
- BIC (Super FX)
- ALT2
- AND
- AND (SPC700)

### External Links

- Official Nintendo documentation on AND: 9.11 [Page 2-9-10 of Book II](https://archive.org/details/SNESDevManual/book2/page/n166)
- AND with immediate addressing: 9.12 [Page 2-9-11 of Book II](https://archive.org/details/SNESDevManual/book2/page/n167)
