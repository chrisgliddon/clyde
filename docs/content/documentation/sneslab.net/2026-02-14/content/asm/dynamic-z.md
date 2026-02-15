---
title: "Dynamic Z"
reference_url: https://sneslab.net/wiki/Dynamic_Z
categories:
  - "ASM"
  - "Super_Mario_World"
downloaded_at: 2026-02-14T11:52:42-08:00
cleaned_at: 2026-02-14T17:51:52-08:00
---

[English]() [Português](/mw/index.php?title=pt%2FDynamic_Z&action=edit&redlink=1 "pt/Dynamic Z (page does not exist)") Español [日本語](/mw/index.php?title=jp%2FDynamic_Z&action=edit&redlink=1 "jp/Dynamic Z (page does not exist)")

**Dynamic Z** is a patch for Super Mario World that allows performing a variety of actions during V-Blank. It was made by anonimzwx. Dynamic Z is meant to be a replacement for [DSX](/mw/index.php?title=DSX&action=edit&redlink=1 "DSX (page does not exist)") as both allow coding dynamic sprites.

## Features

- **Dynamic Sprite Support:** Sprites that uploads their graphics to the VRAM when they need allowing unlimited number of frames.
- **Shared Dynamic Sprite Support:** Dynamic Sprites but each copy of the sprite shares graphics then doesn't have limitation of number.
- **Semi Dynamic Sprite Support:** Regular Sprites that uploads all their graphics to the VRAM when they are spawned on the level, each copy of the sprite use the same space in VRAM.
- **Giant Dynamic Sprite Support:** Very Big Dynamic Sprites. Any that fits in 48 16x16 tiles or less.
- **Graphics Change on the fly:** Can change GFXs in game by code.
- **Tilemap Change on the fly:** Can change Tilemaps of any layer in game by code.
- **Color Palette Change on the fly:** Can change color palettes in game by code.
- **Block Changer:** Allows to change several blocks, this allows to modify terrain of Layer 1 or Layer 2.
- **DMA Mirror:** Includes a Ram Address that mirrors register $420B and can be used to do DMA transfers.
- **SA1's Widescreen:** Makes easier to use the widescreen of SA1 pack, every 6~7 scanlines killed Dynamic Z allows 8 16x16 tiles more to use in Dynamic sprites or Graphics Change. **Only Available if ROM uses SA1**.

## Optional Features

