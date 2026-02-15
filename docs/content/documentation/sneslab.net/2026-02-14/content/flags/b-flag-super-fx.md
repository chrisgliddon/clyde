---
title: "B Flag (Super FX)"
reference_url: https://sneslab.net/wiki/B_Flag_(Super_FX)
categories:
  - "Flags"
  - "Super_FX"
  - "ASM"
downloaded_at: 2026-02-14T11:07:26-08:00
cleaned_at: 2026-02-14T17:53:50-08:00
---

The **B Flag** is on the Super FX, and is set when WITH runs. It is bit 4 of SFR.

These instructions change their behaviour on the B flag:

- TO Rn' as MOVE Rn,Rn'
- FROM Rn' as MOVES Rn,Rn'

For both of them, the Rn is set by the preceeeding WITH Rn.

Many instructions clear the B flag, including:

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
- and presumably UMULT #n too

### See Also

- Dither Flag
- Break Flag
- ALT1
- ALT2
- ALT0

### References

- [page 2-9-2 of Book II](https://archive.org/details/SNESDevManual/book2/page/n158) of the official Super Nintendo development manual
- [page 2-4-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n110), lbid.
