---
title: "Decimal Mode"
reference_url: https://sneslab.net/wiki/Decimal_Mode
categories:
  - "Inherited_from_6502"
  - "Mode_Select_Flags"
downloaded_at: 2026-02-14T11:44:23-08:00
cleaned_at: 2026-02-14T17:51:44-08:00
---

**Decimal mode** is one of the SNES CPU's processor flags. It is bit 3 of the status register. Toggling it on/off will only affect the instructions **ADC** and **SBC**. To toggle decimal mode on/off, use **SED** (Set decimal mode) and **CLD** (clear decimal mode). When decimal mode is off, the processor is said to be in **binary mode**.

On the 65c816, hardware and software interrupts clear it. For example, it is cleared on reset.\[2] BRK and COP clear it as well. RTI and PLP can affect the decimal mode flag too, as can SEP and REP.

The negative, overflow, and zero flags are invalid in decimal mode on the NMOS 6502.\[3] But, they are valid in decimal mode on the 65c816.\[7]

There are no conditional branch instructions that examine the decimal flag (such as BDS or BDC).\[4]

## Processes

Let's just assume A is 8-bit and holds the value #$00. When one is doing ADC #$0C for example, the following steps will take place.

- Take the parameter after ADC
- Convert it to Decimal
- Add the conversion to A (execute ADC)
- If A turns out to have a hexadecimal number after the addition, convert it it to a decimal number again.

In this case, #$0C gets converted to 12. Since $0C equals to 12, doing ADC #$12 would give you the same result.

Same story with SBC, except SBC subtracts of course.

Example usage of ADC:

```
 LDA #$09  ;A = $09
 CLC       ;Clear carry flag
 ADC #$02  ;A = $11
```

The decimal mode has been documented more thoroughly in [Ersanio's ASM tutorial V2.1](https://www.smwcentral.net/?p=section&a=details&id=4750&r=0).

### See Also

- DAA
- DAS
- Half-carry Flag
- Binary Coded Decimal

### References

1. Labiak, William. Appendix C, [page 357](https://archive.org/details/Programming_the_65816/page/n367). conversion table
2. Eyes & Lichty, [page 262](https://archive.org/details/0893037893ProgrammingThe65816/page/262)
3. lbid, [page 44](https://archive.org/details/0893037893ProgrammingThe65816/page/44)
4. Eyes & Lichty, [page 148](https://archive.org/details/0893037893ProgrammingThe65816/page/148)
5. Pickens, John. NMOS 6502 Opcodes. [http://www.6502.org/tutorials/6502opcodes.html#DFLAG](http://www.6502.org/tutorials/6502opcodes.html#DFLAG)
6. Clark, Bruce. [http://www.6502.org/tutorials/decimal\_mode.html](http://www.6502.org/tutorials/decimal_mode.html)
7. Table 7-1 Caveats of 65c816 datasheet
8. [http://www.righto.com/2023/01/understanding-x86s-decimal-adjust-after.html?m=1](http://www.righto.com/2023/01/understanding-x86s-decimal-adjust-after.html?m=1)
