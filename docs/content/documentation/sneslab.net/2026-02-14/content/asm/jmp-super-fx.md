---
title: "JMP (Super FX)"
reference_url: https://sneslab.net/wiki/JMP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "One-byte_Instructions"
  - "Instructions_with_Delay_Slots"
downloaded_at: 2026-02-14T13:30:30-08:00
cleaned_at: 2026-02-14T17:52:10-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** [Absolute Implied](/mw/index.php?title=Absolute_Implied&action=edit&redlink=1 "Absolute Implied (page does not exist)") (type 1) 9n 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**JMP** is a Super FX instruction that performs a jump. The target address can come from any register from R8 to R13.

The instruction following JMP is already in the pipeline and will be run before the instruction at the destination address.

The ALT0 state is restored.

#### Syntax

```
JMP Rn
```

#### Example

Let:

```
R10 = 0555h
```

After executing the following program:

```
PC     Opcode
0444h  JMP R10
0445h  INC R10
```

The jump destination is 0555h.

### See Also

- LJMP
- JMP
- BRA (Super FX)
- BRA

### External Links

1. Official Nintendo documentation on JMP: 9.44 on [page 2-9-63 of Book II](https://archive.org/details/SNESDevManual/book2/page/n219)
