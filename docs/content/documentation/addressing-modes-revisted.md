---
title: "Addressing modes revisted"
reference_url: https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/addressing
categories:
  - "Documentation"
downloaded_at: 2026-02-13T20:24:37-08:00
---

In the [basic addressing modes](/assembly-for-the-snes/the-fundamentals/addressing) chapter, we briefly looked at the most commonly used addressing modes: "Immediate 8-bit and 16-bit", "direct page", "absolute" and "long". In this chapter, we will look at the more advanced addressing modes: "indirect", "indexed" and "stack relative". These advanced addressing modes expand upon the earlier introduced addressing modes. This chapter also introduces the concept of pointers.

## [hashtag](#pointers) Pointers

This is where "pointers" come into play. Pointers are values which pretty much "point" to a certain memory location. Imagine the following SNES memory:

Copy

```
         ; $7E0000: 12 80 00 55 55 55 ..
```

In this example: the RAM at address $7E0000 contains the values $12, $80 and $00. This is in little-endian, so reverse the values and you get $00, $80, $12. Treat this as a 24-bit "long" address and you have $008012. This means that RAM address $7E0000 has a 24-bit pointer to $008012. This is what "indirect" is; accessing address $7E0000 "indirectly" accesses address $008012.

You can access indirect pointers in two ways: 16-bits and 24-bits. They have a special assembler syntax:

Syntax

Terminology

Pointer size

( )

Indirect

16-bit

\[ ]

Indirect long

24-bit

The bank byte of the 16-bit pointer depends on the type of instruction. When it comes to a `JSR`-opcode, which can only jump inside the current bank, the bank byte isn"t determined nor used. However, when it comes to a loading instruction, such as `LDA`, the bank byte is determined by the *data bank register*.

Pointers can point to both *code* and *data*. Depending on the type of instruction, the pointers are accessed differently. For example, a `JSR` which utilizes a 16-bit pointer accesses the pointed location as code, while an `LDA` accesses the pointed location as a bank.

## [hashtag](#indirect) Indirect

Indirect addressing modes are basically accessing addresses in such a way, that you access the address they point to, rather than directly accessing the contents of the specified address.

### [hashtag](#direct-indirect) Direct, Indirect

As contradicting as it may sound, the naming actually makes sense. "Direct" stands for direct page addressing mode, while "indirect" means that we're accessing a pointer at the direct page address, rather than a value. Here's an example:

This accesses a 16-bit pointer at address $000000, due to the nature of direct page always accessing bank $00. Due to the effects of mirroring in the SNES mirroring, practically speaking, this accesses a 16-bit pointer at RAM $7E0000.

You might think that `LDA ($00)` loads the `value $1FFF` into A. However, it doesn't work that way. It loads the `value in address $1FFF` into A, because we use an indirect addressing mode.

As we established earlier, parentheses denote 16-bit pointers. The bank of the indirect address, in the case of an LDA, depends on the data bank register. As a result, the `LDA ($00)` resolves into `LDA $1FFF`.

### [hashtag](#direct-indexed-with-x-indirect) Direct Indexed with X, Indirect

As is the case with the previous addressing mode, the naming may seem contradicting. "Direct" stands for direct page addressing mode. "Indexed with X" means that this direct page address is indexed with X. "Indirect" means that the previous elements are treated as an indirect address. Here's an example usage:

- The 16-bit value in address $7E0000 + $7E0001 is `$1FFF`.
- The 16-bit value in address $7E0002 + $7E0003 is `$0FFF`.

Thanks to using X as an indexer to the direct page address, `LDA ($00,x)` is resolved into `LDA ($02)`. This then resolves into `LDA $0FFF` because RAM $7E0002 points to `address $0FFF`.

### [hashtag](#direct-indirect-indexed-with-y) Direct, Indirect Indexed with Y

This is practically the same as `Direct, Indirect` but the pointer is then indexed with the Y register:

As a result, `LDA ($00),y` resolves into `LDA $1FF0,y`, which then resolves into `LDA $1FF1` because Y contains the value $01.

