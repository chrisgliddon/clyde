---
title: "SMW Resource Memory Map"
reference_url: https://sneslab.net/wiki/SMW_Resource_Memory_Map
categories:
  - "ROM_Maps"
  - "RAM_Maps"
downloaded_at: 2026-02-14T16:26:11-08:00
cleaned_at: 2026-02-14T17:54:00-08:00
---

Organization comes later. Feel free to add major patches here as well.  
Also feel free to suggest a good way to represent SA-1 addresses (if applicable).

## Lunar Magic

Note about SA-1:

For addresses between $7E:0000-$7E:00FF, the SA-1 equivalent is $3000-$30FF (code bank). For addresses between $7E:0200-$7E:1FFF, the SA-1 equivalent is $6200-$7FFF (code bank) or $40:0200-$40:1FFF (absolute).

Any other address used by Lunar Magic does not have any SA-1 equivalent and must be manipulated by the SNES CPU.

### RAM

Most of these addresses were acquired from Lunar Magic's help file and files floating around the internet.

Address Size LM Version Description $7E:0BF5 1 byte 3.00 ExLevel (Dynamic Levels) flags.

Format: %toPsssss

- o: Overscan level mode. If set, the camera will try scrolling to the maximum vertical level edge (15 extra pixels).
- t: Two layers flag. If set, it means the level has two interactive layers (layer 1+2 or layer 1+3).
- P: New sprite spawn flag. It's a copy of the 5th bit from the sprite header and it's used for checking if the sprites uses the new data structure or not.
- sssss: Vertical level mode. It gets indexed by a table to get the screen height. See Lunar\_Magic/Custom\_Level\_Sizes for more information.

$7E:0BF6 256 bytes 3.00 ExLevel RAM (to be filled later). $7E:13D7 2 bytes 3.00 Screen vertical size. $7E:1936 2 bytes 3.00 Screen vertical size - #$0010. Used only for adjusting smkdan's VRAM patch. $7F:C004 1 byte Unknown Legacy ExAnimations frame counter. Used to be the frame counter for every ExAnimation slot, now it's only accurate for slots 0, 8, 10 and 18. $7F:C060 16 bytes 1.80 Conditional Direct Map16 flags.  
$7F:C070 16 bytes 1.70 Manual ExAnimation triggers.

Each byte corresponds to one manual ExAnimation slot. This block of RAM addresses isn't initialized unless you use the Trigger Init button in the ExAnimation dialog.

$7F:C080 32 bytes Unknown Level ExAnimations frame counter. Each byte corresponds to one slot. $7F:C0A0 32 bytes Unknown Global ExAnimations frame counter. Each byte corresponds to one slot. $7F:C0F8 4 bytes 1.70 One Shot Exanimation triggers.  
$7F:C0FC 2 bytes 1.70 Custom ExAnimation triggers.

Each bit corresponds to each custom ExAnimation slot. If a bit is on it means the trigger is enabled. This block of RAM addresses isn't initialized unless you use the Trigger Init button in the ExAnimation dialog.

$7F:8183 422 bytes 1.70 Used for VRAM modification. See below for details. $7F:8183 2 bytes 1.70 Holds the Layer 1 VRAM tilemap address, similar to $7E:1BE4. Used for VRAM modification. $7F:8185 2 bytes 1.70 Holds the Layer 2 VRAM tilemap address, similar to $7E:1BE4. Used for VRAM modification. $7F:8187 2 bytes 1.70 Holds the Layer 1 VRAM address for column upload. Used for VRAM modification. $7F:8189 2 bytes 1.70 Holds the Layer 2 VRAM address for column upload. Used for VRAM modification. $7F:818B 128 bytes 1.70 Holds the Layer 1 column buffer. Used for VRAM modification. $7F:820B 128 bytes 1.70 Holds the Layer 2 column buffer. Used for VRAM modification. $7F:BC00 1024 bytes 1.70 Map16 low-byte buffer. Used for VRAM modification. $7F:C00B 2 bytes? Unknown Unknown purpose. Used in $0E:FD00 to perform a bit 2 check.  
$7F:C300 1024 bytes 1.70 Map16 high-byte buffer. Used for VRAM modification.

