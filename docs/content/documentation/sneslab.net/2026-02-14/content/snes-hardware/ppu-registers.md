---
title: "PPU Registers"
reference_url: https://sneslab.net/wiki/PPU_Registers
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T15:54:16-08:00
cleaned_at: 2026-02-14T17:54:26-08:00
---

[English]() [Português](/mw/index.php?title=pt%2FPPU_Registers&action=edit&redlink=1 "pt/PPU Registers (page does not exist)") Español [日本語](/mw/index.php?title=jp%2FPPU_Registers&action=edit&redlink=1 "jp/PPU Registers (page does not exist)")

PPU (also knowing as Picture Processing Unit) is a co-processor of SNES used to send video data to TV. It includes a lot of registers that can be used to do graphic effects.

**Almost all the text of this document was extracted from Anomie's Register Doc "regs.txt"**

## Registers $2100~$21FF

### $2100: Screen Display

- It can be read/written at any time: Yes
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

x---bbbb

x = Force blank on when set. bbbb = Screen brightness, F=max, 0="off".

Note that force blank CAN be disabled mid-scanline. However, this can result in glitched graphics on that scanline, as the internal rendering buffers will not have been updated during force blank. Current theory is that BGs will be glitched for a few tiles (depending on how far in advance the PPU operates), and OBJ will be glitched for the entire scanline. Also, writing this register on the first line of V-Blank (225 or 240, depending on overscan) when force blank is currently active causes the OAM Address Reset to occur.

### $2101: Object Size and Chr Address

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): No
- Read/Write style: Byte

#### Format:

sssnnbbb

sss = Object size:

- 000 = 8x8 and 16x16 sprites
- 001 = 8x8 and 32x32 sprites
- 010 = 8x8 and 64x64 sprites
- 011 = 16x16 and 32x32 sprites
- 100 = 16x16 and 64x64 sprites
- 101 = 32x32 and 64x64 sprites
- 110 = 16x32 and 32x64 sprites ('undocumented')
- 111 = 16x32 and 32x32 sprites ('undocumented')

nn = Name Select

bbb = Name Base Select (Addr&gt;&gt;14)

- See the section "SPRITES" below for details.

### $2102: OAM Address Low Byte

### $2103: OAM Address High Byte and Object Priority

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Low/High

#### Format:

p------b aaaaaaaa

p = Obj Priority activation bit

- When this bit is set, an Obj other than Sprite 0 may be given priority. See the section "SPRITES" below for details.

b aaaaaaaa = OAM address

- This can be thought of in two ways, depending on your conception of OAM. If you consider OAM as a 544-byte table, baaaaaaaa is the word address into that table. If you consider OAM to be a 512-byte table and a 32-byte table, b is the table selector and aaaaaaaa is the word address in the table. See the section "SPRITES" below for details.
- The internal OAM address is invalidated when scanlines are being rendered. This invalidation is deterministic, but we do not know how it is determined. Thus, the last value written to these registers is reloaded into the internal OAM address at the beginning of V-Blank if that occurs outside of a force-blank period. This is known as 'OAM reset'. 'OAM reset' also occurs on certain writes to $2100.
- Writing to either $2102 or $2103 resets the entire internal OAM Address to the values last written to this register. E.g., if you set $104 to this register, write 4 bytes, then write $1 to $2103, the internal OAM address will point to word 4, not word 6.

### $2104: Data for OAM Write

- It can be read/written at any time: No
- It can be read/written during H-Blank: No
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

dddddddd

- Note that OAM writes are done in an odd manner, in particular the low table of OAM is not affected until the high byte of a word is written (however, the high table is affected immediately). Thus, if you set the address, then alternate writes and reads, OAM will never be affected until you reach the high table!
- Similarly, if you set the address to 0, then write 1, 2, read, then write 3, OAM will end up as "01 02 01 03", rather than "01 02 xx 03" as you might expect.
- Technically, this register CAN be written during H-blank (and probably mid-scanline as well). However, due to OAM address invalidation the actual OAM byte written will probably not be what you expect. Note that writing during force-blank will only work as expected if that force-blank was begun during V-Blank, or (probably) if $2102/3 have been reset during that force-blank period.
- See the section "SPRITES" below for details.

