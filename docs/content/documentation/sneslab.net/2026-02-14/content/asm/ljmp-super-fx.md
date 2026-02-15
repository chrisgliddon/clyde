---
title: "LJMP (Super FX)"
reference_url: https://sneslab.net/wiki/LJMP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Two-byte_Instructions"
  - "Instructions_with_Delay_Slots"
downloaded_at: 2026-02-14T13:35:08-08:00
cleaned_at: 2026-02-14T17:52:17-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** [Absolute Long Implied](/mw/index.php?title=Absolute_Long_Implied&action=edit&redlink=1 "Absolute Long Implied (page does not exist)") (type 1) 3D9n 2 bytes 6 cycles 6 cycles 2 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LJMP** (Long Jump) is a Super FX instruction that performs a (possibly interbank) jump.

The low byte of the source register is loaded into the program bank register. The high byte of the source register is ignored.

According to fullsnes, the official documentation has the bank and offs operands for LJMP mixed up. \[3]

The operand can be any general register from R8 to R13. The value of this general register is loaded into R15 (the program counter).

The instruction following LJMP is already in the pipeline (the delay slot) and will be executed before the first instruction at the jump target.

The ALT0 state is restored. All cache flags are reset.

#### Syntax

```
LJMP Rn
```

### Example

Let:

```
R1 : 0001h
```

The following program jumps from 00:8006h to 01:0002h:

```
bank :addr  code
00   :8000h IWT R10, #0002h
00   :8003h FROM R1
00   :8004h LJMP R10
00   :8006h NOP
```

### See Also

- JMP (Super FX)
- JMP
- BRA (Super FX)
- BRA
- ALT1

### External Links

1. Official Nintendo documentation on LJMP: 9.49 on [page 2-9-69 of Book II](https://archive.org/details/SNESDevManual/book2/page/n225)
2. [page 2-6-11 of Book II](https://archive.org/details/SNESDevManual/book2/page/n133), lbid.
3. [https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc](https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc)
