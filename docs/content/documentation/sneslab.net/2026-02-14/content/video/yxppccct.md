---
title: "YXPPCCCT"
reference_url: https://sneslab.net/wiki/YXPPCCCT
categories:
  - "Video"
  - "Scene_Slang"
downloaded_at: 2026-02-14T17:23:08-08:00
cleaned_at: 2026-02-14T17:55:21-08:00
---

The **YXPPCCCT** format (not to be confused with the YXPCCCTT format) is used for the sprite's OAM tile properties. The information is stored in binary and makes up a single byte. Format:

```
76543210
YXPPCCCT
X  : X flip
Y  : Y flip
PP : Priority 
CCC: Palette 
T  : Bit 8 of tile number
```

The YXPPCCCT bytes are always located at the sprite's OAM address + 3: $0203, $0207, and so on in SMW's case. A shorter way to describe that is n + 3. The functionality of the bits is as follows:

Y (bit 7):

0 = No Y flip (vertical mirroring)

1 = Y flip

X (bit 6):

0 = No X flip (horizontal mirroring)

1 = X flip

PP (bits 4-5):

00 = Appear behind everything except Layer 3 tiles with priority setting 0

01 = Appear behind everything except Layer 3 tiles (unless they have priority setting 1 and the "force above everything" bit is set)

10 = Appear in front of Layer 3 tiles (unless they have priority setting 1 and the "force above everything" bit is set) and Layer 1 and 2 tiles with priority setting 0; appear behind Layer 1 and 2 tiles with priority setting 0 (this is SMW's normal setting for most sprites)

11 = Appear in front of everything, except Layer 3 tiles with priority setting 1 if the "force above everything" bit is set

CCC (bits 1-3):

000 = Palette 8

001 = Palette 9

010 = Palette A

011 = Palette B

100 = Palette C

101 = Palette D

110 = Palette E

111 = Palette F

T (bit 0):

0 = Use the first GFX page

1 = Use the second GFX page
