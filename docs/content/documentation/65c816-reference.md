---
title: "Super NES Programming/65c816 reference"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/65c816_reference
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:16:28-08:00
---

[Wikipedia](https://en.wikipedia.org/wiki/ "w:") has related information at [***65816***](https://en.wikipedia.org/wiki/65816 "wikipedia:65816").

## Internal Registers

bits *Register* *Description* 8 or 16 A The accumulator. This is the math register. It stores one of two operands or the result of most arithmetic and logical operations. 8 or 16 X, Y The index registers. These can be used to reference memory, to pass data to memory, or as counters for loops. 16 S The stack pointer, points to the next available(unused) location on the stack. 8 DBR Data bank register, holds the default bank for memory transfers. 16 D Direct page register, used for direct page addressing modes. 8 PBR Program Bank, holds the bank address of all instruction fetches. 8 P Processor Status, holds various important flags, see below. 16 PC Program counter

##### Flags stored in P register

*Mnemonic* *Value* *Binary Value* *Description* N #$80 10000000 Negative Condition codes used for branch instructions. V #$40 01000000 Overflow Z #$02 00000010 Zero C #$01 00000001 Carry D #$08 00001000 Decimal I #$04 00000100 IRQ disable X #$10 00010000 Index register size (native mode only)

(0 = 16-bit, 1 = 8-bit)

M #$20 00100000 Accumulator register size (native mode only)

(0 = 16-bit, 1 = 8-bit)

E not in P 6502 emulation mode B #$10 00010000 Break (emulation mode only)

## Instructions

### Arithmetic and Logical Instructions

*Instruction* *Description* *Arguments* *Flags set* ADC Add A with something and carry bit. Result is put in A. Immediate value or address n,v,z,c Arithmetic instructions SBC Subtract something and the carry bit. n,v,z,c AND AND A with memory, storing result in A. Immediate value or address n,z Logical instructions EOR Exclusive or n,z ORA OR A with memory, storing result in A. Immediate value or address n,z TSB Test and set bits z TRB Test and reset bits z ASL Arithmetic shift left A or address n,z,c Shift instructions LSR Logical shift right A or address n,z,c ROL Rotate left A or address n,z,c ROR Rotate right A or address n,z,c BIT test bits, setting immediate value or address n,v,z (only z if in immediate mode) Test instructions CMP Compare accumulator with memory n,z,c CPX Compare register X with memory n,z,c CPY Compare register Y with memory n,z,c DEA Decrement Accumulator n,z DEC Decrement, *see INC* n,z DEX Decrement X register n,z DEY Decrement Y register n,z INA Increment Accumulator n,z INC Increment, *see DEC* n,z INX Increment X register n,z INY Increment Y register n,z NOP No operation none XBA Exchange bytes of accumulator n,z

### Load/Store Instructions

*Instruction* *Description* LDA Load accumulator from memory LDX Load register X from memory LDY Load register Y from memory STA Store accumulator in memory STX Store register X in memory STY Store register Y in memory STZ Store zero in memory

### Transfer Instructions

*Instruction* *Description* *Flags affected* TAX Transfer Accumulator to index register X n,z TAY Transfer Accumulator to index register Y n,z TCD Transfer 16-bit Accumulator to Direct Page register n,z TCS Transfer 16-bit Accumulator to Stack Pointer none TDC Transfer Direct Page register to 16-bit Accumulator n,z TSC Transfer Stack Pointer to 16-bit Accumulator n,z TSX Transfer Stack Pointer to index register X n,z TXA Transfer index register X to Accumulator n,z TXS Transfer index register X to Stack Pointer none TXY Transfer index register X to index register Y n,z TYA Transfer index register Y to Accumulator n,z TYX Transfer index register Y to index register X n,z

### Branch Instructions

*Instruction* *Description* BCC Branch if Carry flag is clear (C=0) BCS Branch if Carry flag is set (C=1) BNE Branch if not equal (Z=0) BEQ Branch if equal (Z=1) BPL Branch if plus (N=0) BMI Branch if minus (N=1) BVC Branch if overflow flag is clear (V=0) BVS Branch if overflow flag is set (V=1) BRA Branch Always (unconditional) BRL Branch Always Long (unconditional)

### Jump and call instructions

*Instruction* *Description* JMP Jump JML Jump long JSR Jump and save return address JSL Jump long and save return address RTS Return from subroutine RTL Return long from subroutine

### Interrupt instructions

*Instruction* *Description* BRK Generate software interrupt COP Generate coprocessor interrupt RTI Return from interrupt STP Stop processor until RESET WAI Wait for hardware interrupt

### P Flag instructions

*Instruction* *Description* CLC Clear carry flag CLD Clear decimal flag (binary arithmetic) CLI Enable interrupt requests CLV Clear overflow flag REP Reset status bits (for example *REP #%00100000* clears the M flag) SEC Set carry flag SED Set decimal flag (decimal arithmetic) SEP Set status bits (for example *SEP #%00010000* sets the X flag) SEI Disable interrupt requests XCE Exchange carry flag with emulation flag

### Stack Instructions

*Instruction* *Description* PHA Push Accumulator *Push instructions* PHX Push index register X PHY Push index register Y PHD Push direct page register PHB Push data bank register PHK Push Program Bank Register PHP Push processor status PEA Push effective address PEI Push effective indirect address PER Push effective relative address PLA Pull Accumulator *Pull instructions* PLX Pull index register X PLY Pull index register Y PLP Pull processor status PLD Pull direct page register PLB Pull data bank register

- [65816 Opcode Table](http://www.defence-force.org/computing/oric/coding/annexe_2/index.htm).

## Addressing modes

**Mode** **Example** Implied PHB Immediate\[MemoryFlag] AND #1 or 2 bytes Immediate\[IndexFlag] LDX #1 or 2 bytes Immediate\[8-Bit] SEP #byte Relative BEQ byte *(signed)* Relative long BRL 2bytes *(signed)* Direct AND byte Direct indexed (with X) AND byte, x Direct indexed (with Y) AND byte, y Direct indirect AND (byte) Direct indexed indirect AND (byte, x) Direct indirect indexed AND (byte), y Direct indirect long AND \[byte] Direct indirect indexed long AND \[byte], y Absolute AND 2bytes Absolute indexed (with X) AND 2bytes, x Absolute indexed (with Y) AND 2bytes, y Absolute long AND 3bytes Absolute indexed long AND 3bytes, x Stack relative AND byte, s Stack relative indirect indexed AND (byte, s), y Absolute indirect JMP (2bytes) Absolute indirect long JML \[2bytes] Absolute indexed indirect JMP/JSR (2bytes,x) Implied accumulator INC Block move MVN/MVP byte, byte

## External links

- [A 6502 Programmer's Introduction to the 65816](http://www.defence-force.org/computing/oric/coding/annexe_2/)
- [Programming the 65816](http://www.westerndesigncenter.com/wdc/datasheets/Programmanual.pdf)
- [65816 Primer](http://softpixel.com/~cwright/sianse/docs/65816NFO.HTM)