### ROM/Routines

SNES Address Description $03BCE0 Routine to implement the bytes 4/5/6/7 of the secondary entrance data. $05DC80 Getter routines for the latter three secondary exit bytes. Specifically, $05DC80 for byte 3, $05DC85 for byte 4, and $05DC8A for byte 5. Bytes 0-2 are at $0DE190. $05DCD0 Routine used to handle the high bit of level numbers. $05DD00 Routine to transfer the water/slippery flags from $192A to $85/$86 on level load. After execution, the two flags are cleared from $192A. $05DD30 Routine to implement bytes 5/6/7 of the secondary level header. $05DD80 Routine used for setting up the initial overworld level flags. $05DDA0 Table of initial overworld flags for each level ($1EA2). If LM's overworld expansion hijack is applied, it is instead moved to $03BE80, while this block is left unused. $05DE00 Table used for byte 4 of the secondary level header. $06F540 Routine to get the VRAM data for a particular Map16 tile; also used for the overworld's Layer 1 tiles. The tile number should be passed in A, left-shifted 3 times.

Alternative entry points also exist at $06F5D0 (for the tile generation routine at $00BEB0) and at $06F5E4 (for the overworld Layer 1 tiles).

$06F600 Routine to get a Map16 tile's "acts-like" setting. The actual entry point is at $06F608, but note that it is an RTS-ended routine. $06F660 A series of routines used to call various handlers for custom Map16 blocks. Specifically:

$06F660 - MarioBelow, MarioAbove, MarioSide, TopCorner, BodyInside, HeadInside  
$06F700 - SpriteV, SpriteH  
$06F760 - MarioCape  
$06F7A0 - MarioFireball  
(handlers for WallFeet and WallBody are implemented by GPS, at $06F7D0 and $06F7E0 respectively)

$06FC00 Table used for byte 5 of the secondary level header. $06FE00 Table used for byte 6 of the secondary level header. $0DE190 Getter routines for the first three secondary exit bytes. Specifically, $0DE190 for byte 0, $0DE196 for byte 1, and $0DE19D for byte 2. Bytes 3-5 are at $05DC80. $0DE1B0 Implementation of extended object 02, the 5-byte screen exit. $0DE1D0 Implementation of extended object 01, the screen jump. $0DE1E0 Implementation of extended object 03, the vertical screen jump. $0EF100 Bank bytes for each of the level sprite data pointers. $0EF300 Routine to implement the bank bytes (from $0EF100) for the sprite data pointers. $0EF55D Holds a 24-bit pointer to custom overworld sprite data. $FFFFFF if none present. $0EF570 Routine to upload a custom palette from the table at $0EF600. Note: calls $05BE8A upon return. $0EF600 Table of 24-bit pointers to the custom palettes for each level. If a palette is FFFFFF, the ROM contains no custom palettes at all. If 000000, that particular level just does not have a custom palette. $0EFD00 Routine to get a 24-bit pointer to the background Map16 page set. The actual pointers are in a table at $0EFD50, with 0x10 pages per pointer. $0FF0A0 Lunar Magic version string. $0FF600 Table of 24-bit pointers to ExGFX 80-FF. A value of 000000 means not inserted. ExGFX 100-FFF can be found in a table at read3($0FF937). $0FF900 GFX decompression routine.

It can't decompress GFX files 32 or 33.  
On entry:

- A should contain the 16-bit GFX/ExGFX file number you want to decompress.
- $00-$02 should contain the 24-bit address of where to decompress the data to.

On exit:

- Processor bits are preserved.
- Contents of X are preserved.
- Contents of Y are preserved.
- A is not preserved.

## AddMusicK

### RAM

