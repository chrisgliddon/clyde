---
title: "Super NES Programming/multiplication"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/multiplication
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:18:13-08:00
---

Here is a subroutine multiplying 16-bit A with 8-bit Y, with the lower 16-bit result in A and the top 8-bits result in Y.

```
multiplication:
sep #$20
sta $4202
sty $4303
nop
nop
nop
nop
lda $4216
ldy $4217
xba
sta $4202
nop
nop
tya
clc
adc $4216
ldy $4217
bcc carry_bit
iny
carry_bit:
xba
rep #$20
rts
```

This uses the Mode-7 registers. If you are already using Mode-7 registers, you can use this subroutine instead. This will produce errors if Mode-7 graphics are currently being rendered by the PPU.

```
multiplication:
sep #$20
sta $211b
xba
sta $211b
sty $211c
sty $211c
rep #$20
lda $2134
ldy $2136
rts
```
