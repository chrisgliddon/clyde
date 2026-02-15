---
title: "Graphics Format"
reference_url: https://sneslab.net/wiki/Graphics_Format
categories:
  - "Video"
downloaded_at: 2026-02-14T13:13:18-08:00
cleaned_at: 2026-02-14T17:55:09-08:00
---

The **SNES** utilizes **indirect color indexing** to have multiple graphics storing formats available in its architecture: 2bpp, 3bpp, 4bpp, 8bpp and Mode 7, with 2 and 4bpp being the most commonly used.

## Primer on Indirect Color Indexing

**Indexed color** is a technique to manage digital images' colors in a limited fashion, in order to save computer memory and file storage, while speeding up display refresh and file transfers.

When an image is encoded in this way, color information is not directly carried by the image pixel data, but is stored in a separate piece of data called a **palette**: an array of color elements. Every element in the array represents a color, indexed by its position within the array. The individual entries are sometimes known as **color registers**. The image pixels do not contain the full specification of its color, but only its index in the *palette*. This technique is sometimes referred as **pseudocolor** or **indirect color**, as colors are addressed indirectly.

## How It Works

Let's take a 1bpp sprite, one of the invaders of *Space Invaders* by Taito, for example.

Using binary, **the pixels index themselves to a palette color**. 0 to white, 1 to black. The picture itself is compressed by turning it to binary which is then converted to hex to store in data (11000 of the tip of the head translating to $18, for one).

However, once 2bpp or higher are introduced, bitplanes come along with them.

