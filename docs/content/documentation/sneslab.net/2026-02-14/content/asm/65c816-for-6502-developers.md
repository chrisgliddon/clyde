---
title: "65c816 for 6502 developers"
reference_url: https://sneslab.net/wiki/65c816_for_6502_developers
categories:
  - "ASM"
downloaded_at: 2026-02-14T10:45:16-08:00
cleaned_at: 2026-02-14T17:50:55-08:00
---

This guide is meant to introduce the 65c816 to someone who is already familiar with the 6502. NES developers should be able to pick up the new things introduced by this processor pretty easily. You can view the 65c816 as a superset of the 6502. Most 6502 code will continue to work on it without changes (provided only official instructions are used), but this guide intends to highlight some differences that you should be aware of. It's not intended to be comprehensive and you should look at more complete 65c816 documentation later on, like maybe [this](http://www.6502.org/tutorials/65c816opcodes.html).

## 16-bit registers!

The biggest, most obvious change from the 6502 is that it can do 16-bit operations. To enable this, the accumulator and index registers can change between being 8-bit and 16-bit. Sort of. I'll go into more detail in the following sections.

Two additional flags are added to the flags register to control register size. One flag ("M") controls the size of accumulator operations, as well as read-modify-write operations like `INC` or `ASL` directly on a memory location. Another flag ("X") controls the size of both the X and Y index registers.

Instead of getting dedicated instructions like `SEC`/`CLC`, register sizes are changed with the new `REP` and `SEP` instructions. They take an 8-bit immediate operand and REset or SEt bits in the flags register. You can set and reset multiple bits at once, you just have to OR them together. For example `SEP #$30` sets M and X simultaneously. One potentially confusing thing is that M and X indicate bigger registers when *clear* rather than when set.

REP/SEP valueFlagPurpose #$01CCarry #$02ZZero #$04IInterrupt disable #$08DDecimal mode #$10X8-bit index registers #$20M8-bit accumulator/memory #$40VOverflow #$80NNegative

