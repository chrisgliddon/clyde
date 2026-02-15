---
title: "Bithacks"
reference_url: https://sneslab.net/wiki/Bithacks
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:12:05-08:00
cleaned_at: 2026-02-14T17:51:17-08:00
---

**Bithacks** are optimization tricks that utilize information in bits and [bit manipulation](https://en.wikipedia.org/wiki/Bit_manipulation) to accomplish their tasks. Usually they work in a slightly non-obvious way, (the most famous being the [fast inverse sqrt](https://en.wikipedia.org/wiki/Fast_inverse_square_root)), and bit manipulation in general is harder on the 65c816. To that end, here is a collection of some useful tricks.  
**Note: cycle counts are intended to be a worst case measure.**  
See also: Useful Code Snippets

# Math Bithacks

## Signed Division By 2

*7 bytes / 8 cycles*  
inputs: A  
outputs: A

```
	CMP #$80
	ROR
	BPL +
	ADC #$00
	+
```

note: Rounds toward zero.

## Arithmetic Shift Right

*3 bytes / 4 cycles*  
inputs: A  
outputs: A

```
	CMP #$80
	ROR
```

note: This is similar to division by 2, but rounds toward negative infinity.

## Arithmetic Shift Right, multiple steps

*6+n bytes / 6+2n cycles*  
inputs: A  
outputs: A

```
; signed division by two, n times
macro ASR_multi(n)
	LSR #<n>
	BIT.b #$80>><n>
	BEQ ?positive
	ORA.b #$FF00>><n>    ; sign extension
?positive:
endmacro

; -1 cycle and +n bytes, but must have N flag set before use
macro ASR_multi(n)
	BMI ?negative
	LSR #<n>
	BRA ?end
?negative:
	LSR #<n>
	ORA.b #$FF00>><n>    ; sign extension
?end:
endmacro
```

## Absolute Value

*5 bytes / 6 cycles*  
inputs: A, (N Flag)  
outputs: A

```
macro abs()
	BPL ?plus
	EOR #$FF
	INC
?plus:		; only 3 cycles if branch taken
endmacro
```

## Absolute Value (SEC)

*4 bytes / 4 cycles*  
inputs: A, (Carry Set)  
outputs: A

```
; compared to the branching version this is 1 byte smaller
; it's either 2 cycles slower/faster depending on branch taken
	EOR #$7F
;	SEC		; the instant you add this in it becomes worse than the branching version
	SBC #$7F
```

## Magnitude/Extents Check

*~7 bytes / 12 cycles*  
inputs: A  
outputs: (none)

```
; asks "Is [A] on the zero-side of value [X] or the far side?"
; good for magnitude checks, smaller *AND* faster than alternatives
; NOTE: in the event that it is exactly [X] it will have that value at branch
; doesn't need to be an indexed CMP but is most useful this way
; this can be used to combine the BPL and BMI checks for both signs into one
	SEC : SBC Extents,x
	EOR Extents,x
	BMI .zero_side
.far_side:
	; do things
.zero_side:
	; do things

Extents:
	db -$23, $23
```

## Sign Extend

*8 bytes / 8 cycles*  
inputs: 8bit value in A (16-bit mode)  
outputs: A

```
	BIT #$0080 : BEQ +
;	CMP #$0080 : BCC +	; alternative to above
	ORA #$FF00			; on branch taken: additional -2 cycles
	+
```

## Sign Extend (Branchless)

*7 bytes / 8 cycles*  
inputs: 8bit value in A (16-bit mode)  
outputs: A

```
	; Value in A must have high byte clear
	EOR #$0080
	SEC : SBC #$0080
```

## Sign Extend (Unaligned)

*11 bytes / 15 cycles*  
inputs: 8bit value in $10 (pulled as 16-bit)  
outputs: A

```
;	REP #$20
	LDA $10-1 ; load $10 into A high, and garbage in low
	AND #$FF00 ; discard garbage
	BPL +
	ORA #$00FF
	+
	XBA
```

## Clamp Signed (To Constants)

*16 bytes/15 cycles*  
inputs: A  
outputs: A

```
; clamp signed value in A to [min,max] if min/max are signed constants
macro clamp_const(min,max)
	EOR #$80
	CMP #$80^<min> : BCS ?+
	LDA #$80^<min>
?+	CMP #$80^<max> : BCC ?+
	LDA #$80^<max>
?+	EOR #$80
endmacro
```

# Misc. Tricks

As this list grows tricks here will be consolidated into their own sections. Clever optimization tricks that aren't necessarily what someone might personally call a "bithack" are okay here as well!

## XCN

*12 bytes / 16 cycles*  
inputs: A  
outputs: A

```
; eXchaNge Nibble without a LUT
	ASL : ADC #$00
	ASL : ADC #$00
	ASL : ADC #$00
	ASL : ADC #$00
```

## Clear Low Byte of Accumulator

*1 byte / 2 cycles*  
inputs: (none)  
outputs: A

```
; "Trashes" A but clears low byte
	TDC
```

## Direction/Facing As Index

*4 bytes / 6 cycles*  
inputs: A  
outputs: A

```
; Ever wonder why facing flags are 0=right and 1=left? This is why. It's incredibly cheap.
; The input here is specifically a signed speed, or similar value.
	ASL
	ROL
	AND #$01
```

## Check N Conditions True

*n+7 bytes / 2n+7 cycles*  
inputs: A  
outputs: A

```
; You can test for multiple conditions being true (7 conditions true, at least 5 conditions, etc.) by simply using a counter and rounding to the next power of 2 and test if that bit is set.
; You can also test for "Less than N True", "More than N", etc. with variations.
; This is almost more a coding technique, but it's super helpful, so worth pointing out.
; It can allow you to re-arrange branches of code as independent blocks among other useful things.
; You can also use any RAM instead of A at a small cost.

; Example Test For 5 True Conditions:
!Next_Highest_Power_of_2 = $08
!N_True_Target = $05
	LDA #!Next_Highest_Power_of_2!-!N_True_Target-1		; here we set up our rounding, the -1 isn't strictly necessary *most* of the time
	%TestSomeCondition()
	BCC +	; here we're going to say our test just returns carry set on true (but it could directly INC inside the code as well)
	INC
+
;	... repeat the above 5 times for different tests

N_True_Test:
	INC	; replace our -1 to bring us up to a full power of 2 if we had enough True
	AND #!Next_Highest_Power_of_2
	BEQ .false
.true:
	; N Tests were True
.false:
	; Not exactly N tests were true
```

## Skip Dead Code

*1-2 bytes / 2-3 cycles*  
inputs: (none)  
outputs: (none)

```
; If you need to skip just one byte of dead code (due to a hijack or whatever reason) you can use:
	NOP		; 1 byte, 2 cycles

; But if you need to skip two bytes the most efficient is:
; NOTE: many times WDM is used as a breakpoint for debugging so only do this as a final pass to speed up your code!
	WDM		; 2 bytes, 2 cycles

; Finally, if you need to skip a large amount of dead code you can use BRA/JMP instead
; JMP is as fast as BRA on the SNES CPU, but will be slightly slower on SA-1, and 1 cycle slower on SPC. So BRA is recommended
; (The extra byte used for JMP in this case doesn't matter)
	BRA +		; 2 bytes, 3 cycles
	; dead code
+
```

## Check 3 Conditions

*2 bytes / 2 cycles*  
inputs: A  
outputs: (none)

```
; just the opcode as normal here (not counting the conditions), using any operand that's not immediate (#)
; it's worth noting that you can do up to 3 tests with a single opcode though!
; Just As A Reminder: the V & N flag are set by the *operand* to BIT not the result of the AND!
	BIT $00
	BMI .bit7_set
	BVS .bit6_set
	BNE .bit5_set	; assuming #$20 is in $00
.bit7_set:
.bit6_set:
.bit5_set:
```

## Combine Carry Flag

*4 bytes / 8 cycles*  
inputs: (Flag, On Stack)  
outputs: (Carry Flag)

```
; flag on stack via PHP (8-Bit A if this), etc.
	; code that alters Carry Flag
	PLA : BCS +
	LSR
+
```

## Transfer Carry Flag To Overflow Flag

*2 bytes / 2 cycles*  
inputs: (Carry Flag)  
outputs: (Overflow Flag)

```
	ADC #$7F	; #$7FFF for 16-bit
```

## Convert hex to decimal (16 bits) - with tables

*1069 bytes / 79 cycles*  
inputs: A  
outputs: Y (lower four digits, one per nybble), !top\_digit (ten-thousands digit)

```
pha
and #$FF00
xba
asl
tax
lda.l LowToDecimal+1,x
lsr #2
and #$0007
sta !top_digit
lda.l HighToDecimal,x
sta !tmp
pla
and #$00FF
asl
tax
lda.l LowToDecimal,x
and #$03FF
sed
adc !tmp
bcc +
inc !top_digit
+
cld

...

LowToDecimal:
!i = 0
while !i < 256
dw floor(!i*256/10000)*$400+$!i ; not a typo
!i #= !i+1
endwhile
HighToDecimal:
!i = 0
while !i < 256
dw $!{i}00
!i #= !i+1
endwhile
```

## Convert hex to decimal (16 bits) - without tables

*161 bytes / 217 cycles*  
inputs: A  
outputs: Y (lower four digits, one per nybble), !top\_digit (ten-thousands digit)

```
rep #$30
sed
tax
stz !top_digit

and #$0007 ; bottom three bits are easy
tay

!bit = 16
while !bit <= 32768
txa
bit.w #!bit
beq +
tya
adc.w #$!bit ; not a typo
tay
if !bit == 8192
bcc +
inc !top_digit
endif
if !bit >= 16384
lda !top_digit
adc.w #!bit/10000
sta !top_digit
if !bit < 32768 ; carry isn't used after 32768
clc
endif
endif
+
!bit #= !bit*2
endwhile
```

## DP As Extra Index Register

*12 bytes / 16 cycles*  
inputs: !offset, !pointer, !value  
outputs: (none)

```
; this one is more instructive than exact, in terms of cycles and bytes.
; in general it's around +9 cycles to restore/set DP
; inside a tight loop using this trick can save 2 cycles per usage or more
	LDA #!pointer
	TCD
	LDX #!offset
	LDA #!value
	STA $00,x		; write value to pointer + offset
```

## RAM As Extra Index Register

*13 bytes / 20 cycles*  
inputs: !offset, !pointer, !value  
outputs: (none)

```
; this one is more instructive than exact, in terms of cycles and bytes.
; in general it's around +7 cycles to setup long pointer bank in RAM (and it must be in DP)
; slower code that aims to squeeze extra speed out of having the extra index available
	LDA #!pointer
	STA !ptr+1
	LDX #!offset
	LDA #!value
	STA [!ptr],x		; write value to pointer + offset
```