### $2105: BG Mode and Character Size

- It can be read/written at any time: No
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

DCBAemmm

A/B/C/D = BG character size for BG1/BG2/BG3/BG4

- If the bit is set, then the BG is made of 16x16 tiles. Otherwise, 8x8 tiles are used. However, note that Modes 5 and 6 always use 16-pixel wide tiles, and Mode 7 always uses 8x8 tiles. See the section "BACKGROUNDS" below for details.

mmm = BG Mode

e = Mode 1 BG3 priority bit

Mode BG Depth 1 BG Depth 2 BG Depth 3 BG Depth 4 OPT Priorities Front -&gt; Back 0 2 2 2 2 no 3:AB 2:ab 1:CD 0:cd 1 4 4 2 2 no 3:AB 2:ab 1:C 0:c / if e set: 3:C 2:AB 1:ab 0:c 2 4 4 yes 3:A 2:B 1:a 0:b 3 8 4 no 3:A 2:B 1:a 0:b 4 8 2 yes 3:A 2:B 1:a 0:b 5 4 2 no 3:A 2:B 1:a 0:b 6 4 yes 3:A 1:a 7 8 no 1:a 7+EXTBG 8 7 no 2:B 1:a 0:b

- "OPT" means "Offset-per-tile mode". For the priorities, numbers mean sprites with that priority. Letters correspond to BGs (A=1, B=2, etc), with upper/lower case indicating tile priority 1/0. See the section "BACKGROUNDS" below for details.

<!--THE END-->

- Mode 7's EXTBG mode allows you to enable BG2, which uses the same tilemap and character data as BG1 but interprets bit 7 of the pixel data as a priority bit. BG2 also has some oddness to do with some of the per-BG registers below. See the Mode 7 section under BACKGROUNDS for details.

### $2106: Screen Pixelization

- It can be read/written at any time: No
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

xxxxDCBA

A/B/C/D = Affect BG1/BG2/BG3/BG4

xxxx = pixel size, 0=1x1, F=16x16

- The mosaic filter goes over the BG and covers each x-by-x square with the upper-left pixel of that square, with the top of the first row of squares on the 'starting scanline'. If this register is set during the frame, the 'starting scanline' is the current scanline, otherwise it is the first visible scanline of the frame. I.e. if even scanlines are completely red and odd scanlines are completely blue, setting the xxxx=1 mid-frame will make the rest of the screen either completely red or completely blue depending on whether you set xxxx on an even or an odd scanline.
- XXX: It seems that writing the same value to this register does not reset the 'starting scanline', but which changes do reset it?
- Note that mosaic is applied after scrolling, but before any clip windows, color windows, or math. So the XxX block can be partially clipped, and it can be mathed as normal with a non-mosaiced BG. But scrolling can't make it partially one color and partially another.
- Modes 5-6 should 'double' the expansion factor to expand half-pixels. This actually makes xxxx=0 have a visible effect, since the even half-pixels (usually on the subscreen) hide the odd half-pixels. The same thing happens vertically with interlace mode.
- Mode 7, of course, is weird. BG1 mosaics about like normal, as long as you remember that the Mode 7 transformations have no effect on the XxX blocks. BG2 uses bit A to control 'vertical mosaic' and bit B to control 'horizontal mosaic', so you could be expanding over 1xX, Xx1, or XxX blocks. This can get really interesting as BG1 still uses bit A as normal, so you could have the BG1 pixels expanded XxX with high-priority BG2 pixels expanded 1xX on top of them.
- See the section "BACKGROUNDS" below for details.

### $2107: BG1 Tilemap Address and Size

### $2108: BG2 Tilemap Address and Size

### $2109: BG3 Tilemap Address and Size

### $210A: BG4 Tilemap Address and Size

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

aaaaaayx

aaaaaa = Tilemap address in VRAM (Addr&gt;&gt;10)

