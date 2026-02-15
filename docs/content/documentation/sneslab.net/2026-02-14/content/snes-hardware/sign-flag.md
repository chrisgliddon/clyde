---
title: "Sign Flag"
reference_url: https://sneslab.net/wiki/Sign_Flag
categories:
  - "SNES_Hardware"
  - "Flags"
downloaded_at: 2026-02-14T16:45:25-08:00
cleaned_at: 2026-02-14T17:54:35-08:00
---

The **Sign Flag** (S) exists on the Super FX. It is bit 11 of SFR. It is affected by the following instructions:

- ADC Rn
- ADC #n
- ADD Rn
- ADD #n
- AND Rn
- AND #n
- ASR
- BIC Rn
- BIC #n
- CMP Rn
- DEC Rn
- DIV2
- FMULT
- HIB
- INC Rn
- LMULT
- LOB
- LOOP
- LSR
- MERGE
- MOVES Rn, Rn'
- MULT Rn
- MULT #n
- NOT
- OR Rn
- OR #n
- ROL
- ROR
- RPIX
- SBC Rn
- SEX
- SUB Rn
- SUB #n
- SWAP
- UMULT Rn

It affects the behavior of the following instructions:

- BGE
- BLT
- BMI
- BPL

### See Also

- CY
- O/V
- BMI (Super FX)
- BPL (Super FX)
- Negative Flag

### References

- 9.3 on [page 2-9-2 of Book II](https://archive.org/details/SNESDevManual/book2/page/n158) of the official Super Nintendo development manual
- Table 2-4-2 on [page 2-4-4](https://archive.org/details/SNESDevManual/book2/page/n110), lbid.
