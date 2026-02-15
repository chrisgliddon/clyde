---
title: "ALT0"
reference_url: https://sneslab.net/wiki/ALT0
categories:
  - "ASM"
  - "Super_FX"
  - "Scene_Slang"
downloaded_at: 2026-02-14T10:48:02-08:00
cleaned_at: 2026-02-14T17:51:03-08:00
---

**ALT0** is scene slang for the Super FX state where both the ALT1 and ALT2 flags are clear. Many instructions restore the ALT0 state, including:

- ADC Rn
- ADC #n
- ADD Rn
- ADD #n
- AND Rn
- AND #n
- ASR
- BIC Rn
- BIC #n
- CACHE
- CMODE
- CMP Rn
- COLOR
- DEC Rn
- DIV2
- FMULT
- GETB
- GETBH
- GETBL
- GETBS
- GETC
- HIB
- IBT Rn, #pp
- INC Rn
- IWT Rn, #xx
- JMP Rn
- LDB (Rm)
- LDW (Rm)
- LEA Rn, xx
- LINK #n
- LJMP Rn
- LM Rn, (xx)
- LMS Rn, (yy)
- LMULT
- LOB
- LOOP
- LSR
- MERGE
- MOVE Rn, Rn'
- MOVES Rn, Rn'
- MULT Rn
- MULT #n
- NOP
- NOT
- OR Rn
- OR #n
- PLOT
- RAMB
- ROL
- ROMB
- ROR
- RPIX
- SBC Rn
- SBK
- SEX
- SM (xx), Rn
- SMS (yy), Rn
- STB (Rm)
- STOP
- STW (Rm)
- SUB Rn
- SUB #n
- SWAP
- UMULT Rn
- and presumably UMULT #n and XOR too

### See Also

- ALT3
- Super\_FX\_Opcode\_Matrices#ALT1\_=\_0,\_ALT2\_=\_0

### References

- ares source: [https://github.com/ares-emulator/ares/blob/master/ares/component/processor/gsu/disassembler.cpp#L37](https://github.com/ares-emulator/ares/blob/master/ares/component/processor/gsu/disassembler.cpp#L37)
- Table 2-4-2 on [page 2-4-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n110) of the official Super Nintendo development manual
