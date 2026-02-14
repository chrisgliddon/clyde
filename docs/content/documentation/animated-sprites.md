---
title: "Super NES Programming/Animated Sprites"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Animated_Sprites
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:16:32-08:00
---

This article is for slightly more advanced ASM programmers than the rest of this website.

By default, the SNES is limited to 16kB of sprite patterns, which is the same as: 512 8x8 sprites 128 16x16 sprites 32 32x32 sprites 8 64x64 sprites

As you can see, animated sprites can eat away the available memory pretty quickly. This is where DMA comes in. The only problem is DMA isn't all that fast. You only have time to DMA up to 6kB during v-blank, and even less if you take into account scrolling and OAM updating. For the purpose of this article, let's stick to 4kB.

How do we prevent DMAing over 4kB, regardless of what we throw at the screen? We need to make the system know when to stop, and continue the DMA loading into the next frame. How? My solution is to divide the v-ram into 1kB slots. I chose 1kB, because 1kB happens to be a row of 8 16x16 sprites.

```
!apple = "$0000"
!banana = "$0001"
!table = "$0080"
!update_flag = "$0100"
!vram = "$0101"
!source = "$0102"
;================================================================
macro change_vram(source, vram)
php
rep #$20
sep #$10
lda <source>
ldy <vram>
jsr change_slot
plp
endmacro
;================================================================
change_slot:
cmp !table,y
beq redundant_vram_load
sta !table,y
ldx !apple                        ;; apple is just a stupid name I chose for a temporary register
sta !source,x
phy
ldy #$01
phy
pla
sta !update_flag,x
inx #4
stx !apple
redundant_vram_load:
rts
;=============================================================
update_vram_slots:
php
sep #$30
ldx !banana                       ;; banana is just another stupid name I chose
ldy #$04                          ;; to name another temporary register
lda #$80
sta $2115
lda #$01
sta $4300
lda #$18
sta $4301
vram_loop:
lda !update_flag,x
beq finish
stz $2116
lda !vram,x
sta $2117
stz $4302
lda !source,x
sta $4303
lda !source+1,x
sta $4304
stz $4305
lda #$04
sta $4306
lda #$01
sta $420b
lda #$00
sta !update_flag,x
inx #4
dey
bne vram_loop
finish:
stx !banana
sep #$30
lda !apple
sec
sbc !banana
cmp #$10
bcc lag
jmp end_of_game_code
lag:
plp
rts
```

All you have to do is jump to the "update\_vram\_slot" subroutine during vblank, and use the "change\_vram" macro whenever you need to update an animation slot.

For example if you want update slot $0400 in vram from address $98a300 use this macro:

```
%change_vram(#$98a3,#$04)
```

This code isn't limited to just sprite animation, it also can be used for background animation and scrolling.
