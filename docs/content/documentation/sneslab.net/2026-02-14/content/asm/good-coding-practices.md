---
title: "Good coding practices"
reference_url: https://sneslab.net/wiki/Good_coding_practices
categories:
  - "ASM"
downloaded_at: 2026-02-14T13:13:06-08:00
cleaned_at: 2026-02-14T17:52:00-08:00
---

This document is an effort to create a coding standard and by consequence a global library that can be used on SNES homebrew and ROM hacking. The objective is creating a standard that lets coders maintain existing code with less difficulty, promote a clean and easy-to-understand code, standardize conventions and promote coding agility for faster results and less time thinking on how to code.

Since there are some SNES assemblers available, our guideline will be focused on Asar. However some of the thoughts can be applied to other assemblers without problem.

**Feel free to edit with your own thoughts**, the idea is mixing everyone opinions until we get into a consensus. Further discussion can be made on the #homebrew channel of the SnesLab Discord: [https://discord.gg/dXzrk5bX](https://discord.gg/dXzrk5bX)

## Code writing thoughts

### Code labels

- code label refers to any beginning of a routine.
- they should be all lowercase and each word should be separated using a underscore. Example: example\_routine
- consider not using more than two underscores to not make it difficulty to read. Not a good example: this\_label\_is\_too\_long

### Opcodes and commands

- mnemonics (the opcode name) should be either all in lowercase (lda #$00) or uppercase (LDA #$00). LDa #$00, Lda #$00 or LdA #$00, etc., is not recommended. The consistency should stay though the entire project.
- commands should all be lowercased: lorom, org, print, etc.
- hexadecimal numbers should be all uppercased for readability, even if the mnemonics or commands are in lowercase. Example: lda #$A0 or org $B0C04F.

### Spacing

- given most editors default preferences, the recommendation is to use 4-space tabulation. The tabulation must be replaced with spaces, for keeping compatibility with editors that has tab size of 8 (Notepad).
- leave a blank line between the last opcode or command and a label.

### Comments

- keep it simple and objective.

## Conventions

- Don't put the whole code on a single ASM file.
- Group .asm files into its own folder when they are related to a specific group of algorithms. For example, a math folder containing sqrt.asm, trig.asm and power.asm and a hdma code containing layer\_wavy.asm, gradient\_wavy.asm and brightness.asm
- There is no specific guidelines how routines should be arranged, but the ordering of them should look like a book story where the reader expects to the code explain itself sequentially. A good example is a SMW sprite, where the init label comes before main label, because it's executed earlier.
- Using the brk handler strongly recommended for catching errors in development. Using different operands can also be used to distinguish different errors.
- Take advantage of assembler conditional statements to add debug code. Having multiple levels of debug flags can also be greatly useful.
- Include a method for adding configuration options to your code.
- When possible it is better to use labels to point at RAM addresses rather than using the address as raw values or defines. This allows addresses to not only be allocated automatically but also allows reorganization to be much easier.
- Using structs to represent data (both ram and rom) should be preferred when it the data is related and has structure to it.

## Memory map and ROM structure

- Make good use of bank 0

The first SNES bank ($00) is special because it can be accessed at Direct Page level, when using a DP value between $8000 and $FFFF. Consider placing useful, intensive use tables. They can be the differential when dealing with time-critical routines such as graphics manipulation or intensively used routines such as trigonometric functions.

- Use the hirom mapper whenever practical

In the context of a homebrew it is almost always better to use the hirom mapper than the lorom mapper. The hirom mapper can be used similar to lorom in many situations, however has strong advantages with large data blocks allowing for contiguous allocations and not requiring special cased bank switching logic to handle wrapping.

## Cycle optimization

- Do not code thinking already on optimization. Get the routine working first.

Comments: Often an algorithm or routine takes several hours to get it working, it requires extensive thoughts and coding thinking already on possible optimizations will make the coding process way slower. It also increases the chances of getting premature bugs, because it makes harder to verify if the algorithm is correct.

- Micro-optimizations are bad, consider only doing them if it's a critical routine of your program.

Comments: An optimization is considered 'micro-optimization' when you start sacrificing the readability in exchange of 1-2 cycle optimization. An example is taking off the CLC because there 50 lines ago there was a BCS opcode that jumps to the of the routine or the previous ADC implies that the operation will never generate carry (for example, a sum that will never exceed #$FF). If you are in an extremely performance critical path (such as NMI) any micro optimizations that you are required to make should be firmly documented after algorithm and code flow options have been exhausted.

- Give a focus on generating efficient algorithms before thinking on any assembly-level optimization.

Comments: Observe if your overall algorithm is effect and fast. Sometimes you can do the same thing much more effectively if done in another way. Observe the trade off between memory and time usage. Sometimes an algorithm that uses more memory will be much faster than an algorithm that uses almost no memory but requires much more iterations. If the algorithm involves iterating a list (for example, a list of active enemies on screen), try making the algorithm only iterate once or twice on the enemy list. It will be much faster than optimizing an algorithm that iterates the enemy list quadratic times.

- Code inlining should only be considered on critical situations.

Comments: Often coders prefer getting rid of the JSR/RTS and inlining all of the code at the once, which sounds logical if the routine is only called once. However the practice is not recommended, given that routines can end-up reused across other resources. Splitting an inline code into routines will also likely make it easier to edit because it will allow to isolate each routine to its own role. A good way to check if inlining will be really benefit is evaluating the cycle cost of using JSR + RTS times the amount of inlining routines times the amount of time the code section is called.

## Bus I/O

Sometimes HDMA or DMA transfers end up not working as expected. This guide proposes a fix for it.

### DMA and HDMA

Known problems (specially over ROM hacking) related to DMA/HDMA:

1. A DMA transfer outside the loading screen fails to happen or corrupts the entire memory. For example, a memory copy while the game is running.
2. HDMA flickers when a V-Blank overflow occurs.
3. HDMA flickers when the screen is vertically scrolled.
4. Several HDMA transfers in sequence or use of extensive indirect HDMA transfers causes some of the transfers not happen or not give any effect at all.

Channel usage recommendation:

- Channel 0: DMA - exclusive for transfers inside interrupts
- Channel 1: DMA - exclusive for transfers outside interrupts
- Channel 2 though 7: HDMA - earlier channels should be dedicated to H-Blanking sensitive PPU transfers and latter channels should be dedicated for registers that doesn't depend on H-blanking at channel such as $2100 and $2140+.

This fixes the first problem mentioned and reduces the probability of the fourth issue from happening by prioritizing H-Blanking sensitive HDMAs.

**Note** about Super Mario World hacking: Lunar Magic enforces channel 2 on all its DMA transfers and most of the ASM hacks focuses on using channel 0. Therefore for compatibility, the recommended DMA remap is: 0 -&gt; outside IRQ/NMI DMA; 1 -&gt; window HDMA (was channel 7); 2 -&gt; inside IRQ/NMI DMA; 3 though 7 -&gt; user HDMA.

HDMA setup recommendation:

- Don't zero $420C at the start of your V-Blanking routine.
- In addition to above, update $420C as soon as your V-Blanking routine starts. Don't do at the end of the V-Blanking routine or you have the risk of your HDMA not being initialized correctly, specially if $420C is cleared at the beginning of the V-Blanking routine.
- Unless if the values remain static, update the HDMA registers ($43xx) during the V-Blanking routine.