### [hashtag](#absolute-indirect) Absolute, Indirect

Exactly the same as `Direct, Indirect`, except the specified address is now 16-bit instead of 8-bit. This addressing mode is only used by jumping instructions. Example:

This has the same exact effect as the example in `Direct, Indirect`. As a result, the `JMP ($0000)` resolves into `JMP $8000`, thus jumps to `address $8000` in the current bank.

### [hashtag](#absolute-indexed-with-x-indirect) Absolute Indexed with X, Indirect

Exactly the same as `Direct Indexed with X, Indirect`, except the specified address is now 16-bit instead of 8-bit. This addressing mode is only used by jumping instructions. Example:

- The 16-bit value in address $7E0000 + $7E0001 is `$8000`.
- The 16-bit value in address $7E0002 + $7E0003 is `$9000`.

Thanks to using X as an indexer to the direct page address, `JMP ($0000,x)` is resolved into `JMP ($0002)`. This then resolves into `JMP $9000` because RAM $7E0002 points to `address $9000`. This addressing mode is handy for jump tables.

### [hashtag](#direct-indirect-long) Direct, Indirect Long

Exactly the same as `Direct, Indirect`, except the pointer located at an address is now 24-bits instead of 16-bits, meaning the bank byte of a pointer is also specified. Example:

`LDA [$00]` resolves into `LDA $7F1FFF`.

### [hashtag](#direct-indirect-indexed-long-with-y) Direct, Indirect Indexed Long with Y

Exactly the same as `Direct, Indirect Indexed with Y`, except the pointer located at an address is now 24-bits instead of 16-bits, meaning the bank byte of a pointer is also specified. Example:

As a result, `LDA [$00],y` resolves into `LDA $7F1FF0,y` (practically speaking), which then resolves into `LDA $7F1FF1` because Y contains the value $01.

## [hashtag](#indexed) Indexed

Indexed addressing mode was actually briefly touched upon in an [earlier chapter](/assembly-for-the-snes/collection-of-values/indexing). This chapter will discuss all the possible indexed addressing modes.

### [hashtag](#direct-indexed-with-x) Direct, Indexed with X

This addressing mode indexes a direct page address with X. Example:

### [hashtag](#direct-indexed-with-y) Direct, Indexed with Y

This addressing mode indexes a direct page address with Y. This addressing mode only exists on the `LDX` and `STX`-opcodes. Example:

### [hashtag](#absolute-indexed-with-x) Absolute, Indexed with X

This addressing mode indexes an absolute address with X. Example:

### [hashtag](#absolute-indexed-with-y) Absolute, Indexed with Y

This addressing mode indexes an absolute address with Y. Example:

### [hashtag](#absolute-long-indexed-with-x) Absolute, Long Indexed with X

This addressing mode indexes a long address with X. Example:

## [hashtag](#stack-relative) Stack Relative

Stack relative is a special type of an indexing addressing mode. It uses the stack pointer register as a 16-bit index, rather than using the X or Y register. The index is **always** 16-bit, regardless of the register size of A, X and Y.

### [hashtag](#stack-relative-1) Stack Relative

This loads a value from the RAM, relative to the stack pointer. The bank byte is always $00. Example:

In 16-bit A mode, these instructions would read 16-bit values, rather than 8-bit values. If you don't use increments of 2, you'll start reading overlapping values.

### [hashtag](#stack-relative-indirect-indexed-with-y) Stack Relative, Indirect Indexed with Y

This is pretty much the same as `Direct, Indirect Indexed with Y`, except the value is loaded from a stack relative address. Example:

`$01,s` refers to the last pushed value into A, which is $0100 in the case of this example. The parentheses applies on this stack relative address, resolving the instruction to an `LDA $0100,y`. This finally resolves into `LDA $0103` because of the indexer.

This addressing mode is handy if you'd like to treat certain pushed values as an indexed memory address.

[PreviousHardware math](/assembly-for-the-snes/mathemathics-and-logic/math)[NextMiscellaneous opcodes](/assembly-for-the-snes/deep-dives/misc)

Last updated 4 years ago