x = Tilemap horizontal mirroring

y = Tilemap veritcal mirroring

- All tilemaps are 32x32 tiles. If x and y are both unset, there is one tilemap at Addr. If x is set, a second tilemap follows the first that should be considered "to the right of" the first. If y is set, a second tilemap follows the first that should be considered "below" the first. If both are set, then a second follows "to the right", then a third "below", and a fourth "below and to the right".
- See the section "BACKGROUNDS" below for more details.

### $210B: BG1&2 Tilemap Character Address

### $210C: BG3&4 Tilemap Character Address

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

bbbbaaaa

aaaa = Base address for BG1/3 (Addr&gt;&gt;13)

bbbb = Base address for BG2/4 (Addr&gt;&gt;13)

- See the section "BACKGROUNDS" below for details.

### $210D: BG1 Horizontal Scroll / Mode 7 BG Horizontal Scroll

### $210E: BG1 Vertical Scroll / Mode 7 BG Vertical Scroll

- It can be read/written at any time: No
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Word

#### Format:

BG1: ------xx xxxxxxxx  
Mode 7: ---mmmmm mmmmmmmm

x = The BG offset, 10 bits.

m = The Mode 7 BG offset, 13 bits two's-complement signed.

- These are actually two registers in one (or would that be "4 registers in 2"?). Anyway, writing $210d will write both BG1HOFS which works exactly like the rest of the BGnxOFS registers below ($210f-$2114), and M7HOFS which works with the M7* registers ($211b-$2120) instead.
- Modes 0-6 use BG1xOFS and ignore M7xOFS, while Mode 7 uses M7xOFS and ignores BG1HOFS. See the appropriate sections below for details, and note the different formulas for BG1HOFS versus M7HOFS.

### $210F: BG2 Horizontal Scroll

### $2110: BG2 Vertical Scroll

### $2111: BG3 Horizontal Scroll

### $2112: BG3 Vertical Scroll

### $2113: BG4 Horizontal Scroll

### $2114: BG4 Vertical Scroll

- It can be read/written at any time: No
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Word

#### Format:

```
------xx xxxxxxxx
```

- Note that these are "write twice" registers, first the low byte is written then the high. Current theory is that writes to the register work like this:

```
BGnHOFS = (Current<<8) | (Prev&~7) | ((Reg>>8)&7);
Prev = Current;
  or
BGnVOFS = (Current<<8) | Prev;
Prev = Current;
```

- Note that there is only one Prev shared by all the BGnxOFS registers. This is NOT shared with the M7* registers (not even M7xOFS and BG1xOFS).

x = The BG offset, at most 10 bits (some modes effectively use as few as 8).

- Note that all BGs wrap if you try to go past their edges. Thus, the maximum offset value in BG Modes 0-6 is 1023, since you have at most 64 tiles (if x/y of BGnSC is set) of 16 pixels each (if the appropriate bit of BGMODE is set).
- Horizontal scrolling scrolls in units of full pixels no matter if we're rendering a 256-pixel wide screen or a 512-half-pixel wide screen. However, vertical scrolling will move in half-line increments if interlace mode is active.
- See the section "BACKGROUNDS" below for details.

### $2115: Video Port Control

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Byte

#### Format:

i---mmii

i = Address increment mode:

- 0 =&gt; increment after writing $2118/reading $2139
- 1 =&gt; increment after writing $2119/reading $213a

```
* Note that a word write stores low first, then high. Thus, if you're storing a word value to $2118/9, you'll probably want to set 1 here.
```

ii = Address increment amount

- 00 = Normal increment by 1
- 01 = Increment by 32
- 10 = Increment by 128
- 11 = Increment by 128

mm = Address remapping

- 00 = No remapping
- 01 = Remap addressing aaaaaaaaBBBccccc =&gt; aaaaaaaacccccBBB
- 10 = Remap addressing aaaaaaaBBBcccccc =&gt; aaaaaaaccccccBBB
- 11 = Remap addressing aaaaaaBBBccccccc =&gt; aaaaaacccccccBBB

<!--THE END-->

