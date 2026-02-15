---
title: "Emulation Mode Flag"
reference_url: https://sneslab.net/wiki/Emulation_Mode_Flag
categories:
  - "SNES_Hardware"
  - "ASM"
  - "Flags"
  - "65c816_additions"
downloaded_at: 2026-02-14T11:56:38-08:00
cleaned_at: 2026-02-14T17:54:12-08:00
---

The **Emulation Mode Flag** (E) controls whether the 65c816 is behaving like a 6502:

- When clear, the '816 is in **65c816 native mode.**
- When set, the '816 is in **6502 emulation mode.**

This flag cannot be modified directly and is normally hidden from the programmer. To modify it, use the XCE instruction to swap its value with the carry flag's value. This treats the status register bits as a game of musical chairs.

The designers likely omitted CLE and SEE opcodes to set or clear it directly because dedicating two opcodes to such a rare operation is overkill.

The flag is set when a RESET interrupt is fired. In other words, the CPU always starts in emulation mode at boot and after a reset.

Emulation mode is not perfect. Some important behavior differences from the 6502 are:

- The 65c816 does not attempt to emulate the illegal 6502 opcodes because its opcode matrix is already full. All 256 opcodes work in both native and emulation mode, but many are less useful in emulation mode.\[3]
- The direct page is fully relocatable in both native and emulation mode even though it doesn't exist on the 6502, so pointing it to the zero page right before running 6502 code is advised to ensure maximum compatibility
- Direct page indexed addressing will always wrap around and remain within the direct page in emulation mode, instead of possibly crossing over into the next page. (E&L, [page 374](https://archive.org/details/0893037893ProgrammingThe65816/page/374))
- The program bank register and data bank register still exist in emulation mode even though they don't exist on a 6502, so memory accesses may not always access bank zero.
- the hidden B accumulator still exists in emulation mode even though it does not on a 6502
- (*very rare)* 6502 code trying to load the word straddling the end of the 16-bit address space will instead cross over into the next bank in emulation mode.\[5]

For writing new SNES code it is recommended to almost always stay in native mode even if dealing with 8 bit data. Some reasons are:

- Page boundary crossings incur a one cycle penalty in emulation mode. Emulation mode emulates the NMOS 6502 cycle counts.
- Large amounts of 8-bit data can sometimes be processed in 16-bit chunks, and doing so can take fewer loads/stores/transfers than treating them as 8-bit.
- The break flag need not be examined in native mode because there are more interrupt vectors. (In fact, it does not even exist).

On the other hand, COP, BRK, and RTI take one extra cycle in native mode because of the bank number. For running 6502 code with minimal issues it is still recommended to use emulation mode. For example, one quirk of 8-bit native mode is that TXS points the stack to the zeropage.

Emulation code need not be in bank 0.

In emulation mode, the stack pointer's high byte is always one. The M and X flags are always set in emulation mode.\[4]

### See Also

- SA-1

### References

1. Figure 17.3, Eyes & Lichty, [page 377](https://archive.org/details/0893037893ProgrammingThe65816/page/377)
2. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#APPENDIX](http://www.6502.org/tutorials/65c816opcodes.html#APPENDIX)
3. section 7.8 of 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
4. section 2.8, lbid.
5. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.12](http://www.6502.org/tutorials/65c816opcodes.html#5.12)
