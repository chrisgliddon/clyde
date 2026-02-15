---
title: "Super FX"
reference_url: https://sneslab.net/wiki/Super_FX
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
  - "Enhancement_Chips"
  - "Super_FX"
downloaded_at: 2026-02-14T16:52:53-08:00
cleaned_at: 2026-02-14T17:54:37-08:00
---

**Super FX** is a Super NES enhancement chip developed by [Argonaut Games](https://en.wikipedia.org/wiki/Argonaut_Games) and [Nintendo](http://en.wikipedia.org/wiki/Nintendo). It's also known as the "Graphical Support Unit" (short for "GSU") for its greater graphical capabilities compared to the S-CPU whereas its first revision, used for Star Fox, uses the name "Mathematical, Argonaut, Rotation, & Input/Output" or short MARIO chip. It also is know for the use in *Super Mario World 2: Yoshi's Island*.

During this article, GSU refers to Super FX whereas CPU refers to the Super NES CPU.

## Features

This embedded co-processor has a base clock speed of **10.74 MHz** - four times as fast as the S-CPU, which uses a base block of 2.68 Mhz. Its features include but are not limited to:

- A RISC-like processor where most opcodes have an instruction size of one byte and are executed in a single cycle when in cache.
- 512 bytes of cache RAM for faster processing of instructions.
- A large memory capactiy, a total capacity of 8 MiB ROM, of which two MiB are shared by CPU and GSU, and 256 KiB RAM, of which 128 KiB are shared by CPU and GSU.
- A separate bus for ROM and RAM to handle memory in parallel
- Parallel processing with the CPU
- Fast Bitmap to Planar conversion
- Pipeline processing to fetch opcodes twice as fast, effectively increasing the processing speed to 21.48 MHz.

# Technical Information

## Hardware Registers

Super FX comes with various hardware registers of various functions. Most (but not all) of the GSU hardware registers can be accessed from the CPU when the GSU is idling. They are located in the $3000-$3FFF region in banks $00-$3F and $80-$BF.

### General Registers (R0-R13)

These registers are more or less equivalent to the A, X and Y registers on the 65c816. They all are parameters to many opcodes, though not all of them are valid (e.g. R0 can't be a parameter for the logical operators), and are all 16-bit. Some of them come with a secondary use for certain opcodes. The CPU can directly read from and write to these registers $3000-$301B.

A list of their addresses and their secondary functions Name Address Secondary Function R0 $3000 Default source/destination register. R1 $3002 PLOT X position R2 $3004 PLOT Y position R3 $3006 R4 $3008 Low word for LMULT result R5 $300A R6 $300C Second input for LMULT and FMULT R7 $300E MERGE source 1 R8 $3010 MERGE source 2 R9 $3012 R10 $3014 R11 $3016 LINK destination R12 $3018 LOOP counter R13 $301A LOOP start

### Game Pak ROM Address Pointer (R14)

R14 is the ROM Pointer register and is mapped to $301C-$301D on the SNES. It's the pointer for the GETB opcodes which allows the GSU to read from ROM. It otherwise acts like any normal general register and is sometimes used as such.

### Program Counter (R15)

R15 is the program counter and is mapped to $301E-$301F on the SNES. Unlike on the 65c816 processor, the program counter (excluding the bank) can be directly read or modified within code as it acts like a general register. This makes it possible to e.g. jump to a certain address without the use of a dedicated opcode. For example, `IWT R15, #xxxx` on Super FX is equivalent to `JMP $xxxx` on the 65c816.

In addition, writing to $301E on the CPU side invokes the GSU.

### Status/Flag Register (SFR)

Super FX comes with a 16-bit register of various flags, mostly from calculations (e.g. a carry flag) but also other flags like whether Super FX is currently running. They can be read and written through $3030 and $3031 on the CPU side.

Status/Flag Register bitwise B7 B6 B5 B4 B3 B2 B1 B0 $3031 IRQ - - B IH IL ALT1 ALT2 $3030 - R G OV S CY Z -

Description of Flags Flag Description Z Zero flag, set when result is zero. CY Carry flag, set at result overflow (unsigned). S Sign flag, set when number is negative. OV Overflow flag, set at result overflow (signed). G Go flag, set when GSU is running. R Set when reading from ROM. ALT1 Opcode modifier 1, set when executing ALT1. ALT2 Opcode modifier 2, set when executing ALT2. IL Immediate lower 8-bit flag. IH Immediate higher 8-bit flag. B Set when executing WITH. IRQ Interrupt flag, set when GSU stopped.

### Program Bank Register (PBR)

The program bank is the bank where GSU code is executed. It's a readable and writable 8-bit register which is mapped to $3034 on the CPU side. Unlike R15, this can only be modified indirectly using LJMP on GSU side.

### Game Pak ROM Bank Register (ROMBR)

This register controls the bank where ROM is read. It's set using the ROMB on the GSU side. It's a readable only 8-bit register which is mapped to $3036 on the CPU side. Its initial value is invalid. It can only be used to specify banks 00h to 5fh.

### Game Pak RAM Bank Register (RAMBR)

This register is the RAM equivalent to ROMBR. It's set using the RAMB on the GSU side. It's a readable only 1-bit register which is mapped to $303C on the CPU side. Its initial value is invalid. The top 7 bits of 303ch return zero when read.

### Cache Base Register (CBR)

The Cache Base Register is the address where cache has been enabled through and tells the GSU where to run code in cache. It's readable 16-bit register accessible through $303E and $303F from the CPU and written by the GSU with the CACHE and LJMP opcodes. The lowest four bits of this register are open bus since cache is stored in 16-byte blocks.

### Screen Base Register (SCBR)

The Screen Base Register is the high byte of the image buffer i.e. the plotting destination. It's a writeable 8-bit register mapped to $3038 on the CPU side.

### Screen Mode Register (SCMR)

The Screen Mode Register contains the settings for the image buffer (dimensions, bitdepth) but also access to ROM and RAM. It's a writeable 8-bit register mapped to $303A on the CPU side.

Screen Mode Register bitwise B7 B6 B5 B4 B3 B2 B1 B0 - - HT1 ROM RAN HT0 MD1 MD0

The image buffer dimensions are given by HT0 and HT1. They all are 256 pixels wide but have different heights. A special case exists when both bits are 1 which enables OBJ mode which is used to plot single sprites like in *Yoshi's Island*.

Screen Dimensions HT1 H00 Mode 0 0 256 by 128 0 1 256 by 160 1 0 256 by 192 1 1 OBJ mode

The bitdepth of the image buffer is set by the MD0 and MD1 bits:

Screen Mode MD1 MD0 Mode 0 0 4-color mode (2bpp) 0 1 16-color mode (4bpp) 1 0 Not used 1 1 256-color mode (8bpp)

The SCMR register also controls whether Game Pak ROM and RAM can be accessed by the CPU or GSU:

Screen Mode Bit Description RON Gives ROM access to the CPU when 0 and GSU when 1. RAN Gives RAM access to the CPU when 0 and GSU when 1.

### Color Register (COLR)

The Color Register contains the colour for the pixel which is to be plotted. It's an 8-bit register which is set using the COLOR and GETC opcodes on the GSU. There is no access from the CPU.

### Plot Options Register (POR)

The Color Register controls how the colours are loaded into the COLR register as well as how they're drawn onto the buffer. It's an 8-bit register which is set using the CMODE opcode on the GSU. There is no access from the CPU.

Screen Mode Register bitwise B7 B6 B5 B4 B3 B2 B1 B0 - - - OBJ FH HN DT TP

Note that these abbreviations are inofficial and have been included for simplification.

Description of Screen Mode Register Bit Description OBJ OBJ Flag FH Freeze High Flag HN High Nibble Flag DT Dither Flag TP Transparent Flag

### Backup RAM Register (BRAMR)

This controls whether Back-up RAM (not to be confused with Game Pak RAM) becomes “protected”.1 It's a 1-bit register mapped to bit 0 of $3033 which can be written by the CPU.

1The definition of “protected” isn't very clear, though it can be assumed that Back-up RAM can't be written when it's set to be protected.

### Version Code Register (VCR)

The Version Code Register contains the version code of the Super FX chip. It's an 8-bit read-only register and accessed $303B on the CPU side.

### Config Register (CFGR)

The Config Register contains two flags: The IRQ flag which allows the GSU to fire an interrupt to the CPU should it stop and the MS0 which controls the speed of the multiplication. It's mapped to bit 0 of $3039 and is writeable from the CPU.

### Clock Select Register (CLSR)

This register sets the clock speed of Super FX and enables pipelining in the process. When clear, Super FX runs at 10.74 MHz, when set, at 21.48 MHz. It's mapped to bit 0 of $3039 and is writeable from the CPU.

Supposedly, the CLSR and MS0 flags must not be set 1 at the same time but no side effects are known.

## Memory and Bus

### Memory Map

One advantage of Super FX is that it naturally supports ROMs with a size of up to 8 MiB. However, Super FX can only use the first two MiB of a ROM. Similarly, even though a single cartridge may have up to 256 KiB of SRAM, only half of them can be used by Super FX. As a result, there is a difference between the CPU and GSU mapping.

This is how the ROM is mapped from the perspective of the CPU:

Banks Address Description $00-$3F $0000-$1FFF WRAM mirror $2100-$21FF PPU registers $3000-$3FFF Super FX registers $4200-$43FF CPU registers $6000-$7FFF SRAM mirror $8000-$FFFF ROM (LoROM) $40-$5F $0000-$FFFF Mirror of ROM in banks $00-$3F (HiROM) $60-$6F $0000-$FFFF Unmapped $70-$71 $0000-$FFFF SRAM $7C-$7D $0000-$FFFF Backup RAM $7E-$7F $0000-$FFFF WRAM $80-$BF $0000-$1FFF WRAM mirror $2100-$21FF PPU registers $3000-$3FFF Super FX registers $4200-$43FF CPU registers $6000-$7FFF SRAM mirror $8000-$FFFF ROM (LoROM) $C0-$FF $8000-$FFFF ROM (HiROM)

The GSU memory map looks similar to the CPU mapping but only with access to ROM and SRAM as well as only access to 2 MiB of ROM and 128 KiB of SRAM. As a result, it looks more like this:

Banks Address Description $00-$3F $0000-$7FFF Unmapped $8000-$FFFF ROM (LoROM) $40-$5F $0000-$FFFF Mirror of ROM in banks $00-$3F (HiROM) $60-$6F $0000-$FFFF Unmapped $70-$71 $0000-$FFFF SRAM $72-$7F $0000-$FFFF Unmapped $80-$FF $0000-$FFFF Mirror of $00-$7F

Finally, it should be noted that banks $40-$5F are HiROM mirrors of the LoROM banks $00-$3F interlaced so addresses such as $008000 and $400000 contain the same value.

The official Super Nintendo development manual contains an image of the Super FX memory map as Figure 2-3-2 on [page 2-3-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n106).

### ROM

ROM on Super FX can be up to 8 MiB large. However, even though the size is theoretically doable, the largest published Super FX games had a ROM size of 2 MiBs. As a result, not many emulators (not even BSNES as of 2021) emulate this feature properly and such ROM sizes only exist in homebrewing and modding.

Super FX has also has got limitations with ROM access. This first example is the ROM size. Even though a Super FX ROM can be as large as 8 MiB (in theory), the GSU's data bus is only connected to 2 MiB of it. Said portion of ROM which the processor can access is called GamePak ROM while the additional 6 MiB, called the Super NES ROM, can only be accessed by the CPU. A second limitation is the clock speed. The GSU is clocked very fast at 10.74 Mhz (which can be doubled with pipelining) but ROM is clocked at 3.58 Mhz (unlike on SA-1 where ROM is clocked at the same frequency as the coprocessor). As a result, all opcodes, when they are executed in ROM, take at least three cycles to process while reads from ROM are slow.

To counteract against this limitation, the GSU uses a buffering system. In order to load a value from ROM, the bank must first be set in ROMBR (set by ROMB in the GSU code) while the address is set in register R14. Any write to R14 initiates the buffering process (it's also this reason it isn't considered a general purpose register even though it can be used as such). The value then can be retrieved with GETB and similar opcodes (referred to just `GETB` from now on).

The GSU doesn't wait during the process of fetching. As a result, it is possible to call `GETB` some time after writing to R14. In fact, this is even recommend because calling `GETB` during the process of fetching will cause the GSU to halt for up to five cycles for executing `GETB`. Similarly, writing to `ROMB` will halt the code as well until the data has been fetched and enabling cache during the process of fetching will mess up the loaded ROM value.

### RAM

### Cache

In order to improve the speed of the processor, it includes a 512 byte large memory with the same frequency as the GSU as a cache. This allows Super FX to execute a single opcode with only a single cycle (i.e. three times as fast as in regular use). The cache is separated into 32 16-byte blocks, each with a flag which denotes that a block is used, and is indexed by the cache base register (CBR) which is used to keep track of where cache has been invoked. The cache flags and CBR are reset whenever a zero is written to the GO flag but simply halting or invoking the GSU preserves the content of the cache which in turn can be read by the CPU.

Cache on the SNES is mapped to addresses $xx:3100-$xx:32FF ($xx = $00-$3F, $80-$BF), though the start of the cached code (see below) also is dependent on the CBR (start = $3100 + (CBR & 0x1FF)).

There are two methods to fill the cache:

- Manual caching
- Automatic caching

Manual caching involes using the CPU and transfer the code to cache. Keep in mind that Super FX will only execute the cache block which has been set to be used. That means, the code has to be transfered as a full 16 byte block, though strictly speaking, only the last byte of the block (address $XXXF) needs to be written to count the block as used. In order to execute GSU code in cache, R15 has to be set to $0000-$01FF.

Automatic caching is instead handled by the GSU itself. This is handled either by the dedicated CACHE opcode or by a LJMP opcode, the latter because of the lack of bank information for the cache. Both of them clear the cache flags and store the current PC with the lowest nibble masked out into the CBR (CBR = PC & 0xFFF0). Afterwards, each executed opcode will be written into cache starting from CBR & 0x1FF. As a result, this use of cache is recommend for loops and the first loop will always run slower than the remaining loops. Should all the blocks be used, any remaining code will be left uncached and executed in the original memory.

Another side effect is that cache is neither ROM nor GamePak RAM so any Super FX code in cache can run in parallel to the SNES even when access to ROM and RAM is given to the CPU instead of GSU.

### Pipeline Processing

In order to boost the processing speed of the GSU, it uses a technique called "pipeline processing". Pipelining exists to a lesser extend on the 65c816, where opcodes are prepared while the remaining bytes of the opcodes are fetched (this is notable on single byte opcodes such as INC which take two cycles to process, the same amount of cycles as `LDA #$xx`, a two byte opcode) but the GSU takes it further by fetching the next opcode during the current opcode's execution. This runs the code double as fast, virtually increasing the clock speed to 21.48 MHz at the cost of adding more care of the coder whenever R15 — the programm counter — is changed, either through branching or through direct writes to R15. In addition, internal processes such as multiplication and memory access can't take advantage of the virtual increment in clock speed.

Pipelining is controlled with bit 0 of CLSR where clear means pipelining disabled and set means pipelining enabled. It's accessible on the CPU side at the address $3037.

For the most part, having pipelining enabled doesn't change the code. The only exceptions are when R15 is modified outside of fetching opcodes i.e. the use of branches and writes to R15 (e.g. `IWT R15,#$8000`) as well as halting the GSU such as with STOP. In these cases, the opcode following that instruction will be executed after the branch. A common solution for the unwanted opcode execution is to put a dummy NOP after the R15 modifying opcode such as in this example:

```
BCC SkipCode
NOP             ; Dummy NOP
...
SkipCode:
```

This proves to be inefficient, though. Most Super FX opcodes are one byte large and take 3 or 1 cycles (depending on whether the code is executed in cache or not) to execute including `NOP`. As a result, opcodes such as `SUB R0` can be put as a dummy opcode in place of `NOP`. The following example demonstrates it:

```
BCC SkipCode
;NOP            ; Redundant
SUB R0          ; Set R0 to zero
STW (R1)
SkipCode:
IWT R0,#$1234
```

In the above code, R0 gets overwritten by `SUB` no matter whether the branch is taken. However, it later gets overwritten by `IWT`. As a result, it doesn't matter whether the dummy opcode is a `NOP` or `SUB` from the branch for the calculation. In fact, using a `NOP` increases the code size by one byte which can matter when the code is executed in cache as well as increase the cycle count by 1 or 3 cycles each time the branch is executed, causing in total a minor speed penality.

This doesn't work for every opcode, though. Opcodes such as `ADD #x` (opcodes which are internally prefixed with `ALTn`), `WITH` (register prefixes which change which register is the source or destination), `BRA $10` (branches which always use two bytes) and `IWT` (immediate value transfers which use two or three bytes) can only be used as a dummy opcode in very specific circumstances. The latter two can even misalign the program counter not unlike executing `LDA #$12` when A is in 16-bit mode on the 65816. The following example demonstrates it:

```
BCC SkipCode
BRA Error       ; Caution!

SkipCode:
INC R1          ; Will instead be read with the BRA as "BRA $D1".
...

Error:
```

In addition, the dummy opcode after a `STOP` **must** be a `NOP` because putting the GSU in WAIT will not clear the opcode in the pipeline. Extra care should be taken when pipeliend code is executed and a `STOP` is located at $XXXF in cache as the pipelined code may be located in unused cache and a value in ROM/RAM will be loaded instead.

## Bus Conflicts

Between both processors, only one of them can acess Game Pak ROM and RAM at a time so memory access must be controlled. Access is set by the SCMR, by the RON and RAN bits with 0 meaning CPU access and 1 meaning GSU access.

For the GSU, it's set to WAIT if it isn't granted access for the respective memory it tries to access (e.g. executing code in ROM, storing to RAM). Once it's granted access, the WAIT status is reset and execution resumes.

For the CPU, illegal memory access is different as it lacks a WAIT state or a comparable feature. For this reason, the processor instead reads garbage values. The specific values actually depend on the type of memory: For illegal RAM access, the CPU reads from open bus instead but for illegal ROM access, the memory bus provides a dummy byte whose value depends on the lowest nibble of the address instead:

Address Low Nibble Byte 0x0, 0x2, 0x6, 0x8, 0xC 0x00 0x4 0x04 0xA 0x08 0xE 0x0C Other 0x01

The main purpose of the dummy data is to handle interrupts where the CPU needs to read from ROM to execute code at the given address. This is why on Super FX ROMs, interrupts point to these specific addresses, all of which are in WRAM:

Address Interrupt $000100 BRK $000104 COP $000108 NMI $00010C IRQ

The pointers are spaced to leave enough space for a single `JML $xxxxxx` to jump to the actual interrupt code. Relatedly, Super FX games upload their interrupt and invoke GSU codes into WRAM and execute them there to handle cases where e.g. an interrupt is fired during GSU execution.

No control exists for cache, it's always assumed to be granted access to the GSU but can be safely accessed by the CPU if the former isn't running.

This limitation specifically applies to Game Pak ROM and RAM; Super NES CPU ROM and Back-Up RAM, neither of which the GSU can access, are excluded from bus conflicts.

## Bitmap Processing

## External Links

- Patent: [https://patentimages.storage.googleapis.com/de/a2/7a/f07754f66f39d9/US5724497.pdf](https://patentimages.storage.googleapis.com/de/a2/7a/f07754f66f39d9/US5724497.pdf)
