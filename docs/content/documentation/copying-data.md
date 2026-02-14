---
title: "Copying data"
reference_url: https://ersanio.gitbook.io/assembly-for-the-snes/collection-of-values/moves
categories:
  - "Documentation"
downloaded_at: 2026-02-13T20:23:48-08:00
---

65c816 assembly has two opcodes dedicated to moving huge blocks of data from one memory location to another.

Opcode

Full name

Explanation

**MVN**

Move block negative

Moves a block of data, byte by byte, starting from the beginning and working towards the end

**MVP**

Move block positive

Moves a block of data, byte by byte, starting from the end and working towards the beginning

MVP and MVN practically do a mass amount of LDA and STA to some RAM addresses. You can't move data to ROM, because ROM is read-only.

It's highly recommended to have the A, X and Y registers at 16-bit mode. It's also highly recommended to preserve the data bank using the stack, as the move opcodes implicitly change this. Here's an example of a proper block move setup:

Copy

```
PHB                ; Preserve data bank
REP #$30           ; 16-bit AXY
                   ; ← Move instructions are located here
SEP #$30           ; 8-bit AXY
PLB                ; Recover data bank
```

## [hashtag](#mvn) MVN

When using MVN, the three main registers all have a special purpose.

Register

Purpose

A

Specifies the amount of bytes to transfer, plus 1

X

Specifies the high and low bytes of the data source memory address

Y

Specifies the high and low bytes of the destination memory address

The A register is "plus 1". This means that if you want to move 4 bytes of data, you load $0003, as this means $0003+1, thus 4 bytes.

MVN can be written in two ways:

Where `xx` is the source bank, and `yy` is the destination bank.

When executing the MVN opcode, the SNES stalls at that same opcode for each byte transferred. When a byte is transferred, the following happens:

Register

Event

A

Decreases by 1

X

Increases by 1

Y

Increases by 1

Data bank

Is set to the bank of the destination address

Seeing that A decreases by 1, eventually it will reach the value $0000, then it'll wrap to $FFFF. Once that wrap happens, the block move finishes and the SNES proceeds to execute the opcodes that follow.

Here's an example of a block move:

This example will move 5 bytes of data from address $1F8098 to $7FA000.

## [hashtag](#mvp) MVP

When using MVP, the three main registers all have a special purpose.

Register

Purpose

A

Specifies the amount of bytes to transfer, plus 1

X

Specifies the high and low bytes of the data source memory address

Y

Specifies the high and low bytes of the destination memory address

The A register is "plus 1". This means that if you want to move 4 bytes of data, you load $0003, as this means $0003+1, thus 4 bytes.

MVP can be written in two ways:

Where `xx` is the source bank, and `yy` is the destination bank.

circle-exclamation

Note that the `MVP/MVN $yy, $xx` notation is indeed written as `MVP/MVN destination, source`. Various sources indicate that it should be the other way around (`source, destination`), however, this tutorial follows Asar's assembly syntax.

When executing the MVP opcode, the SNES loops at that same opcode for each byte transferred. From this point on, this is where MVP differs from MVN. When a byte is transferred, the following happens:

Register

Event

A

Decreases by 1

X

Decreases by 1

Y

Decreases by 1

Data bank

Is set to the bank of the destination address

Considering that X and Y decrease, rather than increase, this means that MVP moves blocks of data from the end towards the beginning.

Here's an example of a block move:

This example will move 5 bytes of data from address $1F8904 to $7F9FFC. Although the transfer happens backwards, the transferred data isn't reversed. It still copies over as you'd expect.

## [hashtag](#edge-cases) Edge cases

- When you set the A register to $0000, it means you will move 1 byte.
- When you set the A register to $FFFF, it means you will move 65536 bytes.
- When either the source or destination addresses cross a bank boundary, the high and low bytes reset to $0000, while the data bank remains unchanged.

## [hashtag](#easy-notation) Easy notation

Asar supports labels as parameters for LDA, LDX and LDY, so you can write block moves without having to calculate the source table size or address locations. The following examples allow for tables of all sizes, and assume the destination to be memory address $7FA000.

An example for MVN:

An example for MVP:

As you can see, MVP is considerably more complicated to setup.

[PreviousThe stack](/assembly-for-the-snes/collection-of-values/stack)[NextThe processor flags](/assembly-for-the-snes/processor-flags-and-registers/flags)

Last updated 4 years ago