Personally I find it more friendly to change register sizes with macros, though you can certainly use `REP`/`SEP` directly if you wish (and may want to if you want to change register size at the same time as one or more other flags in the same instruction, for example putting carry into a known state for `ADC`/`SBC`). For the usual case though, macros let me avoid caring about what number corresponds to what flag, so I can just write `seta8`, `setxy16,` `setaxy16` and more in my code. There are some ca65 versions of these macros in [lorom-template](https://github.com/pinobatch/lorom-template/blob/master/src/snes.inc).

One very important thing to consider with register sizes is that the size of an immediate operand changes too! This means that you need to let the assembler know if immediate values should be 8-bit or 16-bit. It seems like most assemblers make you specify the size of each immediate value, but ca65 works differently here. ca65 provides `.a8`, `.a16`, `.i8` and `.i16` directives that change the size of all immediate values that follow the directive. There's also an optional feature (named [.smart](https://cc65.github.io/doc/ca65.html#ss11.102)) that allows `REP`/`SEP` to inform the assembler of the state of the registers. Using this feature helps, but there are still easily cases where you still need to use the directives, especially when register sizes are changed while branching.

I personally find it good practice to use directives that specify register size at the start of every subroutine, which both documents what sizes the code expects and ensures that they'll be correct regardless of whatever code you insert before the subroutine later.

### Bigger accumulator

The accumulator is always 16-bit. When you resize the accumulator, you are actually specifying if you will use the lower 8 bits or the entire 16 when you perform operations using the accumulator. The upper byte always exists no matter what, and you can use `XAB` to swap (or eXchange) the upper byte with the lower byte. In 8-bit mode this can act as a temporary storage spot, letting you load something else into the accumulator and get the old value back without using the stack.

This means that 16-bit math, 16-bit comparisons, and pointer operations can all be simplified a lot and use a lot fewer instructions. You can simply use a 16-bit `INC` to step a pointer in memory forward.

Some transfer instructions always operate on the whole 16-bit accumulator regardless of its current size. These include any transfer instruction that refers to the accumulator as "C" as well as `TAX`/`TAY` when the accumulator is 8-bit but the index registers are 16-bit. In these cases you'll have to make sure that the upper 8 bits of the accumulator contains the data you want.

### 8-bit variables in 16-bit mode

You don't need the accumulator to be in 8-bit mode to work with 8-bit variables. You can do a 16-bit `LDA` on an 8-bit value, then simply `AND #$00FF` to clear the upper byte to make it zero instead of whatever the next byte was. I generally switch to 8-bit mode if I want to do any stores, but depending on the situation that may not be needed.

### Bigger index registers

X and Y's size bit work differently from the accumulator's. Their 8-bit mode effectively acts as if the upper byte are forced to zero, so if they contain a 16-bit value and are resized to 8-bit and back, they will act as if they have been ANDed with $00FF. I have run into problems before where I made X and Y 8-bit to do something with Y and forgot to save and restore X which was modified by that resize.

16-bit index registers simplify accessing arrays that are bigger than 256 items, because you can continue using regular indexed addressing modes for them instead of needing pointers.

### Index registers as pointers

Now that index registers can be 16-bit, they're big enough to act as a pointer themselves. One technique that becomes viable on the 65c816 is storing the base address of a structure in the X register. From here, you can use `0,x` to access the first byte of the structure, `1,x` for the second byte, etc. and they will be able to take advantage of the smaller zeropage instructions.

Another nice thing you can do with an index register treated as a pointer is actually make the (zeropage,x) addressing mode useful! If X points to a structure's base, you can access any pointers contained inside the structure easily. You could also actually put an array of pointers somewhere other than zeropage and use (zeropage,x) with it that way, or just use it for a double-indirect pointer.

### Arrays of structures

On the 6502, [parallel arrays](https://en.wikipedia.org/wiki/Parallel_array) (or "structure of arrays") are usually the most efficient way to lay out things like enemy state. However on the 65c816, it actually might be a good idea to consider an array of structures instead. Consider a structure that contains both 8-bit and 16-bit fields. On the 6502 the 16-bit values would just be spread across separate arrays, but here you would want to take advantage of being able to access a 16-bit number all at once, so you would probably prefer to have the two bytes sequential in memory. The biggest (maybe only?) downside is that now you need to do a `TXA \ CLC \ ADC #Size \ TAX` sequence to iterate through the list, but it's probably worth it considering the other advantages.

### Transfers between differently sized registers

What happens if you use `TAX`/`TAY`/`TXA`/`TYA` when the accumulator and index registers are different sizes?

- **8-bit A, copied to 16-bit X/Y** - Both bytes of A are copied over despite A being in 8-bit mode. You must make sure that the upper byte of A contains the value you want.
- **8-bit X/Y, copied to 16-bit A** - Low byte of A = low byte of X/Y. High byte of A is zero.
- **16-bit A, copied to 8-bit X/Y** - Low byte of X/Y = low byte of A. High byte of X/Y is zero.
- **16-bit X/Y, copied to 8-bit A** - Low byte of A = low byte of X/Y. High byte of A is unmodified.

### Register size saving

One practice you may find useful is to start a routine with `PHP` and end it with `PLP` if you change the register size inside of it. This way, a caller will get the registers back in the same sizes they were before.

```
php
; Insert code here
plp
rts
```

If you want to save the register values as well, you should push them before you push the register state, so that the correct sizes are restored before they are pulled. Pushing a 16-bit accumulator and then pulling an 8-bit accumulator will probably lead to a crash.

```
pha
phx
phy
php
; Insert code here
plp
ply
plx
pla
rts
```

## Small optimizations

There are a lot of little changes over the original 6502 that make life easier, and allow you to use fewer or smaller instructions. Most of these were introduced with the 65c02.

- **`INA`** - Increment accumulator.
- **`DEA`** - Decrement accumulator.
- **`PHX`** - Push X register.
- **`PHY`** - Push Y register.
- **`PLX`** - Pull X register.
- **`PLY`** - Pull Y register.
- **`TXY`** - Copy X register to Y register.
- **`TYX`** - Copy Y register to X register.
- **`STZ`** - Store zero. Can be indexed with X, and can be zeropage or absolute.
- **`BRA`** - Unconditional branch. You no longer have to take advantage of a flag reliably being in a given state or do a `JMP` in order to perform an unconditional branch.
- **`Indirect addressing`** - Indexing is no longer mandatory on indirect addressing. For example you can write things like `LDA ($00)`.

### Bit tests

The 65c816 provides a few more tools for bit tests. `BIT` becomes much more useful because it can now be indexed, and you can use it with an immediate operand. With an immediate operand it acts identically to `AND` without changing the accumulator.

`TRB` and `TSB` are two of my favorite new instructions. They take a zeropage or absolute address (non-indexed) and do a bit test, setting the zero flag as if an `AND` had been performed between the accumulator and memory. Next, the memory address is changed, with `TRB` clearing all bits that are set in the accumulator, and `TSB` setting all bits that are set in the accumulator. `TSB` can be a drop-in replacement for most places you would use `ORA` followed by `STA` on the same address. I've found it incredibly useful for piecing a value together from multiple parts, as well as just turning flags on and off in variables.

```
lda XPos
sta Temp
lda YPos
asl
asl
asl
asl
tsb Temp
```

### Jump tables

[Jump tables](https://wiki.nesdev.com/w/index.php/Jump_table) on the 6502 require you to either push the address you want to jump to onto the stack, or store it to an address before using an indirect jump. On the 65c816, there are instructions that are specifically for jump tables. `JMP (absolute,x)` and `JSR (absolute,x)` both exist, though you'll still have to do it the old way if you need to preserve X or want to jump to a 24-bit address. One important thing to note is that `RTI` expects a 24-bit address now, so that needs to be taken into account if you're using the RTS trick.

```
asl
tax
jmp (Table,x)

Table:
.addr Routine1
.addr Routine2
.addr Routine3
```

## Banks and 24-bit addresses

Banks work very differently on the 65c816 than they would on a 6502 system like the NES. Different parts of memory are not normally swapped in and out of visibility, because the address space is now 24-bit, which provides a whole 16 megabytes.

### 24-bit program counter

To go with the bigger address space, the program counter is now 24-bit too, with a "bank" byte added to it. `JMP`, `JSR`, and `RTS` still use 16-bit addresses, which keep the program counter within the current bank. There are now `JML`, `JSL` and `RTL` instructions that jump to a full 24-bit address and change the program counter's bank. `RTI` also now takes a 24-bit address

If you have a subroutine that you want to have callable from any bank, it needs to be called with `JSL` rather than `JSR`, and use `RTL` rather than `RTS`. The routine's choice of `RTS`/`RTL` must match with the instruction used to call it, or the return address will be wrong and you'll get a crash.

### The data bank

Similar to the situation with `JMP`, loads, stores and other data accesses with 16-bit addresses (but not zeropage ones) get extended out to 24-bit with a bank byte. In this case it's called the "data bank" register. You can only interact with it through the `PHB` and `PLB` instructions, so setting the data bank has to involve pushing the bank number to the stack. If you want the data bank to equal the program bank, you can use the `PHK` instruction, which pushes the program bank. An example follows:

```
php ; Save register sizes
phb ; Save original data bank
phk ; Push the program counter's bank
plb ; Store it to the data bank
; Insert code that changes the data bank and register sizes to something else
plb ; Restore data bank
plp ; Restore register sizes
rtl
```

You need to keep the data bank in mind when calling code that's in another bank. If you `JSL` somewhere, the data bank won't necessarily be correct for any lookup tables in the target code bank.

In ca65, in addition to &lt; and &gt; to fetch the bottom 8 bits or next 8 bits of a value/label, you can use ^ to get the bank byte. This can be used both for setting up 24-bit pointers and for setting the data bank to be correct for a specific label.

If you want to set the data bank to something other than the program bank, you can push a value with an 8-bit register, but the `PEA` instruction is probably your best option. It takes a 16-bit immediate value and pushes it to the stack. It's kind of annoying because you have an instruction that pushes 16-bit values but none that push 8-bit values, so the best you can do is either `PLB` twice or (better) push the next two values you intend on pulling. Following is a ca65 macro from [lorom-template](https://github.com/pinobatch/lorom-template/blob/master/src/snes.inc) which makes this easier to work with:

```
;;
; Pushes two constant bytes in the order second, first
; to be pulled in the order first, second.
.macro ph2b first, second
.local first_, second_, arg
first_ = first
second_ = second
arg = (first_ & $FF) | ((second_ & $FF) << 8)
  pea arg
.endmacro
```

### Addressing modes

`LDA`, `STA`, `ADC`, `SBC`, `ORA`, `AND`, `EOR`, and `CMP` get new addressing modes that provide access to 24-bit addresses, ignoring the data bank. What follows are ca65 syntax:

- **`f:absolute`** - 24-bit address
- **`f:absolute, x`** - 24-bit address with indexing
- **`[zeropage]`** - 24-bit version of (zeropage)
- **`[zeropage],y`** - 24-bit version of (zeropage) with indexing. \[zeropage,x] does not exist.

If you need to access data from a bank different from the one you have set as the data bank, you'll have to plan out how you want to use the X and Y registers, given that only X can be used with far absolute addressing.

## Variables on the stack

The 65c816 makes it more feasible to put function arguments or local variables on the stack with new addressing modes on `LDA`, `STA`, `ADC`, `SBC`, `ORA`, `AND`, `EOR`, and `CMP` as well as a new 16-bit stack pointer. The new addressing modes are `stack,s` and `(stack,s),y` which index an 8-bit address with the stack pointer. Remember that the stack pointer points to the next available slot, so 1,s will go to the most recently pushed byte, 2,s will go to the next recently pushed byte and so on.

If you want to work with values on the stack, you should be aware of the `TSC` and `TCS` instructions. With these you can easily copy the stack pointer into the accumulator, subtract for however many local variables you want to make room for, and copy back to the stack pointer.

Probably the biggest downside to using the stack like this is that only the above instructions work with it. `LDX`, `INC` and such don't have the addressing modes available.

## Movable "zeropage"/direct page

The 65c816 allows you to move zeropage to anywhere in the first 64KB of the address space. As a result, it's usually renamed to the "direct page". You're provided the `TDC` and `TCD` instructions to copy the accumulator to/from the base of the direct page. Direct page does not even need to start on a page boundary, but if it doesn't then there is a cycle penalty on direct page instructions.

You could move the direct page to the start of a structure, but I personally wouldn't do this. I would actually generally leave the direct page at zero.

## Decimal mode

This isn't new to the 65c816, but will be new to NES developers. The SNES has a functional decimal mode! You should consider using it for values that are mostly for displaying, like money amounts or the score. One thing to keep in mind is that decimal mode only applies to `ADC` and `SBC`, so increments and decrements must be done using those.

## SNES-specific math

The SNES has [multiplication and division](https://problemkaputt.de/fullsnes.htm#snesmathsmultiplydivide) I/O registers. You get unsigned 8-bit × 8-bit = 16-bit, unsigned 16-bit ÷ 8-bit = 16-bit, and a signed 16-bit × 8-bit = 24-bit multiplier that reuses hardware from Mode 7. The unsigned math functions have a delay before the results are valid, in which you must either find other work to do or just waste time, and the signed multiplier provides results immediately but is not usable while Mode 7 is in use.
