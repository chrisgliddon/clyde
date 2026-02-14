---
title: "Introduction"
reference_url: https://ersanio.gitbook.io/assembly-for-the-snes
categories:
  - "Documentation"
downloaded_at: 2026-02-13T20:22:08-08:00
---

This tutorial is an online version of my 65c816 assembly tutorial which is hosted on [SMW Centralarrow-up-right](https://www.smwcentral.net/). I originally wrote this tutorial in order to teach the SMW Central community the 65c816 assembly language in plain English. Nowadays, it's read by various people in the ROM hacking scene in general. Therefore, I decided to open source this tutorial on GitHub, so that people can make improvements or translations.

Although I'm a member of SMW Central, this tutorial is not associated with Super Mario World, thus this tutorial is not tailored towards that game. Instead, this tutorial can be applied in all SNES context.

## [hashtag](#the-language) The language

65c816 assembly is the language used by the Super Nintendo Entertainment System's (SNES) Ricoh 5A22 chip. Breaking down the different parts of the acronym 65c816: 816 means that the processor can be either 8-bit mode or 16-bit mode. The c stands for CMOS, 65 means that this processor is from the 65xx CPU family. The processor is supposed to be pretty revolutionary for its time. This tutorial explains mnemonics/instructions (i.e. opcodes) and how to use them properly. This tutorial does not focus on SNES-specific topics, such as hardware registers.

With 65c816 ASM you can code things for SNES games (such as custom features for Super Mario World). ASM is a 2nd generation programming language, which is low-level compared to C# for example. It is readable machine code, which eventually gets translated into hexadecimal machine code. All the opcodes consist of 3 letters, along with various parameters.

## [hashtag](#special-thanks) Special thanks

Many special thanks go to the following people for reviewing the original tutorial on SMW Central: [**spigmike**arrow-up-right](https://www.smwcentral.net/?p=profile&id=132)**,** [**Roy**arrow-up-right](https://www.smwcentral.net/?p=profile&id=845)**,** [**smkdan**arrow-up-right](https://www.smwcentral.net/?p=profile&id=411)**,** [**S.N.N**arrow-up-right](https://www.smwcentral.net/?p=profile&id=23)**,** [**andy\_k\_250**arrow-up-right](https://www.smwcentral.net/?p=profile&id=67)**,** [**Domiok**arrow-up-right](https://www.smwcentral.net/?p=profile&id=7211)**,** [**reghrhre**arrow-up-right](https://www.smwcentral.net/?p=profile&id=4176)**,** [**ChaoticFox**arrow-up-right](https://www.smwcentral.net/?p=profile&id=3462)**,** [**Tails\_155**arrow-up-right](https://www.smwcentral.net/?p=profile&id=6151)**,** [**GreenHammerBro**arrow-up-right](https://www.smwcentral.net/?p=profile&id=18802)**,** [**Vitor Vilela**arrow-up-right](https://www.smwcentral.net/?p=profile&id=8251)

Many special thanks also go to the [contributorsarrow-up-right](https://github.com/Ersanio/snes-assembly-book/graphs/contributors) of this repository!

[NextGetting started](/assembly-for-the-snes/getting-started)

Last updated 6 years ago
