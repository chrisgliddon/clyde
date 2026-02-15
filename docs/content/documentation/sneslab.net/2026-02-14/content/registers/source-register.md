---
title: "Source Register"
reference_url: https://sneslab.net/wiki/Source_Register
categories:
  - "Super_FX"
  - "ASM"
downloaded_at: 2026-02-14T16:47:32-08:00
cleaned_at: 2026-02-14T17:54:00-08:00
---

The **Source Register** (Sreg) exists on the Super FX. It is assigned with FROM or WITH. It supplies the input for many instructions, including:

- ADC Rn
- ADC #n
- ADD Rn
- ADD #n
- AND Rn
- AND #n
- ASR
- BIC Rn
- BIC #n
- CMODE
- CMP Rn
- COLOR
- DIV2
- FMULT
- GETBH
- GETBL
- HIB
- LJMP
- LMULT
- LOB
- LSR
- MULT Rn
- MULT #n
- NOT
- OR Rn
- OR #n
- RAMB
- ROL
- ROMB
- ROR
- SBC Rn
- SBK
- SEX
- STB
- STW
- SUB Rn
- SUB #n
- SWAP
- UMULT

Any register from R0 to R15 can serve as Sreg. R0 is the default.

Some instructions ignore the source register. No instructions modify its value.

### See Also

- Destination Register
