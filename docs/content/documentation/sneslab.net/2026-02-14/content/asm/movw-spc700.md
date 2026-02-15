---
title: "MOVW (SPC700)"
reference_url: https://sneslab.net/wiki/MOVW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Data_Transmission_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T13:48:52-08:00
cleaned_at: 2026-02-14T17:52:27-08:00
---

Basic Info **Direction** **Addressing Mode** **Opcode** **Length** **Speed** to YA Direct Page BA 2 bytes 5 cycles from YA Direct Page DA 2 bytes 4 cycles

Flags Affected Direction N V P B H I Z C to YA N . . . . . Z . from YA . . . . . . . .

**MOVW** (Move Word) is an SPC700 instruction that moves a 16-bit direct page value to or from the YA register. There are no variations of MOVW that do not operate on YA. MOVW performs a read cycle on the low byte of the destination, but not the source.\[2]

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

### Example

From the IPL ROM,

```
MOVW YA, $F6	; load the byte at direct page location $F6 into A and the byte at direct page location $F7 into Y
MOVW $00, YA	; store the value in Y to direct page location $01 and the value in A to direct page location $00
```

### See Also

- MOV
- MOV1
- ADDW
- SUBW
- CMPW

### References

1. Official Super Nintendo development manual on MOVW: Table C-11 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
2. [anomie's SPC700 doc](https://www.romhacking.net/documents/197)