- The "remap" modes basically implement address translation. If $2116/7 are set to #$0003, then word address #$0018 will be written instead, and $2116/7 will be incremented to $0004.

### $2116: VRAM Address Low Byte

### $2117: VRAM Address High Byte

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Low/High

#### Format:

aaaaaaaa aaaaaaaa

- This sets the address for $2118/9 and $2139/a. Note that this is a word address, not a byte address!
- See the sections "BACKGROUNDS" and "SPRITES" below for details.

### $2118: VRAM Data Write Low Byte

### $2119: VRAM Data Write High Byte

- It can be read/written at any time: No
- It can be read/written during H-Blank: No
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Low/High

#### Format:

xxxxxxxx xxxxxxxx

- This writes data to VRAM. The writes take effect immediately(?), even if no increment is performed. The address is incremented when one of the two bytes is written; which one depends on the setting of bit 7 of register $2115. Keep in mind the address translation bits of $2115 as well.
- The interaction between these registers and $2139/a is unknown.
- See the sections "BACKGROUNDS" and "SPRITES" below for details.

### $211A: Mode 7 Settings

- It can be read/written at any time: No
- It can be read/written during H-Blank: ???
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Low/High

#### Format:

rc----yx

r = Playing field size: When clear, the playing field is 1024x1024 pixels (so the tilemap completely fills it). When set, the playing field is much larger, and the 'empty space' fill is controlled by bit 6.

c = Empty space fill, when bit 7 is set:

- 0 = Transparent.
- 1 = Fill with character 0. Note that the fill is matrix transformed like all other Mode 7 tiles.

x/y = Horizontal/Veritcal mirroring. If the bit is set, flip the 256x256 pixel 'screen' in that direction.

- See the section "BACKGROUNDS" below for details.

### $211B: Mode 7 Matrix A (also used with $2134/6)

### $211C: Mode 7 Matrix B (also used with $2134/6)

### $211D: Mode 7 Matrix C

### $211E: Mode 7 Matrix D

- It can be read/written at any time: No
- It can be read/written during H-Blank: Yes
- It can be read/written during V-Blank: Yes
- It can be read/written during force-blank: Yes
- Register is writable for an effect: Yes
- Register is readable for a value or effect (i.e. not open bus): Yes
- Read/Write style: Word

#### Format:

aaaaaaaa aaaaaaaa

- Note that these are "write twice" registers, first the low byte is written then the high. Current theory is that writes to the register work like this:

```
Reg = (Current<<8) | Prev;
Prev = Current;
```

- Note that there is only one Prev shared by all these registers. This Prev is NOT shared with the BGnxOFS registers, but it IS shared with the M7xOFS registers.
- These set the matrix parameters for Mode 7. The values are an 8-bit fixed point, i.e. the value should be divided by 256.0 when used in calculations. See below for more explanation.
- The product A\*(B&gt;&gt;8) may be read from registers $2134/6. There is supposedly no important delay. It may not be operative during Mode 7 rendering.
- See the section "BACKGROUNDS" below for details.

### $211F: Mode 7 Center X

### $2120: Mode 7 Center Y

### $2121: CGRAM Address

### $2122: CGRAM Data Write

### $2123: Window Mask Settings for BG1 and BG2

### $2124: Window Mask Settings for BG3 and BG4

### $2125: Window Mask Settings for Objects and Color Window

### $2126: Window 1 Left Position

### $2127: Window 1 Right Position

### $2128: Window 2 Left Position

### $2129: Window 2 Right Position

### $212A: Window Mask Logic for Backgrounds

### $212B: Window Mask Logic for Objects and Color Window

### $212C: Main Screen Designation

### $212D: Subscreen Designation

### $212E: Window Mask Designation for the Main Screen

### $212F: Window Mask Designation for the Subscreen

### $2130: Color Addition Select

### $2131: Color Math Designation

### $2132: Fixed Color Data

### $2133: Screen Mode/Video Select

### $2134: Multiplication Result Low Byte

### $2135: Multiplication Result Middle Byte

