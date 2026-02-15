---
title: "Processor Status Register"
reference_url: https://sneslab.net/wiki/Processor_Status_Register
categories:
  - "Registers"
  - "Flags"
  - "ASM"
downloaded_at: 2026-02-14T16:00:12-08:00
cleaned_at: 2026-02-14T17:53:59-08:00
---

The **Processor Status Register** (P) is on the 65c816 and contains several flags:

- 7: Negative Flag - N
- 6: Overflow Flag - V
- 5: Memory/Accumulator Select - M
- 4: Index Register Select - X
- 3: Decimal Mode - D
- 2: Interrupt Disable Flag - I
- 1: Zero Flag - Z
- 0: Carry Flag - C

It can be pulled from the stack via PLP and RTI. To push it to the stack, use PHP. COP and BRK also push it to the stack.

There are nine instructions that directly modify these flags, including:\[3]

- REP (can clear multiple)
- SEP (can set multiple)
- CLC
- SEC
- CLD
- SED
- CLI
- SEI
- CLV

LDP does not exist, and STP does not store the register anywhere despite looking like it could stand for "store P" like other store commands.

Several other instructions affect the flags as a side effect. The only transfer instructions that do not modify these flags are TCS and TXS.

These instructions do not modify any status flags:

- BCC
- BCS
- BEQ
- BMI
- BNE
- BPL
- BRA
- BRL
- BVC
- BVS
- JMP
- JSL
- JSR
- MVN
- MVP
- NOP
- PEA
- PEI
- PER
- PHA
- PHB
- PHD
- PHK
- PHP (fullsnes claims the break flag is set)
- PHX
- PHY
- RTL
- RTS
- STA
- STP
- STX
- STY
- STZ
- TCS
- TXS
- WAI
- WDM

### See Also

- Emulation Mode Flag
- Program Status Word
- DSP1 Status Register

### References

1. Table 18.2 Eyes & Lichty, [page 422](https://archive.org/details/0893037893ProgrammingThe65816/page/422)
2. Figure 17.3, Lbid, [page 377](https://archive.org/details/0893037893ProgrammingThe65816/page/377)
3. lbid, Status Register Control Instructions, [page 262](https://archive.org/details/0893037893ProgrammingThe65816/page/262)
4. lbid, [page 29](https://archive.org/details/0893037893ProgrammingThe65816/page/29)
