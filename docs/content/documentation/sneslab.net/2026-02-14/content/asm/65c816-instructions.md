---
title: "65c816 Instructions"
reference_url: https://sneslab.net/wiki/65c816_Instructions
categories:
  - "ASM"
downloaded_at: 2026-02-14T10:44:47-08:00
cleaned_at: 2026-02-14T17:50:55-08:00
---

There are 92 opcodes in ASM. They are divided into different categories.

## Loading instructions

These instructions load an 8-bit or a 16-bit value into one of the three registers.

Instruction Description LDA Load into accumulator from memory LDX Load into X from memory LDY Load into Y from memory

## Compare instructions

These instructions, usually used with branch commands, compare one of the three registers with a value or memory. (They essentially subtract the value following the compare instruction from the value in the register, affecting the processor flags but not the register itself.)

Instruction Description CMP Compare accumulator with memory CPY Compare Y with memory CPX Compare X with memory

## Storage instructions

These instructions store various values from a register into memory.

Instruction Description STA Store Accumulator to Memory STX Store X to Memory STY Store Y to Memory STZ Store Zero to Memory

## Branching instructions

These instructions branch depending on the processor flags' status, except BRA and BRL, which always branch regardless of the processor flags.

Instruction Description BCC Branch if Carry Clear BCS Branch if Carry Set BPL Branch if Plus value BMI Branch if Minus value BNE Branch if not Equal/Branch if not zero BEQ Branch if Equal/Branch if zero BVC Branch if Overflow Clear BVS Branch if Overflow Set BRL Branch Always Long BRA Branch Always

## Mathematical instructions

These instructions perform addition and subtraction with the registers and memory. (Note that there are no opcodes for multiplication and division; special registers must be used for those.)

Instruction Description ADC Add with carry SBC Subtract with Carry INC Increment Accumulator or Memory INX Increment X INY Increment Y DEC Decrement Accumulator or Memory DEX Decrement X DEY Decrement Y

## Processor flag instructions

These instructions set or clear various processor flags of the SNES.

Instruction Description SEP Set Processor Status Flag REP Reset Processor Status Flag SEC Set Carry Flag SED Set Decimal Flag SEI Set Interrupt Flag CLC Clear Carry Flag CLD Clear Decimal Flag CLI Clear Interrupt Flag CLV Clear Overflow Flag XCE Exchange Carry and Emulation (swaps bits of emulation flag and carry flag, toggling emulation mode on/off)

## Stack instructions

These instructions push and pull various bytes on/from the stack, a special designated area of RAM that is located at $01FF-$010B in SMW.

Instruction Description PEA Push Effective Address (Simply push a 16-bit absolute value on the stack) PEI Push Effective Indirect Address PER Push Program Counter Relative PHA Push Accumulator PHB Push Data Bank Register PHD Push Direct Page Register PHK Push Program Bank Register PHP Push Processor Status Flags PHX Push X PHY Push Y PLA Pull Accumulator PLB Pull Data Bank Register PLD Pull Direct Page Register PLP Pull Processor Status Flags PLX Pull X PLY Pull Y

## Bitwise instructions

These operations affect the individual bits of A and/or memory.

Instruction Description AND AND Accumulator with Memory ASL Left Shift Accumulator or Memory BIT Bit Test EOR Exclusive OR Accumulator with Memory LSR Shift Right Accumulator or Memory ORA OR Accumulator with Memory ROL Rotate Left Accumulator or Memory ROR Rotate Right Accumulator or Memory TRB Test and Reset Bit TSB Test and Set Bit

## Transfer instructions

These opcodes transfer values from register to register (or, in the case of MVN and MVP, from memory to memory).

Instruction Description TAX Transfer Accumulator to X TAY Transfer Accumulator to Y TCD Transfer Accumulator to Direct Page TCS Transfer Accumulator to Stack pointer TDC Transfer Direct Page to Accumulator TSC Transfer Stack Pointer to Accumulator TSX Transfer Stack Pointer to X TXA Transfer X to Accumulator TXS Transfer X to Stack Pointer TXY Transfer X to Y TYA Transfer Y to Accumulator TYX Transfer Y to X MVN Block Move Negative MVP Block Move Positive

## Program flow instructions

These instructions jump into some other part of the ROM/RAM.

Instruction Description JML Jump Long JMP Jump JSL Jump to Subroutine Long JSR Jump to Subroutine RTI Return from Interrupt RTL Return from Subroutine Long RTS Return from Subroutine

## Other instructions

These are other misc. opcodes.

Instruction Description BRK Software Break (Sets the B flag in emulation mode, interrupt in native) COP Coprocessor Empowerment (interrupt) NOP No operation (does absolutely nothing except waste two cycles of processing time) STP Stop the Clock (freezes the SNES's processor) WAI Wait for Interrupt WDM Reserved - No operation XBA Exchanges low and high byte of the A register