- Player Features: Can change graphics or color palettes of player on the fly, allowing Custom Players, the size is defined by the user but bigger player = less dynamic sprites. Also in vanilla case optimize player routine to save a lot of cycles during NMI. **Not Compatible with resources that change things of the player like 8x8 tiles DMAer or 32x32 player (New version will be compatible with LX5's Custom Power Ups)**.
- 50% More Mode: if it is activate, status bar, podoboos and most of minor DMA, then is possible to send 50% more data by DMA, that means 50% more Dynamic Sprites or graphics changes. **Not compatible with resources that changes things with Status Bar**.

## Dynamic Z vs DSX

DSX Dynamic Z Number of Dynamic Sprites 4 of 32x32, 1 of 64x64 Any number of sprites while it fits on the designed space. By default allows 32 16x16 tiles. Frame Rate 60 FPS 30 or 60 FPS, if you use 30 FPS sprites you can use more dynamic sprites. Performance Requires a buffer to sort the data before transfer it to VRAM wasting a lot of cycles. Send data directly to VRAM and only transfer data when is needed saving a lot of cycles on NMI, It doesn't require a buffer then doesn't waste cycles fitting graphics on the buffer. Sizes 32x32 or 64x64, do others sizes is possible but harder. Any if it fits on the designed space. VRAM Options Only allows to fit Dynamic Sprites on SP4 Second Half User can define where fit Dynamic Sprites, Default address can be changed on the patch, address can be changed in game by code. Shared Dynamic Sprites No Allows Dynamic Sprites that shares graphics on VRAM, Shared Dynamic Sprites doesn't have limitations of number. Semi-Dynamic Sprites No Normal sprites that when are spawned on the stage, they upload all their graphics to VRAM. Giant-Dynamic Sprites No Very Big Dynamic Sprite, (Max Size any that use a space in vram of 48 tiles). Auto-Defragmentation of VRAM No When a Dynamic sprite is spawned, it clears reserved space of unused slots and compress space on VRAM.

## Installation

### Without SA-1

1. Insert Dynamic Z as any other patch.

### With SA-1

1. Open a Clear ROM with Lunar Magic.
2. Expand Rom (if you want to use a lot of Dynamic Sprites i recommend 4mb)
3. Open "sa1.asm" and change this to 0:
   
   ```
   !DSX		= 1				; Put 0 if you want to turn off legacy (Dynamic Sprites) patch support.
   						; (as anoni's Dynamic Z should obsolete it soon.)
   ```
4. Insert SA-1.
5. Insert Dynamic Z as any other Patch.

### Installing Dynamic Z's Library and Defines

#### Pixi

1. Run "Dynamic Z Pixi Installer.exe". This will generate a define file in "./asm/ExtraDefines", that can be used by any other Dynamic Sprite. If you want to do it manually, just copy the file "DynamicZDefines.asm" and put it on "./asm/ExtraDefines".

#### Uber asm patch

**Under Construction**

#### Uber asm Tool

**Under Construction**

#### GPS

**Under Construction**

#### Overworld Sprite Tool

**Under Construction**

### Inserting Dynamic Resources

Dynamic Z includes a tool to insert graphics or tilemaps on the ROM using freedata and allows to resources get them with just a macro. This system is specially useful for resources that uses more than 1 BNK, I recommend use it always for any resource because freecode is better keep them just for code and freedata for graphics and tilemaps.

1. Put graphics or "Dynamic Resources" folder.
2. Open "ResourceList.txt". It will look like this:
   
   ```
   PIXI:
   .Normal
   .Cluster
   .Extended
   OTHER:
   ```
   
   For Normal, Clusters or Extended Sprites, write the name of the sprite on the correct label.
   
   Example:
   
   ```
   PIXI:
   .Normal
   klaptrap
   klump
   piranha plant
   .Cluster
   DKC butterfly
   DKC fish
   .Extended
   OTHER:
   ```
   
   For other resources write the complete path after label OTHER.
   
   Example:
   
   ```
   PIXI:
   .Normal
   klaptrap
   klump
   piranha plant
   .Cluster
   DKC butterfly
   DKC fish
   .Extended
   OTHER:
   ./blocks/block that change GFX when is touched.asm
   ./level/awesome uberasm.asm
   ```
3. Run "DynamicResourceAdder.exe".
4. Insert resources.

## Using Normal Dynamic Sprites with the New System

if the sprite is 60FPS, it must be inserted on lunar magic as any other sprite. if the sprite is 30FPS, The highest 2 bits of Extra Byte 1 requires on of this 3 values.

- 00: Automatically assign if It uploads graphics to vram on even or odd frames.
- 01: It uploads graphics to VRAM only in odd frames.
- 02: It uploads graphics to VRAM only in even frames.

By default use always 00 for this, 01 and 02 are used if you want to do GFX or Tilemap Changes and use Dynamic Sprites without flickering, for that you can do that dynamic sprites use only odd frames and upload GFX or Tilemaps in Even Frames.

## Library

Dynamic Z includes severals routines and macros to help developers. Some of them can be used on any resource and others are exclusive for Dynamic Sprites.

### Global Library

#### Variables

Name Size Default Address Lorom Default Address SA-1 Description DZ.Timer 1 7F0B44 418000 Increase in 1 every frame that Dynamic Z is executed. Used to syncronize 30FPS Dynamic Sprites. DZ.MaxDataPerFrameIn16x16Tiles 1 7F0B45 418001 How many Tiles of 16x16 can be send to VRAM per frame without flickering. DZ.MaxDataPerFrame 2 7F0B46 418002 How many bytes can be send to VRAM per frame without flickering. Is Calculated as DZ.MaxDataPerFrameIn16x16Tiles\*0x80. DZ.PPUMirrors.CGRAMTransferLength 1 7F0D19 4181D6 Number of transfers to CGRAM, Max Value is 0x40. DZ.PPUMirrors.CGRAMTransferSourceBNKLength 128 4181D7 4181D7 First byte is the BNK of Source, Second byte is the amount of data send by each transfer to CGRAM. DZ.PPUMirrors.CGRAMTransferOffset 64 7F0D9A 418257 Address of CGRAM to start to send data. DZ.PPUMirrors.CGRAMTransferSource 128 7F0DDA 418297 Address of table with Colors. DZ.PPUMirrors.VRAMTransferLength 1 7F0E5A 418317 Number of transfer to VRAM, Max Value is 0xFE. DZ.PPUMirrors.VRAMTransferSource 190 7F0E5B 418318 Address of resource send to VRAM. DZ.PPUMirrors.VRAMTransferSourceBNK 190 7F0F19 4183D6 BNK of Address of resource send to VRAM. DZ.PPUMirrors.VRAMTransferSourceLength 190 7F0FD7 418494 Data send by each transfer to VRAM. DZ.PPUMirrors.VRAMTransferOffset 190 7F1095 418552 Address of VRAM to starte to send data.

#### Routines

**UNDER CONSTRUCTION**

#### Macros

**UNDER CONSTRUCTION**

### Dynamic Sprites Library

#### Variables

Name Size Default Address Lorom Default Address SA-1 Description DZ.DSLastSlot 1 7F0B47 418004 Index of the Last Slot. DZ.DSFirstSlot 1 7F0B48 418005 Index of the First Slot. DZ.DSMaxSpace 1 7F0B49 418006 Max space available for Dynamic Sprites in 16x16 Tiles, by Default is 0x30. DZ.DSFindSpaceMethod 1 7F0B4A 418007 If it is 0, It find space starting from VRAMOffset (Top to Bottom), otherwise find space starting from VRAMOffset + Max Space (Bottom to Top). DZ.DSStartingVRAMOffset 2 7F0B4B 418008 Position on VRAM to start to find space for Dynamic Graphics. DZ.DSStartingVRAMOffset8x8Tiles 1 7F0B4D 41800A DSStartingVRAMOffset but in 8x8 tiles. DZ.DSTotalSpaceUsed 1 7F0B4E 41800B Amount of space used by Dynamic Sprites in 8x8 tiles. DZ.DSTotalSpaceUsedOdd 1 7F0B4F 41800C Amount of space used by Dynamic Sprites on Odd frames in 8x8 tiles. DZ.DSTotalSpaceUsedEven 1 7F0B50 41800D Amount of space used by Dynamic Sprites on Even frames in 8x8 tiles. DZ.DSTotalDataSentOdd 1 7F0B51 41800E Amount of Max data send by Dynamic Sprites on Odd frames in 8x8 tiles. DZ.DSTotalDataSentEven 1 7F0B52 41800F Amount of Max data send by Dynamic Sprites on Even frames in 8x8 tiles. DZ.DSCurrentSlotSearcher 1 7F0B53 418010 Used by Find Space Routine to move space used by a dynamic sprite to defragment it. Index of the Slot of sprite to defragment. DZ.DSSlotSearchedOffset 1 7F0B54 418011 Used by Find Space Routine to move space used by a dynamic sprite to defragment it. Space to move the sprite. DZ.DSLocUsedBy 48 7F0B55 418012 Format s tt iiiii. s =&gt; 0 Regular Dynamic Sprite, 1 Shared Dynamic Sprite. tt =&gt; 00 = Normal Sprite, 01 = Cluster Sprite, 10 = Extended Sprite and 11 = OW Sprite. iiiii Slot of the Sprite. DZ.DSLocSpriteNumber 48 7F0B85 418042 Sprite Number. DZ.DSLocSharedUpdated 48 7F0BB5 418072 If it is 0 then Frame of Shared Dynamic Sprite is not used. DZ.DSLocSpaceUsedOffset 48 7F0BE5 4180A2 Offset of Space used by Dynamic Sprite in 16x16 tiles. DZ.DSLocSpaceUsed 48 7F0C15 4180D2 Amount of space reserved by Dynamic Sprite. DZ.DSLocIsValid 48 7F0C45 418102 If it is 0, Dynamic Sprite can't be processed. DZ.DSLocFrameRateMethod 48 7F0C75 418132 if It is 0 can upload graphics in any frame, 1 only can upload graphics on odd frames and 2 only can upload graphics on even graphics. DZ.DSLocFindSpaceOrder 48 7F0CA5 418162 Next Slot, (because dynamic sprites are builded as a Linked List). DZ.DSLocUSNormal 22 7F0CD5 418192 Dynamic Slot used by Normal Sprites. DZ.DSLocUSCluster 20 7F0CEB 4181A8 Dynamic Slot used by Cluster Sprites. DZ.DSLocUSExtended 10 7F0CFF 4181BC Dynamic Slot used by Extended Sprites. DZ.DSLocUSOW 16 7F0D09 4181C6 Dynamic Slot used by OW Sprites.

#### Routines

!ClearSlot Clear slots of Dynamic Sprites that are not used and start VRAM Defragmentation to use less space. It is recommended to use when a Dynamic Sprite dies.

#### Macros

Macro Description Parameters Return FindSpace Check if the VRAM space assigned to the sprite is valid or not, also if is required moves the sprite to other VRAM space to defragment their graphics.

- DSSlotUsed : Must be a DZ.DSLocUS&lt;Sprite Type&gt;,x for example if you use a normal sprite use %FindSpace("DZ.DSLocUSNormal,x").

Carry Set if VRAM space assigned to the sprite is valid. CheckSlot Use !ClearSlot and then find a valid slot and assign it to the sprite, also assign its VRAM space.

- FrameRateMode : 00 Automatically assign if Sprite uploads graphics in odd or even frames, 01 Sprite uploads graphics in odd frames, 02 Sprite uploads graphics in even frames and 03 Sprite can upload graphics in any frame.
- NumberOf16x16Tiles : Number of tiles of 16x16 that the sprite needs to reserve in VRAM.
- SpriteNumber : For Cluster Sprites use !ClusterSpriteNumber, for Extended Sprites use !ExtendedSpriteNumber and for Overworld Sprites use !OWSpriteNumber.
- SpriteTypeAndSlot : it have format stt 00000, s =&gt; 0 Dynamic Sprite and 1 Shared Dynamic Sprite, tt =&gt; 00 Normal Sprite, 01 Cluster Sprite, 10 Extended Sprite and 11 Overworld Sprite.
- SpriteUsedSlot : Must be a DZ.DSLocUS&lt;Sprite Type&gt;,x for example if you use a cluster sprite use "DZ.DSLocUSCluster".

Sprite is deleted if don't find a valid slot. CheckSlotNormalSprite Check Slot but for Normal Sprites, it assumes that ExtraByte is used for FrameRateMode.

- NumberOf16x16Tiles : Number of tiles of 16x16 that the sprite needs to reserve in VRAM.
- SpriteTypeAndSlot : it have format s 0000000, s =&gt; 0 Dynamic Sprite and 1 Shared Dynamic Sprite.

Sprite is deleted if don't find a valid slot. The sprite can be respawned later. GFXTabDef Generates the define !GraphicsTable, used to find GFX inserted with GFX and Tilemap Inserter.

- index : Index of resource in GFX and Tilemap Inserter, it is autogenerated by the tool using the define !ResourceIndex.

None GFXDef Generates a define !GFX&lt;offset&gt; (for example !GFX00) that haves the address of the gfx.

- offset : Is an Hex number of 2 digits, the number represents the index of the GFX, for example if it is the first GFX of the sprite, then is 00, the second is 01, etc.

None DynamicRoutine Fill tables of VRAM DMA Mirrors to uploads graphics.

- VRAMOffset : Index of the first tile of 8x8 where the routine should start to fill space, This can be get with macro GetVramDispDynamicRoutine.
- ResourceAddr : RAM Address of the GFX that you want to use. If you use GFX and Tilemap Inserter, you can use #!GFXAA, where AA is the number of the GFX you want, for example #!GFX00 is the first GFX file used by the sprite.
- ResourceAddr : BNK of the RAM Address of the GFX that you want to use. If you use GFX and Tilemap Inserter, you can use #!GFXAA&gt;&gt;16, where AA is the number of the GFX you want, for example #!GFX00&gt;&gt;16 is the BNK of the first GFX file used by the sprite.
- ResourceOffset : Starting position where the DMA must start to read on the GFX.
- Size : Number of tiles of 8x8 that must send to VRAM.

None CheckEvenOrOdd Is used to syncronize Dynamic routine with Animation routine in 30 FPS Dynamic sprites.

- DSLocUS : Must be a DZ.DSLocUS&lt;Sprite Type&gt; for example if you use a normal sprite use CheckEvenOrOdd(DZ.DSLocUSNormal).

Z flag is 0 if lowest bit of DZ.Timer is equal to FrameRateMode. 1 if lowest bit of DZ.Timer is different to FrameRateMode GetVramDisp Get the tile offset, this is used on the Graphic routine to Remap OAM Tiles to the space used by the Dynamic Sprite

- DSLocUS : Must be a DZ.DSLocUS&lt;Sprite Type&gt; for example if you use a normal sprite use CheckEvenOrOdd(DZ.DSLocUSNormal).

A = Offset GetVramDispDynamicRoutine Similar to GetVramDisp but for Dynamic Routine

- DSLocUS : Must be a DZ.DSLocUS&lt;Sprite Type&gt; for example if you use a normal sprite use CheckEvenOrOdd(DZ.DSLocUSNormal).

A = Offset RemapOamTile Remap OAM Tile to the space used by the Dynamic Sprite on the Graphic Routine

- Tile : The tile that to Remap
- Offset : Ressult get from GetVramDisp macro.

A = Remapped OAM Tile.

## How to create Dynamic Sprites
