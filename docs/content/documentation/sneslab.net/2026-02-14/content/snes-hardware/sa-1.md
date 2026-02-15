---
title: "SA-1"
reference_url: https://sneslab.net/wiki/SA-1
categories:
  - "SNES_Hardware"
  - "ASM"
  - "Integrated_Circuits"
  - "Enhancement_Chips"
  - "SA-1"
downloaded_at: 2026-02-14T16:16:49-08:00
cleaned_at: 2026-02-14T17:54:35-08:00
---

**Nintendo SA-1** (Super Accelerator) is an enhancement chip made by [Nintendo](http://en.wikipedia.org/wiki/Nintendo), used in 33 SNES games. The RF5A123 chip is based on the 65c816 processor, the same one used by the main SNES CPU, the RF5A22. With identical architecture to the SNES one, the chip is ideal for games and ROM hacks that can reuse code from the main CPU, thus not having to learn an additional assembling language or architecture.

When you are on the SA-1 context, the SA-1 CPU is often referred as "C-CPU" ("C" stands for co-processor) while the SNES CPU is often referred as "S-CPU" ("S" stands for SNES). There is no master or slave, because both processors can interrupt each other though IRQs, keeping in mind that initially SA-1 boots up in the sleeping state and must be initialized by the SNES CPU.

## Features

The embedded co-processor has a **10.74 MHz** base clock speed, which is four times faster compared to the 2.68 MHz base clock speed from the S-CPU (a.k.a. SlowROM). In addition to that, it includes additional hardware circuits for data I/O, bitmap manipulation modes, arithmetic registers and high-speed internal memory.

- 16-bit 65c816 processor clocked at 10.74 MHz.
- 2 kB internal work memory (I-RAM), clocked at 10.74 MHz.
- Multi-processor processing, with parallel operating mode and automatic memory sharing control.
- Large capacity memory, with a total capability of 8 MB ROM and 256 kB BW-RAM, both clocked at 5.37 MHz, with ROM having an effective 10.74 MHz speed because of the 16-bit data bus.
- High speed arithmetic multiplication, division and cumulative sum (multiply with add) hardware.
- Bitmap and Character Conversion functions for fast graphics manipulation.
- Custom DMA circuit for fast transfers between ROM, I-RAM and BW-RAM.
- Variable-Length Bit data processing for enhanced algorithms such as graphics and data compression.
- Super MMC memory mapping capabilities for BW-RAM and bank switching for multiple ROM image access and mirroring.

## ROM Hacking

SA-1 Root and SA-1 Pack are known patches used for enabling SA-1 on SNES games that didn't include the chip previously and had problems with slowdown, such as *Super Mario World*, [*Gradius III*](/mw/index.php?title=Gradius_III&action=edit&redlink=1 "Gradius III (page does not exist)") and [*Contra III*](/mw/index.php?title=Contra_III&action=edit&redlink=1 "Contra III (page does not exist)").

# Technical Information

There is not much technical information available on how the SA-1 chip works. Most of the findings are recent and are based on both official documents from Nintendo and experiments on real SA-1 carts. This section is getting continuously updated with new information and findings though the time. The information available here is expected to be accurate. Information about undefined behavior or design details is considered scarce right now.

## Hardware Registers

The SA-1 internal registers are assigned on range $2200-$23FF, on banks $00-$3F and $80-$BF. $2200 though $22FF are write-only registers while $2300 though $23FF are read-only registers.

- Attempting to read a write-only register yields open bus.
- Attempting to write a SA-1 write register on SNES side or vice-versa yields nothing, with the exception of hybrid write registers.
- Attempting to read a SA-1 read register on SNES side or vice-versa yields open bus.

### Register Summary

#### Write Registers

Address Length Code Access Description $2200 1 byte CCNT SNES SA-1 CPU CONTROL $2201 1 byte SIE SNES SUPER NES CPU INT ENABLE $2202 1 byte SIC SNES SUPER NES CPU INT CLEAR $2203 2 bytes CRV SNES SA-1 CPU RESET VECTOR $2205 2 bytes CNV SNES SA-1 CPU NMI VECTOR $2207 2 bytes CIV SNES SA-1 CPU IRQ VECTOR $2209 1 byte SCNT SA-1 SUPER NES CPU CONTROL $220A 1 byte CIE SA-1 SA-1 CPU INT ENABLE $220B 1 byte CIC SA-1 SA-1 CPU INT CLEAR $220C 2 bytes SNV SA-1 SUPER NES CPU NMI VECTOR $220E 2 bytes SIV SA-1 SUPER NES CPU IRQ VECTOR $2210 1 byte TMC SA-1 H/V TIMER CONTROL $2211 1 byte CTR SA-1 SA-1 CPU TIMER RESTART $2212 2 bytes HCNT SA-1 SET H-COUNT $2214 2 bytes VCNT SA-1 SET V-COUNT $2220 1 byte CXB SNES SET SUPER MMC BANK C $2221 1 byte DXB SNES SET SUPER MMC BANK D $2222 1 byte EXB SNES SET SUPER MMC BANK E $2223 1 byte FXB SNES SET SUPER MMC BANK F $2224 1 byte BMAPS SNES SUPER NES CPU BW-RAM ADDRESS MAPPING $2225 1 byte BMAP SA-1 SA-1 CPU BW-RAM ADDRESS MAPPING $2226 1 byte SBWE SNES SUPER NES CPU BW-RAM WRITE ENABLE $2227 1 byte CBWE SA-1 SA-1 CPU BW-RAM WRITE ENABLE $2228 1 byte BPWA SNES BW-RAM WRITE-PROTECTED AREA $2229 1 byte SIWP SNES SA-1 I-RAM WRITE PROTECTION $222A 1 byte CIWP SA-1 SA-1 I-RAM WRITE PROTECTION $2230 1 byte DCNT SA-1 DMA CONTROL $2231 1 byte CDMA Both CHARACTER CONVERSION OMA PARAMETERS $2232 3 bytes SDA Both DMA SOURCE DEVICE START ADDRESS $2235 3 bytes DDA Both DMA DESTINATION START ADDRESS $2238 2 bytes DTC SA-1 DMA TERMINAL COUNTER $223F 1 byte BBF SA-1 BW-RAM BIT MAP FORMAT $2240 16 bytes BRF SA-1 BIT MAP REGISTER FILE $2250 1 byte MCNT SA-1 ARITHMETIC CONTROL $2251 2 bytes MA SA-1 ARITHMETIC PARAMETERS: MULTIPLICAND/DIVIDEND $2253 2 bytes MB SA-1 ARITHMETIC PARAMETERS: MULTIPLIER/DIVISOR $2258 1 byte VBD SA-1 VARIABLE-LENGTH BIT PROCESSING $2259 3 bytes VDA SA-1 VARIABLE-LENGTH BIT GAME PAK ROM START ADDRESS

#### Read Registers

Address Length Code Access Description $2300 1 bytes SFR SNES SUPER NES CPU FLAG READ $2301 1 bytes CFR SA-1 SA-1 CPU FLAG READ $2302 2 bytes HCR SA-1 H-COUNT READ $2304 2 bytes VCR SA-1 V-COUNT READ $2306 5 bytes MR SA-1 ARITHMETIC RESULT \[PRODUCT/QUOTIENT/ACCUMULATIVE SUM] $230B 1 bytes OF SA-1 ARITHMETIC OVERFLOW FLAG $230C 2 bytes VDP SA-1 VARIABLE-LENGTH DATA READ PORT $230E 1 byte VC SNES VERSION CODE REGISTER (OPEN BUS)

### Register Details

#### $2200 - SA-1 CPU CONTROL

#### $2201 - SUPER NES CPU INT ENABLE

#### $2202 - SUPER NES CPU INT CLEAR

#### $2203 - SA-1 CPU RESET VECTOR

#### $2205 - SA-1 CPU NMI VECTOR

#### $2207 - SA-1 CPU IRQ VECTOR

#### $2209 - SUPER NES CPU CONTROL

#### $220A - SA-1 CPU INT ENABLE

#### $220B - SA-1 CPU INT CLEAR

#### $220C - SUPER NES CPU NMI VECTOR

#### $220E - SUPER NES CPU IRQ VECTOR

#### $2210 - H/V TIMER CONTROL

#### $2211 - SA-1 CPU TIMER RESTART

#### $2212 - SET H-COUNT

#### $2214 - SET V-COUNT

#### $2220-$2223 - SET SUPER MMC BANK C/D/E/F

D7 D6 D5 D4 D3 D2 D1 D0 Register CBM 0 0 0 0 CB2 CB1 CB0 $2220 DBM 0 0 0 0 CB2 CB1 CB0 $2221 EBM 0 0 0 0 CB2 CB1 CB0 $2222 FBM 0 0 0 0 CB2 CB1 CB0 $2223

CB2~CB0: Which megabyte of the ROM to map to $C0-$CF / $D0-$DF / $E0-$EF / $F0-$FF.

CBM/DBM/EBM/FBM: If set, apply image projection to LoROM banks as well.

Flag Bank Range CBM Apply to banks $00-$1F DBM Apply to banks $20-$3F EBM Apply to banks $80-$9F FBM Apply to banks $A0-$BF

Registers are responsible for setting up the ROM bank mapping. By default, the values { $00, $01, $02, $03 } are loaded on power up.

Bits CBM/DBM/EBM/FBM determine if the mapping should apply to the LoROM banks as well, otherwise they will have the constant value of { $00, $01, $02, $03 } regardless of the ROM size. Given that, it's possible the entire 8 MB layout at once by storing values { $04, $05, $06, $07 } to the registers. Snes9x 1.53 and older always treated these flags as set, making the mapping always apply to the LoROM banks.

Common values Register $2220 $2221 $2222 $2223 Comment Value $00 $01 $02 $03 Default values Value $04 $05 $06 $07 Maps the first 4 MB to banks $00-$3F and $80-$BF, with LoROM-like layout. The last 4 MB is mapped to $C0-$FF, with HiROM-like layout. Value $80 $81 $80 $81 Simulates the standard LoROM map with FastROM compatibility by mapping the first 2 MB to $00-$3F and $80-$BF.

The Super MMC register affects all memory maps, including SNES, SA-1, SA-1 DMA and SA-1 Variable Length Bit maps. bsnes 0.7x does not apply the custom memory mapping to Variable Length Bit circuit.

Hardware verification has shown that the unused bits has no effects to the chip pinout and therefore the maximum ROM size for the SA-1 without using a custom ROM controller outside the chip is 8 MB (megabytes).

#### $2224 - SUPER NES CPU BW-RAM ADDRESS MAPPING

#### $2225 - SA-1 CPU BW-RAM ADDRESS MAPPING

#### $2226 - SUPER NES CPU BW-RAM WRITE ENABLE

#### $2227 - SA-1 CPU BW-RAM WRITE ENABLE

#### $2228 - BW-RAM WRITE-PROTECTED AREA

#### $2229 - SA-1 I-RAM WRITE PROTECTION

#### $222A - SA-1 I-RAM WRITE PROTECTION

#### $2230 - DMA CONTROL

#### $2231 - CHARACTER CONVERSION OMA PARAMETERS

#### $2232 - DMA SOURCE DEVICE START ADDRESS

#### $2235 - DMA DESTINATION START ADDRESS

#### $2238 - DMA TERMINAL COUNTER

#### $223F - BW-RAM BIT MAP FORMAT

D7 D6 D5 D4 D3 D2 D1 D0 Register SEL42 - - - - - - - $223F

Bits Meaning SEL42 0 to make banks $60-$6F split in 4 bits chunks (4BPP) or 1 to split in 2 bits chunks (2BPP)

#### $2240 - BIT MAP REGISTER FILE

#### $2250 - ARITHMETIC CONTROL

#### $2251 - ARITHMETIC PARAMETERS: MULTIPLICAND/DIVIDEND

#### $2253 - ARITHMETIC PARAMETERS: MULTIPLIER/DIVISOR

#### $2258 - VARIABLE-LENGTH BIT PROCESSING

#### $2259 - VARIABLE-LENGTH BIT GAME PAK ROM START ADDRESS

#### $2300 - SUPER NES CPU FLAG READ

#### $2301 - SA-1 CPU FLAG READ

#### $2302 - H-COUNT READ

#### $2304 - V-COUNT READ

#### $2306 - ARITHMETIC RESULT \[PRODUCT/QUOTIENT/ACCUMULATIVE SUM]

#### $230B - ARITHMETIC OVERFLOW FLAG

#### $230C - VARIABLE-LENGTH DATA READ PORT

#### $230E - VERSION CODE REGISTER (OPEN BUS)

D7 D6 D5 D4 D3 D2 D1 D0 Register VC7 VC6 VC5 VC4 VC3 VC2 VC1 VC0 $230E

Bits Meaning VC0 ~ VC7 SA-1 Device Version

According the SNES Development Book II, this register was supposed to hold the SA-1 chip version code, however tests made on some real carts has shown that this register in particular is actually open bus.

* * *

## Memory and Bus

### Memory Map

#### SNES Side

#### SA-1 Side

#### Open Bus Behavior

### ROM

### I-RAM

#### Write Protection

### BW-RAM

#### Write Protection

### Virtual Bitmap Memory

### Super MMC

### Bus Conflicts

## Direct Memory Access

### Character Conversion DMA

### Parallel DMA

### Interactions with SNES DMA

### Undefined Behavior

## Variable Length Bit

### Fixed Mode

### Automatic Mode

### Mixed Mode

## Arithmetic Operations

### Multiplication

### Division

### Cumulative Sum

## Parallelism and I/O

### IRQ

### NMI

### FastROM Interactions