Note: AddMusicK's RAM addresses ($7FB000-$7FB00A) are reset during the SPC Program upload.

Address Size Description $7E1DFA 0x1 Command list.

- $01 - Jump SFX. Sounds glitched due to it overwritting part of arpeggio's RAM with unexpected data. See L\_0A14 for more details.
- $02 - Turns on Yoshi Drums.
- $03 - Turns off Yoshi Drums.
- $04 - Grinder SFX. Potentially glitched.
- $05 - Disables echo effect on SFXs.
- $06 - Enables echo effect on SFXs.
- $07 - Pauses music.
- $08 - Unpauses music.
- $09-$FE - Unused
- $FF - Jumps to L\_099C. It *seems* to prepare the SPC700 to receive data. Disables echo, sets delay to 0, turns off channels, resets the song number (SPC Output 2 = 0). Needs testing.

$7FB000 0x1 Current song playing.  
$7FB001 0x1 Flag used to disable sample upload when switching to a new song.

Reset when a song finishes being uploaded to ARAM.

$7FB002 0x2 Unused. Meant to be:

ARAM/DSP Address.

- To write to ARAM: Set $7FB002 to the address, and $7FB004 to the value to write. Note that the address cannot be $FFxx.
- To write to the S-DSP: Set $7FB002 to the address, $7FB003 to #$FF, and $7FB004 to the value to write.

$7FB004 0x4 SPC Output.

- $F4 $05 will send a 16-bit value containing the current song position.
- $F9 $XX $YY will send $XX and $YY to $7FB004 and $7FB005 respectively. (Needs verification)
- $7FB006 and $7FB007 are unused and most likely have garbage sent by the program.

$7FB008 0x1 Unused. Meant to have the same purpose as $7E0DDA. $7FB009 0x1 Sample count in the current song. $7FB00A 0x400 ARAM SRCN table.

Used as a buffer for the sample pointer/loop table. Could be up to 1024 bytes long, but this is unlikely (4 bytes per sample; do the math).

### ROM/Routines

SNES Address Description $008079 UploadSPCData.

This is an ever-so-slightly modified version of SMW's SPC upload routine. You can jump here at any time to upload data to the SPC.  
Input:

- $00-$02 - Address of the block to upload to ARAM
- $03-$04 - Position in ARAM to jump to upon completion
- $05-$06 - Clobbered. Unused on entry; will be the size of the transferred data when finished.

$008135 UploadSPCDataDynamic. This address needs to be checked.

This is an alternate version of the upload routine. Call this if it is impossible to determine ahead of time where data will go. This routine is used to upload samples by default, but it can upload anything.  
Input:

- $00-$02 - Address of the block to upload to ARAM
- $03-$04 - Position in ARAM to jump to upon completion
- $05-$06 - Size of the data to upload (this address is NOT clobbered).
- $07-$08 - Address in ARAM to upload to (recommended to increment it by ($05) when you finish to upload consecutive data)

## PIXI

### RAM

Address Size Description $000000 0x0 To be edited later.

### ROM/Routines

SNES Address Description $000000 To be edited later.

## GPS

### RAM

Address Size Description $000000 0x0 To be edited later.

### ROM/Routines

SNES Address Description $000000 To be edited later.

## Custom Powerups

### RAM

Address Size Description $7E2000 0x800 RAM with different purposes. Only uses 0x1D4 bytes at the moment.  
$7E2800 0x2000 Reserved as a decompression buffer for the 5th tile GFX.  
$7E4800 0x2000 Reserved as a decompression buffer for dynamic items GFX.  
$7E6800 0x800 Reserved as a copy of the first 2KiB of the latest decompresed GFX file.  
$7E7000 0xCFF Free to use.  
$000000 0x0 To be edited later.

### ROM/Routines

SNES Address Description $000000 To be edited later.

## Dynamic Z

[https://sneslab.net/wiki/Dynamic\_Z#RAM\_Addresses](https://sneslab.net/wiki/Dynamic_Z#RAM_Addresses)