### $2136: Multiplication Result High Byte

### $2137: Software Latch for the H/V Counter

### $2138: Data for OAM Read

### $2139: Vram Data Read Low Byte

### $213A: Vram Data Read High Byte

### $213B: CGRAM Data Read

### $213C: Horizontal Scanline Location

### $213D: Vertical Scanline Location

### $213E: PPU Status Flag and Version

### $213F: PPU Status Flag and Version

### $2140: APU I/O Register 0

### $2141: APU I/O Register 1

### $2142: APU I/O Register 2

### $2143: APU I/O Register 3

### $2180: WRAM Data Read/Write

### $2181: WRAM Address Low Byte

### $2182: WRAM Address Middle Byte

### $2183: WRAM Address High Byte

## SPRITES

The SNES has 128 independant sprites. The sprite definitions are stored in Object Attribute Memory, or OAM.

### OAM

OAM consists of 544 bytes, organized into a low table of 512 bytes and a high table of 32 bytes. Both tables are made up of 128 records. OAM is accessed by setting the word address in register $2102, the "table select" in bit 0 of $2103, then writing to $2104 or reading from $2138. Since the high table is only 32 bytes long, only the low 4 bits of $2102 are significant for indexing this table.

The internal OAM address is invalidated during the rendering of a scanline; this invalidation is deterministic, but we do not know how or when the value is determined. Current theory is that it is invalidated more-or-less continuously and has something to do with the current OAM address and possibly which sprites are on the current scanline. The internal OAM address is reloaded from $2102/3 at the beginning of V-Blank, if this occurs outside of a force-blank period. The reload also occurs on a 1-&gt;0 transition of $2100.7.

Each read/write increments the address by one byte (the internal address has 10 bits, with bit 9 selecting the table and bits 0-8 indexing). Reads simply read the current byte. Writes to the low table go into a word-sized buffer, which is written to the appropriate word of OAM when the high byte of the word is written. Thus, if alternating reads and writes occur such that the high byte of the word is always read instead of written, none of the writes will actually affect OAM. If the alternation happens such that the writes always occur to the high byte, not only the high bytes but whatever garbage is left in the low byte will be written as well!

Pictorally: Start OAM filled with all zeros. Write 1, read, read, Write 2, read, write 3 =&gt; OAM is 00 00 01 02 01 03, rather than 01 00 00 02 00 03 as you might expect.

Writes to the high table, on the other hand, work exactly as expected.

The record format for the low table is 4 bytes:

- byte OBJ\*4+0: xxxxxxxx
- byte OBJ\*4+1: yyyyyyyy
- byte OBJ\*4+2: cccccccc
- byte OBJ\*4+3: vhoopppN

The record format for the high table is 2 bits:

- bit 0/2/4/6 of byte OBJ/4: X
- bit 1/3/5/7 of byte OBJ/4: s

The values are:

- Xxxxxxxxx = X position of the sprite. Basically, consider this signed but see below.
- yyyyyyyy = Y position of the sprite. Values 0-239 are on-screen. -63 through -1 are "off the top", so the bottom part of the sprite comes in at the top of the screen. Note that this implies a really big sprite can go off the bottom and come back in the top.
- cccccccc = First tile of the sprite. See below for the calculation of the VRAM address. Note that this could also be considered as 'rrrrcccc' specifying the row and column of the tile in the 16x16 character table.
- N = Name table of the sprite. See below for the calculation of the VRAM address.
- ppp = Palette of the sprite. The first palette index is 128+ppp\*16.
- oo = Sprite priority. See below for details.
- h/v = Horizontal/Veritcal flip flags. Note this flips the whole sprite, not just the individual tiles. However, the rectangular sprites are flipped vertically as if they were two square sprites (i.e. rows "01234567" flip to "32107654", not "76543210").
- s = Sprite size flag. See below for details.

The sprite size is controlled by bits 5-7 of $2101, and the Size bit of OAM. $2101 determines the two possible sizes for all sprites. If the OAM Size flag is 0, the sprite uses the smaller size, otherwise it uses the larger size.