For instance, take the sprite of Link in [*The Legend of Zelda*](https://www.zeldadungeon.net/wiki/The_Legend_of_Zelda) for the Nintendo Entertainment System.

As it is 2bpp (literally two bits per pixel), two bitplanes are used to account for the increase in color (as $03 = #04 = %00000011). Essentially, each byte represents a row, and to get the color index, we have to combine the two. 0 and 0 = transparent in the SNES' case, 0 and 1 = green, so on and so forth.

For 3, 4bpp, the conversion is rather obvious. But the most commonly used are 2 and 4bpp. As an aside, **SNES tiles are stored in 8x8**.

## Data Storage

Due to the ability to swap bits-per-pixel formats, the SNES has the ability to use a mix of Planar and Intertwined data storage, using Planar in Mode 7.

- **Planar**: Each row (i.e., byte) of a bitplane is stored consecutively, starting with the top row of the lowest bitplane; then the same is repeated with each row of the next bitplane.
- **Intertwined**: Each pair of bytes consecutively stored represents a row of the sprite with the byte from the lower bitplane being stored first.

In the SNES, the first two planes of an 8x8 tile are always stored first, and once all those are done, the third and fourth get stored.

## Formats

### 2bpp

**Colors Per Tile**: 0-3  
**Space Used**: 2 bits per pixel. 16 bytes per 8x8 tile.

Note: This is a tiled, planar bitmap format. Each pair represents one byte.  
Format:

```
  [r0, bp1], [r0, bp2], [r1, bp1], [r1, bp2], [r2, bp1], [r2, bp2], [r3, bp1], [r3, bp2]
  [r4, bp1], [r4, bp2], [r5, bp1], [r5, bp2], [r6, bp1], [r6, bp2], [r7, bp1], [r7, bp2]
```

Short Description: Bitplanes 1 and 2 are intertwined row by row.

### 3bpp

**Colors Per Tile**: 0-7  
**Space Used**: 3 bits per pixel. 24 bytes for a 8x8 tile.

Note: This is a tiled, planar bitmap format. Each pair represents one byte.  
Format:

```
  [r0, bp1], [r0, bp2], [r1, bp1], [r1, bp2], [r2, bp1], [r2, bp2], [r3, bp1], [r3, bp2]
  [r4, bp1], [r4, bp2], [r5, bp1], [r5, bp2], [r6, bp1], [r6, bp2], [r7, bp1], [r7, bp2]
  [r0, bp3], [r1, bp3], [r2, bp3], [r3, bp3], [r4, bp3], [r5, bp3], [r6, bp3], [r7, bp3]
```

Short Description: Bitplanes 1 and 2 are stored first, intertwined row by row. Then the third bitplane is stored row by row.  
This format isn't used by many games since it's actually a type of compression, because the SNES doesn't natively support the 3BPP format. There is a routine that inserts the fourth bitplane before or while it's being transferred to VRAM so that it can be used by the SNES.

### 4bpp

**Colors Per Tile**: 0-15  
**Space Used**: 4 bits per pixel. 32 bytes for a 8x8 tile.

Note: This is a tiled, planar bitmap format. Each pair represents one byte  
Format:

```
  [r0, bp1], [r0, bp2], [r1, bp1], [r1, bp2], [r2, bp1], [r2, bp2], [r3, bp1], [r3, bp2]
  [r4, bp1], [r4, bp2], [r5, bp1], [r5, bp2], [r6, bp1], [r6, bp2], [r7, bp1], [r7, bp2]
  [r0, bp3], [r0, bp4], [r1, bp3], [r1, bp4], [r2, bp3], [r2, bp4], [r3, bp3], [r3, bp4]
  [r4, bp3], [r4, bp4], [r5, bp3], [r5, bp4], [r6, bp3], [r6, bp4], [r7, bp3], [r7, bp4]
```

Short Description: Bitplanes 1 and 2 are stored first, intertwined row by row. Then bitplanes 3 and 4 are stored, intertwined row by row.

An algorithm to convert from SNES 4bpp Graphics to a indexed color matrix:

```
public static void LoadSNES4bppGFXToIndexedColorMatrix(byte[] src, byte[] dest)
{
    byte b0;
    byte b1;
    byte b2;
    byte b3;
    int res;
    int mul;
    int yAdder = 0;
    int srcIndex;
    int destX;
    int destY;
    int destIndex;
    int mainIndexLimit = src.length/32;
    for (int mainIndex = 0; mainIndex <= mainIndexLimit; mainIndex += 32)
    {
        srcIndex = (mainIndex << 5);
        if (srcIndex + 31 >= src.length)
            return;
        destX = index & 0x0F;
        destY = index >> 4;
        destIndex = ((destY << 7) + destX) << 3;
        if (destIndex + 903 >= dest.length)
            return;
        for (int i = 0; i < 16; i += 2) 
        {
            mul = 1;
            b0 = src[srcIndex + i];
            b1 = src[srcIndex + i + 1];
            b2 = src[srcIndex + i + 16];
            b3 = src[srcIndex + i + 17];
            for (int j = 0; j < 8; j++)
            {
                res = ((b0 & mul) | ((b1 & mul) << 1) | ((b2 & mul) << 2) | ((b3 & mul) << 3)) >> j
                dest[destIndex + (7 - j) + yAdder] = (byte)res;
                mul <<= 1;
            }
            yAdder += 128;
        }
    }
}
```

### 8bpp

**Colors Per Tile**: 0-255  
**Space Used**: 8 bits per pixel. 64 bytes for a 8x8 tile.

Note: This is a tiled, planar bitmap format. Each pair represents one byte  
Format:

```
  [r0, bp1], [r0, bp2], [r1, bp1], [r1, bp2], [r2, bp1], [r2, bp2], [r3, bp1], [r3, bp2]
  [r4, bp1], [r4, bp2], [r5, bp1], [r5, bp2], [r6, bp1], [r6, bp2], [r7, bp1], [r7, bp2]
  [r0, bp3], [r0, bp4], [r1, bp3], [r1, bp4], [r2, bp3], [r2, bp4], [r3, bp3], [r3, bp4]
  [r4, bp3], [r4, bp4], [r5, bp3], [r5, bp4], [r6, bp3], [r6, bp4], [r7, bp3], [r7, bp4]
  [r0, bp5], [r0, bp6], [r1, bp5], [r1, bp6], [r2, bp5], [r2, bp6], [r3, bp5], [r3, bp6]
  [r4, bp5], [r4, bp6], [r5, bp5], [r5, bp6], [r6, bp5], [r6, bp6], [r7, bp5], [r7, bp6]
  [r0, bp7], [r0, bp8], [r1, bp7], [r1, bp8], [r2, bp7], [r2, bp8], [r3, bp7], [r3, bp8]
  [r4, bp7], [r4, bp8], [r5, bp7], [r5, bp8], [r6, bp7], [r6, bp8], [r7, bp7], [r7, bp8]
```

Short Description: Bitplanes 1 and 2 are stored first, intertwined row by row. Bitplanes 3 and 4 are stored next intertwined row by row. Then Bitplanes 5 and 6 intertwined row by row. Finally, Bitplanes 7 and 8 are stored intertwined row by row.

Alternatively and equivalently: In a normal paletted 8x8 image, the bits of pixel data are accessed with byte index yyyxxx and bit index ccc. In SNES 8bpp, the indices are instead ccyyyc xxx.

### Mode 7

**Colors Per Tile**: 0-255  
**Space used**: 8 bits per pixel. 64 bytes for a 8x8 tile.

Note: This is a tiled, linear bitmap format. Each pair represents 1 byte.  
Format:

```
  [p0 r0: bp!], [p1 r0: bp!], [p2 r0: bp!], [p3 r0: bp!]
  [p4 r0: bp!], [p5 r0: bp!], [p6 r0: bp!], [p7 r0: bp!]
  [p0 r1: bp!], [p1 r1: bp!], [p2 r1: bp!], [p3 r1: bp!]
  [p4 r1: bp!], [p5 r1: bp!], [p6 r1: bp!], [p7 r1: bp!]
  ...
  [p0 r7: bp!], [p1 r7: bp!], [p2 r7: bp!], [p3 r7: bp!]
  [p4 r7: bp!], [p5 r7: bp!], [p6 r7: bp!], [p7 r7: bp!]
```

Short Description: Each pixel has its bitplanes stored right after another, so each byte directly references a palette color without needing to "combine" the bitplanes.

## Palette format

The SNES uses a format known as BGR555, rather similar to RGB888. The conversion method is simple, take the five most significant bytes of each color component, and place them backwards (Blue, Green, Red), setting the most significant bit to 0.

This gives the SNES the ability to use any color that fits in that spectrum rather than stick to fixed palettes set by the machine.

## Further Reading

[Super Nintendo Entertainment System Features, by Retro Game Mechanics Explained](https://www.youtube.com/watch?v=57ibhDU2SAI)  
[Klarth's Console GFX Document](https://mrclick.zophar.net/TilEd/download/consolegfx.txt)  
[SNES Assembly Adventure, Lesson 03](https://georgjz.github.io/snesaa03/)
