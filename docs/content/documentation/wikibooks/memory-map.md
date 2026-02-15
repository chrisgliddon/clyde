---
title: "Super NES Programming/SNES memory map"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/SNES_memory_map
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:18:01-08:00
---

# Memory Mapping

There are two main types of SNES cartridges, the SNES community refers to them as LoROM and HiROM cartridges. Both have different memory mapping. Before explaining LoROM and HiROM though, we should define some keywords here:

**$ or 0x prefix**: the following number is hexadecimal. Addresses are often shown as hexadecimal values.

**Bank**: 64 Kilobytes (65536 or $10000 bytes), basically the [most significant byte](https://en.wikipedia.org/wiki/Most_significant_bit) of the 3 byte address the CPU understands. The bank of the address $AABBCC is $AA (170). With three bytes of address space the SNES can address up to 16 Megabytes (2^24 or 1&lt;&lt;24 or 16777216 Bytes == 16384 Kilobytes == 16 Megabytes). Beware that just because the SNES can address 16 Megabytes does not mean it also HAS 16 MB of RAM (here so-called WRAM) - it will be explained in detail later. Just keep in mind that therefore the SNES has $100 or 256 Banks (start at $00, end at $FF).

**Page**: 256 bytes ($0100 bytes). Pages are used whenever the machine has to perform mapping tasks (for example, ensuring that address $AABBCC and address $DDBBCC point to the exactly same data, if that's how the machine is supposed to work). Pages are also used for normal PCs (x86/x86-64 architectures) and are hence not exclusive for the SNES. A page is the **smallest mappable unit** of a machine. You will notice that in the tables below there is no entry in which a certain memory range does **not** end with $FF - this is because $FF is the last address of a page, and after this byte a new page begins. The SNES relies heavily on mapping - for example, without mapping it wouldn't be possible to give all banks of $00 – $3F two pages of WRAM directly at the beginning of the bank. One bank holds 256 ($100) pages, so the SNES has $100 (banks) * $100 (pages) == $10000 (65536) pages available.

Both LoROM and HiROM are capable of storing up to 4 Megabytes (32 Megabits) of ROM data. ExLoROM, ExHiROM and some expansion chips like SA-1 and SDD-1 are said to be able to store up to 8 Megabytes (64 Megabits).

## How do I recognize the ROM type?

In byte $15 in the SNES header (see below for more details), the ROM makeup byte is stored.

Value Bitmask Definition Example ROM Example ROM size $20 %0010 0000 LoROM *Final Fantasy 4* 1048576 bytes / 1 MB $21 %0010 0001 HiROM *Final Fantasy 5* 2097152 bytes / 2 MB $23 %0010 0011 SA-1 ROM *Super Mario RPG* 4194304 bytes / 4 MB $30 %0011 0000 LoROM + FastROM *Ultima VII* 1572864 bytes / 1.5 MB $31 %0011 0001 HiROM + FastROM *Final Fantasy 6* 3145728 bytes / 3 MB $32 %0011 0010 SDD-1 ROM *Star Ocean* 6291456 bytes / 6 MB $35 %0011 0101 ExHiROM *Tales Of Phantasia* 6291456 bytes / 6 MB

The bitmask to use is 001A0BCD, the basic value is $20:

\- A == 0 means SlowROM (+ $0), A == 1 means FastROM (+ $10).  
\- B == 1 means ExHiROM (+ $4)  
\- D == 0 means LoROM (+ $0), D == 1 means HiROM (+ $1), is used with B and C in case of extended ROMs.

Keep in mind that some people sometimes use "Mode 20" to refer to the LoROM mapping model, and "Mode 21" to refer to HiROM, although it's technically wrong. As the table shows, there are two LoROM and two HiROM mappings which have a different markup byte than the name suggests.

ExLoROM is an unofficial map, so it does not have its own type value. To detect it one would typically just check if the game is a regular LoROM then check the ROM file size.

Note that expansion chips like the SuperFX have their own memory map, which is not covered here. SA-1 and SDD-1 in particular are MMC chips, which means they can do bank switching to change which parts of the ROM are accessed for a given bank.

## LoROM

This is the LoROM memory map:

Bank Offset Definition ROM address Shadowing $00–$3F $0000-$1FFF LowRAM, shadowed from bank $7E (No ROM mapping) $7E (First two pages of WRAM) $2000–$20FF Unused (No ROM mapping) $80-$BF $2100–$21FF PPU1, APU, hardware registers (No ROM mapping) $80-$BF $2200–$2FFF Unused (No ROM mapping) $80-$BF $3000–$3FFF DSP, SuperFX, hardware registers (are there any documents regarding this page? I couldn't find any source) (No ROM mapping) $80-$BF $4000–$40FF Old Style Joypad Registers (No ROM mapping) $80-$BF $4100–$41FF Unused (No ROM mapping) $80-$BF $4200–$44FF DMA, PPU2, hardware registers (No ROM mapping) $80-$BF $4500–$5FFF Unused (No ROM mapping) $80-$BF $6000–$7FFF RESERVED (enhancement chips memory) (No ROM mapping) $80-$BF $8000-$FFFF LoROM section (program memory)

```
$00: $000000 - $007FFF
$01: $008000 - $00FFFF
$02: $010000 - $017FFF
...
$3D: $1E8000 - $1EFFFF
$3E: $1F0000 - $1F7FFF
$3F: $1F8000 - $1FFFFF
```

$80-$BF $40–$6F $0000-$7FFF May be mapped as the higher bank ($8000 - $FFFF) if chip is not MAD-1. Otherwise this area is unused. Unmapped or

```
$40: $200000 - $207FFF
$41: $208000 - $20FFFF
$42: $210000 - $217FFF
...
$6D: $368000 - $36FFFF
$6E: $370000 - $377FFF
$6F: $378000 - $37FFFF
```

$C0-$EF $8000-$FFFF LoROM section (program memory)

```
$40: $200000 - $207FFF
$41: $208000 - $20FFFF
$42: $210000 - $217FFF
...
$6D: $368000 - $36FFFF
$6E: $370000 - $377FFF
$6F: $378000 - $37FFFF
```

$C0-$EF $70–$7D $0000-$7FFF Cartridge SRAM - 448 Kilobytes maximum (No ROM mapping) $F0-$FD $8000-$FFFF LoROM section (program memory)

```
$70: $380000 - $387FFF
$71: $388000 - $38FFFF
$72: $390000 - $397FFF
...
$7B: $3D8000 - $3DFFFF
$7C: $3E0000 - $3E7FFF
$7D: $3E8000 - $3EFFFF
```

$F0-$FD $7E $0000-$1FFF LowRAM (WRAM) (No ROM mapping) $00–$3F (First two pages of WRAM) $2000–$7FFF HighRAM (WRAM) (No ROM mapping) (No mapping) $8000-$FFFF Extended RAM (WRAM) (No ROM mapping) (No mapping) $7F $0000-$FFFF Extended RAM (WRAM) (No ROM mapping) (No mapping) $80-$BF $0000-$FFFF Mirror of $00–$3F (See banks $00–$3F) $00–$3F $C0-$EF $0000-$FFFF Mirror of $40–$6F (See banks $40–$6F) $40–$6F $F0-$FD $0000-$FFFF Mirror of $70–$7D (See banks $70–$7D) $70–$7D $FE-$FF $0000-$7FFF Cartridge SRAM - 64 Kilobytes (512 KB total) (No ROM mapping) (No mapping) $8000-$FFFF LoROM section (program memory)

```
$7E: $3F0000 - $3F7FFF
$7F: $3F8000 - $3FFFFF
```

(No mapping)  
(Keep in mind these banks)  
(were overridden by WRAM in the &lt;$7F range)

In LoROM mode, the ROM is always mapped in the upper half of each bank, thus 32 Kilobytes per chunk. The banks $00 – $7D (address: $8000 - $FFFF) hold continuous data, as well as banks $80 - $FF. SRAM on the cartridge is mapped continuously and repeatedly - 8 Kilobyte of SRAM are mapped at $0000 - $1FFF, $2000 – $3FFF, $4000 – $5FFF and so on. Because the WRAM of the SNES is mapped at bank $7E - $7F, these banks do not map to the last SRAM/ROM chunks. This memory has to be accessed via the banks $80 - $FF. **There is no other way of accessing this memory both in LoROM and HiROM mode.**

LoROM was established to make sure that the system banks ($00 – $3F) higher pages (&gt;7) are actually used. This is done by loading the entire ROM only in higher pages and in 32 Kilobyte chunks. 32 KB * $80 banks == 4 Megabyte.

## HiROM

This is the HiROM memory map:

Bank Offset Definition ROM address Shadowing $00–$1F $0000-$1FFF LowRAM, shadowed from bank $7E (No ROM mapping) $7E (First two pages of WRAM) $2000–$20FF Unused (No ROM mapping) $80–$9F $2100–$21FF PPU1, APU, hardware registers (No ROM mapping) $80–$9F $2200–$2FFF Unused (No ROM mapping) $80–$9F $3000–$3FFF DSP, SuperFX, hardware registers (are there any documents regarding this page? I couldn't find any source) (No ROM mapping) $80–$9F $4000–$40FF Old Style Joypad Registers (No ROM mapping) $80–$9F $4100–$41FF Unused (No ROM mapping) $80–$9F $4200–$44FF DMA, PPU2, hardware registers (No ROM mapping) $80–$9F $4500–$5FFF Unused (No ROM mapping) $80–$9F $6000–$7FFF RESERVED (No ROM mapping) $80–$9F $8000-$FFFF HiROM section (program memory)

```
$00: $008000 - $00FFFF
$01: $018000 - $01FFFF
$02: $028000 - $02FFFF
...
$1D: $1D8000 - $1DFFFF
$1E: $1E8000 - $1EFFFF
$1F: $1F8000 - $1FFFFF
```

$80–$9F $20–$3F $0000-$1FFF LowRAM, shadowed from bank $7E (No ROM mapping) $7E (First two pages of WRAM) $2000–$20FF Unused (No ROM mapping) $A0-$BF $2100–$21FF PPU1, APU, hardware registers (No ROM mapping) $A0-$BF $2200–$2FFF Unused (No ROM mapping) $A0-$BF $3000–$3FFF DSP, SuperFX, hardware registers (are there any documents regarding this page? I couldn't find any source) (No ROM mapping) $A0-$BF $4000–$40FF Old Style Joypad Registers (No ROM mapping) $A0-$BF $4100–$41FF Unused (No ROM mapping) $A0-$BF $4200–$44FF DMA, PPU2, hardware registers (No ROM mapping) $A0-$BF $4500–$5FFF Unused (No ROM mapping) $A0-$BF $6000–$7FFF Cartridge SRAM - 8 Kilobytes (256 KB total) (No ROM mapping) $A0-$BF $8000-$FFFF HiROM section (program memory)

```
$20: $208000 - $20FFFF
$21: $218000 - $21FFFF
$22: $228000 - $22FFFF
...
$3D: $3D8000 - $3DFFFF
$3E: $3E8000 - $3EFFFF
$3F: $3F8000 - $3FFFFF
```

$A0-$BF $40–$7D $0000-$FFFF HiROM section (program memory)

```
$00: $000000 - $00FFFF
$01: $010000 - $01FFFF
$02: $020000 - $02FFFF
...
$3B: $3B0000 - $3BFFFF
$3C: $3C0000 - $3CFFFF
$3D: $3D0000 - $3DFFFF
```

$C0-$FD $7E $0000-$1FFF LowRAM (WRAM) (No ROM mapping) $00–$3F (First two pages of WRAM) $2000–$7FFF HighRAM (WRAM) (No ROM mapping) (No mapping) $8000-$FFFF Expanded RAM (WRAM) (No ROM mapping) (No mapping) $7F $0000-$FFFF Expanded RAM (WRAM) (No ROM mapping) (No mapping) $80–$9F $0000-$FFFF Mirror of $00–$1F (See banks $00–$1F) $00–$1F $A0-$BF $0000-$FFFF Mirror of $20–$3F (See banks $20–$3F) $20–$3F $C0-$FD $0000-$FFFF Mirror of $40–$7D (See banks $40–$7D) $40–$7D $FE-$FF $0000-$FFFF HiROM section (program memory)

```
$3E: $3E0000 - $3EFFFF
$3F: $3F0000 - $3FFFFF
```

(No mapping)  
(Keep in mind these banks)  
(were overridden by WRAM in the &lt;$7F range)

HiROM is a bit more complex to understand. Unlike LoROM, it does not use $80 (128) banks to map the ROM into the address space of the SNES, but only $40 (64) banks. Also unlike LoROM, these banks are used to their full extend, that is, 64 KB per chunk. 64 KB * $40 banks == 4 Megabytes. The banks $40 – $7D (address: $0000 - $FFFF) hold continuous data, as well as banks $C0 - $FF. Beware that HiROM also creates mappings for banks $00 – $3F and $80 - $BF. As those are system banks, their lower pages (&lt;8) are already mapped - but the higher pages are free, so that many portions of the ROM are mirrored four times into the address space of the SNES. SRAM on the cartridge is mapped into the banks $20 – $3F, in 8 Kilobyte chunks. As there are only 32 banks reserved for this, the possible SRAM amount accessible in HiROM is theoretically lower than in LoROM (256 KB vs. 512 KB). Because the WRAM of the SNES is mapped at bank $7E - $7F, these banks do not map to the last ROM chunks. This memory has to be accessed via the $80 - $FF banks

Banks $80 - $FF can also be used for faster memory access. Many portions of memory &lt;$80 are accessed at 2.68 MHz (200 ns). Accessing memory &gt;$80 is done at 3.58 MHz (120 ns) if the value at address $420D (hardware register) is set to 1.

LoROM basically means that the address line A15 is ignored by the cartridge, so the cartridge doesn't distinguish between $0000-$7FFF and $8000-$FFFF in any bank. Smaller ROMs use this model to prevent wasted space in banks $00–$3F.

## ExLoROM, ExHiROM

LoROM and HiROM were designed to store 4 MB in a ROM and map it into the 24 bit address space of the SNES (which can, in case you have forgotten it, address up to 16 Megabytes). Usually that is enough for many games, especially if one considers the fact that in the beginning the SNES was not supposed to render a lot of later games using the control deck alone. This is also the reason why the SNES reserved some address space for the usage of SuperFX chips that would enable games to spare the CPU - it was not intended to have the SNES play games like *Tales of Phantasia*, or *Final Fantasy 6*, or *Star Fox* without the aid of enhancement chips.

Apart from the hardware problems that the SNES was designed with, the programmers also have/had huge space limitations. *Final Fantasy 6'*s English script - a early draft, to be precise - was cut down to 75% because it would have otherwise exhausted the 24 Megabit (3 Megabyte) cartridge that was used for the Japanese version. Expanding the ROM from 24 MBits to 32 MBits does not cause really big issues, but everything bigger than 4 Megabytes goes beyond the boundaries of LoROM/HiROM.

A huge advantage of the SNES is that it does not define how certain address blocks are mapped into the cartridge's ROM. The cartridge does take care that the addresses it needs to use are mapped properly to its ROM. For people who would like to program an emulator this behaviour imposes certain problems, as they have to program and emulate the SNES hardware AND the cartridge as well. Keep in mind that the cartridge, as the SNES, contains its own processors and microchips, which may perform differently from chip to chip. Take for instance a common problem: the usage of MAD-1 address decoding chips within the cartridge, which maps the content of the $40–7D:8000-FFFF ROM areas to the lower halves of the banks as well (so that there is no difference between $400005 and $408005 - see the LoROM table for the exact addresses). The real SNES does not have to care for this, emulators do.

Thus, using a format which allows the usage of up to 8 Megabytes of ROM space without using an expansion MMC chip imposed no definite hardware problems, as the address decoding chips on the cartridge would need to take care of that. Two new formats were introduced: ExLoROM (the prefix "Ex" stands for "extended," in case you wondered), and ExHiROM. Only two games which actually never officially got released in NA use ExHiROM, *Tales of Phantasia* and *Daikaijuu Monogatari II*. ExLoROM on the other hand was not used in any commercial games and is considered an unofficial map, so emulator support for it has been known to be somewhat lacking or inconsistent at times. But ROM hacks which contain new game content usually expand the original ROM size, and might use one of these two formats. In fact, both the re-translations of *Chrono Trigger* by "DoctorL" and "KajarLab" expand the game from 4 to 6 Megabytes.

There are many either misleading or not understandable explanations and examples of the memory layout of ExLoROM and ExHiROM, for two valid reasons:

- hackers often do not encounter these formats.
- incapability to see why someone would need so much memory at their hands. *

Let's first cover the memory map of ExLoROM - we will not go into detail for the mapping of the system banks lower halves, as these were already covered before and do not change for the extended ROM formats:

Bank Offset ROM address Shadowing $00–$3F $8000-$FFFF

```
$00: $400000 - $407FFF
$01: $408000 - $40FFFF
$02: $410000 - $417FFF
...
$3D: $5E8000 - $5EFFFF
$3E: $5F0000 - $5F7FFF
$3F: $5F8000 - $5FFFFF
```

$80-$BF $40–$6F $8000-$FFFF

```
$40: $600000 - $607FFF
$41: $608000 - $60FFFF
$42: $610000 - $617FFF
...
$6D: $768000 - $76FFFF
$6E: $770000 - $777FFF
$6F: $778000 - $77FFFF
```

(No mapping) $70–$7D $8000-$FFFF

```
$70: $780000 - $787FFF
$71: $788000 - $78FFFF
$72: $790000 - $797FFF
...
$7B: $7D8000 - $7DFFFF
$7C: $7E0000 - $7E7FFF
$7D: $7E8000 - $7EFFFF
```

$F0-$FD $80-$BF $8000-$FFFF (See banks $00–$3F) $00–$3F $C0-$EF $8000-$FFFF

```
$C0: $200000 - $207FFF
$C1: $208000 - $20FFFF
$C2: $210000 - $217FFF
...
$ED: $368000 - $36FFFF
$EE: $370000 - $377FFF
$EF: $378000 - $37FFFF
```

(No mapping) $F0-$FD $8000-$FFFF

```
$F0: $380000 - $387FFF
$F1: $388000 - $38FFFF
$F2: $390000 - $397FFF
...
$FB: $3D8000 - $3DFFFF
$FC: $3E0000 - $3E7FFF
$FD: $3E8000 - $3EFFFF
```

$70–$7D $FE-$FF $8000-$FFFF

```
$FE: $3F0000 - $3F7FFF
$FF: $3F8000 - $3FFFFF
```

(No mapping)

Note: This information are wrong, as I had to realize. A ROM which starts at offset $200000 makes no sense at all. Also, since it is still a LoROM format, the first ROM bank HAS TO be loaded to $00:8000-FFFF. Yet, the template will be corrected soon, and deleting it all serves no purpose.

(Explanation and ExHiROM table coming soon).

(\*The second reason is in fact a protection mechanism. In case that a hacker encounters someone who wants to enlarge a ROM beyond the 32 Megabit limit, the hacker automatically assumes that this person is a newbie who has not much idea what he is talking about, and in an awful lot of occasions he is right. This, however, does not justify the mere lack of documentation regarding these topics.)

# The SNES header

At the end of bank 0 (the very first bank of the cartridge), 64 ($40) bytes of cartridge information are stored. This information is crucial to the execution of the ROM saved on the cartridge, as it includes the internal name of the ROM, the interrupt vectors (addresses to machine code within the ROM in 16 bit format), version, etc. This portion of the ROM is also known as the SNES header (not to confuse with the SMC header, which we will touch very soon).

The end of the very first bank of the ROM depends on with memory map it uses. In case of LoROM, the end of the first page is at $7FFF, for HiROM the first page ends at $FFFF. So you basically have to check on both positions of the ROM if the information fit the normal header format, that is, if they are plausible enough.

Some cartridges are delivered with a so-called SMC header. A SMC header is usually written by a copier device at the very beginning of the ROM, and occupies $200 (512) bytes of additional space. Often patches depend on your ROM being "headered" or being "headerless", as this changes the offsets within the ROM. A patch which is applied to the wrong type of ROM can easily kill the program code of the cartridge.

Creating a SMC header is "relatively" simple, removing it more so. Usually the SMC header contains the size of the ROM divided by 8 KB units &$FF (bitwise AND with 255) in byte 0, the size &gt;&gt; 8 (bitwise shift right by a whole byte) in byte 1, and the type of cartridge in byte 2. The other bytes (509) left are set to zero. For creating a header, you simply have to add a block of 512 bytes at the beginning of the ROM which contains these information. For removing a header, you simply have to save the ROM on your HDD/SSD while "forgetting" the first 512 bytes.

The reason why we poke into SMC header when we should actually deal with SNES header is simple - actually, there's two of them:

1\. The existence of a SMC header has to be taken into account when mapping the ROM into memory. The bank in a ROM with header will not begin at offset $0, but at $200 (512, the size of the header), and so the end of the bank shifts accordingly.

2\. If there is no SMC header in the ROM, or you simply do not trust this information when parsing the ROM, your only way of determining the type of cartridge you are trying to load in is by checking for well-formed headers at the already-mentioned positions. But IF you do trust this information (which you shouldn't), it is a way to determine whether you are dealing with LoROM or HiROM.

Before you try to load in this information, you have to determine the size of the SMC, may it be there or not. The length of the ROM modulo 1024 (ROM size % $400) gives you the size of the SMC header. If it's 0, there is no header. If it's not 512, the header is malformed.

The following offsets in the ROM are that of a headerless ROM. You have to add the size of the SMC header to all addresses in the ROM to properly read it. x is the last page of the current ROM bank ($7 if the cartridge uses the LoROM mapping, $F if it uses HiROM).

Offset name description $xFC0 Game title 21 bytes, usually uppercase ASCII. $xFD5 Mapping mode 001ABBBB; A==1 means FastROM ($10). If BBBB is the mapping mode. $xFD6 ROM type Denotes that the cartridge contains expansion chips, SRAM, batteries, etc. $xFD7 ROM size The size of the ROM, stored as ⌈ log 2 ⁡ ( s i z e   i n   k i l o b y t e s ) ⌉ {\\displaystyle \\lceil \\log \_{2}(size\\ in\\ kilobytes)\\rceil } . If you do $400&lt;&lt;(ROM size), you get the overall size in bytes. $xFD8 SRAM size The size of SRAM, or cartridge RAM. Stored as ⌈ log 2 ⁡ ( s i z e   i n   k i l o b y t e s ) ⌉ {\\displaystyle \\lceil \\log \_{2}(size\\ in\\ kilobytes)\\rceil } . Usually used to save game progress. To get the size again use $400&lt;&lt;(RAM size). $xFD9 Developer ID $33 if using header revision 3 $xFDB Version # $xFDC Checksum complement $xFDE Checksum

### Interrupt vectors

After this information, the interrupt vector tables begin. An interrupt is a signal that is cast by the hardware directly to the CPU that needs to be dealt with if the interrupt was not masked. An interrupt vector specifies the address where the code is to deal with the given type of interrupt. These vectors are all 16 bits in size and are supposed to lie within the first bank of the ROM. This is because the DBR (Data Bank Register) and PBR (Program Bank Register) are set to 0 every time the emulation mode is changed or an interrupt is executed.

Vectors are all 2 bytes in size and are stored in little-endian format (in case the reader did not know it - the CPU is a little endian one, which means that the MSBs are stored in higher positions. Big endian means that the MSBs are stored in lower positions). Program execution begins in emulation mode at the reset vector ($xFFC-D).

#### Native Mode Vectors

Interrupt name Offset in ROM Description COP $xFE4-5 Software interrupt. Triggered by the COP instruction. Similar to BRK. BRK $xFE6-7 Software interrupt. Triggered by the BRK instruction. Similar to COP. ABORT $xFE8-9 Not used in the SNES. NMI $xFEA-B Non-maskable interrupt. Called when vertical refresh (vblank) begins. IRQ $xFEE-F Interrupt request. Can be set to be called at a certain spot in the horizontal refresh cycle.

#### Emulation Mode Vectors

Interrupt name Offset in ROM Description COP $xFF4-5 Software interrupt. Triggered by the COP instruction. ABORT $xFF8-9 Not used in the SNES. NMI $xFFA-B Non-maskable interrupt. Called when vertical refresh (vblank) begins. RES $xFFC-D Reset vector, execution begins via this vector. IRQ/BRK $xFFE-F Interrupt request. Can be set to be called at a certain spot in the horizontal refresh cycle. Also a software interrupt triggered by the BRK instruction.

### Some small examples

The current section covers the initial parsing methods for both LoROM and HiROM. The games that this text is about to analyze are *Final Fantasy 4* (LoROM) and *Final Fantasy 6* (HiROM), both headerless.

#### Final Fantasy 4

We first look at the address $7FC0 in the ROM - the last byte of the LoROM bank is $7FFF, and the header takes up to 64/$40 bytes. The first byte of the header, IF it is LoROM (which we officially don't know yet, mind you) is therefore located at $7FC0.

```
00007FC0  46 49 4E 41 4C 20 46 41  4E 54 41 53 59 20 49 49  |FINAL FANTASY II|
00007FD0  20 20 20 20 20 20 02 0A  03 01 C3 00 0F 7A F0 85  |      .......z..|
00007FE0  FF FF FF FF FF FF FF FF  FF FF 00 02 FF FF 04 02  |................|
00007FF0  FF FF FF FF FF FF FF FF  FF FF FF FF 00 80 FF FF  |................|
```

That looks good. In the very first two lines the name of the ROM is written (since *Final Fantasy 4* was released as *Final Fantasy II* in NA, this actually makes sense). The first 21 bytes are just ASCII characters (and a rare opportunity to see clear text in a ROM, since the dialogues are usually stored in an other format than ASCII). The next byte after this string can be misinterpreted as just another space character, but in fact the byte at $D5 indicates that it's a LoROM cartridge (now we have two proves that the cartridge is LoROM: first the position of the header, second the byte indicating that the cartridge uses LoROM. By the way, if those two do not happen to match, the ROM is considered corrupted).

One might perform other check there (for example the size of the ROM vs. the size stored in the header, the country and licensee codes, the SRAM size ...), but for now, basically only two other bytes are essential to boot the ROM: the position of the RESET interrupt vector in emulation mode (which is issued the moment the ROM was mapped into the address space of the SNES). This vector is stored at $7FFC-D in little endian format (see above), which means that the vector is calculated this way:

```
emulation_reset_vector = rom_content[0x7FFC] | (rom_content[0x7FFD] << 8);
```

In this example, the vector is $8000 - the start-up code is right at the beginning of the first bank (yes, the first bank. Remember how the first bank gets stored in $8000 - $FFFF, while $0000 - $7FFF contains system information?).

Let's look a bit at the code there:

Hex:

```
00000000  78 18 FB C2 10 E2 20 9C  0D 42 9C 0B 42 9B 0B 42  |x..... ..B..B..B|
00000010  A9 8D 8D 00 21 A9 00 8D  00 42 A9 00 EB A9 00 48  |....!....B.....H|
```

Disassembled (with a program that I am developing myself, so don't bother asking where I'd got it):

```
$00:8000: 78      ;	SEI, disables interrupts. This is a crucial point in the execution of the ROM, so the CPU must not be interrupted.
$00:8001: 18      ;	CLC, clears the carry flag. This makes sense in the next instruction.
$00:8002: FB      ;	XCE, switches into native mode if the carry flag is clear.
$00:8003: C210    ;	REP #$10, sets the X and Y registers into 16 bit mode.
$00:8005: E220    ;	SEP #$20, sets the accumulator into 8 bit mode. This is all possible with the CPU still being in native mode.
$00:8007: 9C0D42  ;	STZ $420D, sets the memory access speed at 200ns when accessing banks >$7F.
$00:800A: 9C0B42  ;	STZ $420B, disables all DMA processes that might have been started.
$00:800D: 9C0C42  ;	STZ $420C, disables all HDMA processes that might have been started.
$00:8010: A98F    ;	LDA #$8F, bitmask 10001111 ...
$00:8012: 8D0021  ;	STA $2100, ... disables rendering and sets brightness to max.
$00:8015: A900    ;	LDA #$00, sets NMI and V/H count to zero and disables the joypad. 
$00:8017: 8D0042  ;	STA $4200, OK, actually this is done here ...
$00:801A: A900    ;	LDA #$00, stuff that is of no interest here ...
$00:801C: EB      ;	XBA
$00:801D: A900    ;	LDA #$00
$00:801F: 48      ;	PHA
```

You see that this seems plausible enough to be totally valid start-up code.

#### Final Fantasy 6

Again let's poke at offset $7FC0:

```
00007FC0  CD 85 CB C2 20 A5 D0 0A  AA BF 02 E6 CC 85 C9 A5  |.... ...........|
00007FD0  D0 CF 00 E6 CC 90 05 7B  E2 20 E6 CB 7B E2 20 A9  |.......{. ..{. .|
00007FE0  01 8D 68 05 60 9C 67 05  AD B9 1E 29 40 D0 05 AD  |..h.`.g....)@...|
00007FF0  45 07 D0 04 9C 45 07 60  A9 64 8D 67 05 A9 CE 85  |E....E.`.d.g....|
```

This seems to be a little off. Maybe it uses HiROM?

```
0000FFC0  46 49 4E 41 4C 20 46 41  4E 54 41 53 59 20 33 20  |FINAL FANTASY 3 |
0000FFD0  20 20 20 20 20 31 02 0C  03 01 33 00 CD a0 32 5F  |     1....3...2_|
0000FFE0  FF FF FF FF FF FF FF FF  FF FF 10 FF FF FF 14 FF  |................|
0000FFF0  FF FF FF FF FF FF FF FF  FF FF FF FF 00 FF FF FF  |................|
```

Yes, it does. And the RESET vector is at $FF00. Again in hex:

```
0000FF00  78 18 FB 5C 19 00 C0 FF  FF FF FF FF FF FF FF FF  |x..\............|
```

And disassembled:

```
$00:FF00: 78      ;	SEI, same start-up code ...
$00:FF01: 18      ;	CLC, ... as before ...
$00:FF02: FB      ;	XCE, ... isn't it?
$00:FF03: 5C1900C0;	JML $C00019, this is a bit different. The CPU preforms a long jump to a different location
```

In short, this code tells the executing CPU that $C0:0019 is the next instruction to execute. Since this is a HiROM memory mapping, this means that we have to look where the bank $C0 got mapped to. Referring to the former HiROM mapping table, the $C0 - $FD banks are direct mappings of $40 – $7D. And these banks in fact contain all the ROM content continuously - since $C0 &lt;=&gt; $40 and $40 is the beginning, the code to execute is basically at the beginning of the ROM, offset $19:

```
00000000  20 79 68 6B 03 00 08 08  4C 76 C1 4C 3F 4A EA EA  | yhk....Lv.L?J..|
00000010  EA EA EA EA EA 20 24 BB  6B 78 18 FB E2 20 C2 10  |..... $.kx... ..|
00000020  A2 FF 15 9A A2 00 00 DA  2B 7B 48 AB A9 01 8D 0D  |........+{H.....|
```

Disassembled:

```
$C0:0019: 78      ;	SEI, same code as before? 
$C0:001A: 18      ;	CLC, basically it IS the same code. This leads to the conclusion that the programmers wanted to make sure there are no interrupts enabled.
$C0:001B: FB      ;	XCE
$C0:001C: E220    ;	SEP #$20, sets the accumulator into 8 bit mode.
$C0:001E: C210    ;	REP #$10, sets the X and Y registers into 16 bit mode.	
$C0:0020: A2FF15  ;	LDX #$15FF, now THIS is interesting. The next instruction sets the stack. By default, the stack in
                  ; emulation mode is set to $100 and grows downwards ...
$C0:0023: 9A      ;	TXS, ... and this is not changed with entering native mode. This instruction sets the stack to $15FF. 
$C0:0024: A20000  ;	LDX #$0000, the next three instructions set the X register to 0, push that value on the new stack, and pull it to the
                  ; Direct Page register immediately.
$C0:0027: DA      ;	PHX, the reason why they have to do this is because the accumulator is 8 bit and the direct page register is 16 bits.
$C0:0028: 2B      ;	PLD
$C0:0029: 7B      ;	TDC, and now they set A to that value.
$C0:002A: 48      ;	PHA, now this makes sense. The DBR register can be directly set only via pulling the value from stack ...
$C0:002B: AB      ;	PLB, ... which is done here. So all relative accesses should be directed to bank $00.
$C0:002C: A901    ;	LDA #$01
$C0:002E: 8D0D42  ;	STA $420D, and again the hardware registers are set ...
```

# External Links

- [SNES Memory Map](http://www.romhacking.net/docs/173/)
- [Another SNES Memory Map](http://www.emulatronia.com/doctec/consolas/snes/SNESMem.txt)
- [Yet Another SNES Memory Map](http://gatchan.net/uploads/Consoles/SNES/Flashcard/SNES_MemMap.txt)
- [List of various hardware registers](https://wiki.superfamicom.org/registers)
- [Explanation about Most Significant Bytes (MSBs)](https://en.wikipedia.org/wiki/Most_significant_bit)
- [Explanation of the 65816 architecture (SNES CPU) that is actually helpful](http://softpixel.com/~cwright/sianse/docs/65816NFO.HTM)

# See Also

- [SNES hardware registers](/wiki/Super_NES_Programming/SNES_Hardware_Registers "Super NES Programming/SNES Hardware Registers")
