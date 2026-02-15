---
title: "SPC700/IPL ROM"
reference_url: https://sneslab.net/wiki/SPC700/IPL_ROM
categories:
  - "Audio"
  - "SNES_Hardware"
downloaded_at: 2026-02-14T16:36:45-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

The **Initial Program Loader Boot ROM**, or IPL ROM, is the very first program executed by the SPC700 on power on. It clears memory locations $00-$EF, then once it does so, it sends a signal to the SNES through two of the CPUIO registers. $0000-$0001 are reserved to hold the pointer, but all other memory locations can be written to. The IPL ROM itself is read-only: if written to, it simply writes to the same memory location that can be accessed when bit 7 of the CONTROL I/O port ($F1) is cleared. It is 64 bytes in size in the uppermost page.

The transfer routine at $FFD6 runs once per downloaded block.

At the beginning of the transfer routine, the SPC's Y index register is used to watch Port 0 until the 5A22 writes a zero to it, which indicates it has uploaded byte 0 of the block to Port 1. Then we enter the inner byte-downloading loop at $FFDA, where Y remembers the less significant byte of the index into the block currently being being downloaded (the "expected byte index" as anomie calls it). The 5A22 sends the less significant byte of the actual index (the "next byte/end" signal as anomie calls it) over Port 0. Y is then incremented.

## Communication with the SNES

### Step 1 (SPC700 Initializes Itself)

Output

```
$AA $BB ?? ??
```

The very first step is for the SPC700 to output two values to $2140/$F4 and $2141/$F5. The SNES must ensure that the SPC700 has finished initializing itself (and clearing out memory locations $0000-$00EF) by confirming these two values are present in those two registers: only then may the SNES send commands.

### Step 2 (Execute Command)

Input

```
$CC xx yy yy
```

- `xx` indicates what you want to do. If this is zero, then the program jumps to `yy yy`. Otherwise, `yy yy` is the starting memory location of the next block, and we go to step 3.
- `yy yy` is a little endian pointer. See `xx` for more details.

$CC should be sent last in this case.

Output

```
$CC $BB ?? ??
```

### Step 3 (Receive Block from SNES)

Input

```
xx yy ?? ??
```

- `xx` is a byte counter, and this should be sent last on byte ordering. Zero must be sent first to indicate that this is the first block. If this is greater (from a signed comparison, thus no greater than $80 more than the expected value: otherwise, the command won't work) than the value that was last sent to the SNES, then we go to step 4.
- `yy` is the input byte to send. The pointer is incremented.

Output

```
xx $BB ?? ??
```

- `xx` is the next byte ID to send over. This is incremented per byte sent.

This step repeats until `xx` is sent a value that is greater than the initially expected value, then we go to step 4.

### Step 4 (Terminate Block)

Input

```
xx yy zz zz
```

- `xx` must be greater (from a signed comparison, thus no greater than $80 more than the expected value: otherwise, the command won't work) than the last value that the SPC700 sent to the SNES. This byte should be sent last order-wise. Note that if this is zero (only occurs if the counter was previously $80-$FF), you'll instantly send a byte if `yy` is non-zero and start your next block right away (the zero case still jumps as per the usual).
- `yy` indicates what to do next. If this is zero, then the program jumps to `zz zz`. Otherwise, `zz zz` is the starting memory location of the next block, and we go to step 3.
- `zz zz` is a little endian pointer. See `yy` for more details.

Output

```
xx $BB ?? ??
```

- `xx` is the ID that was sent to terminate the block.

**Note if you choose to jump to the program, then depending on the program, your acknowledgement from the IPL Boot ROM may end up being very short. Thus, unless your program accounts for this, make sure to disable your interrupts prior to performing this critical step.**

## Trivia

- On reset, Mesen 2 sets the SPC700's program counter to $FFC5, skipping the stack setup.

## See Also

- SPC700/Driver Upload

## References

- [Fullsnes - Boot ROM Disassembly](https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport)
- [Anomie's boot rom disassembly](https://www.romhacking.net/documents/197)
- [Super Famicom Wiki - IPL ROM](https://wiki.superfamicom.org/spc700-reference#ipl-rom-1567)
