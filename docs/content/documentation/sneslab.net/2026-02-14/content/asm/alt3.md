---
title: "ALT3"
reference_url: https://sneslab.net/wiki/ALT3
categories:
  - "ASM"
  - "Super_FX"
  - "Flag_Prefix_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T10:48:29-08:00
cleaned_at: 2026-02-14T17:51:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 2) 3F 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z . 1 1 . . . .

**ALT3** is a Super FX flag prefix instruction that sets both the ALT1 and ALT2 flags.

Unlike ALT1 and ALT2 however, ALT3 is only an instruction and not also the name of a flag itself.

#### Syntax

```
ALT3
```

The following instructions require ALT3:

- ADC #n
- BIC #n
- CMP Rn
- GETBS
- ROMB
- XOR #n

#### See Also

- ALT0
- Super\_FX\_Opcode\_Matrices#ALT1\_=\_1,\_ALT2\_=\_1

### External Links

- Official Nintendo documentation on ALT3: 9.10 on [page 2-9-9 of Book II](https://archive.org/details/SNESDevManual/book2/page/n165)
- Table 2-4-2 on [page 2-4-4](https://archive.org/details/SNESDevManual/book2/page/n110), lbid.
- [https://en.wikibooks.org/wiki/Super\_NES\_Programming/Super\_FX\_tutorial#Instruction\_Set\_Table](https://en.wikibooks.org/wiki/Super_NES_Programming/Super_FX_tutorial#Instruction_Set_Table)
