---
title: "Super NES Programming/Loading SPC700 programs"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Loading_SPC700_programs
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:24-08:00
---

In this tutorial, we will create a ROM that initializes the SPC700 to play a song captured from another SNES game.

# Introduction

To produce a sound on the SNES, the registers of the DSP need to be set to appropriate values. This means that to play a song on the SNES, you need a program for the SPC700 that manipulates the DSP, and you need code for the 65816 that transfers the SPC700 program to the SPC700. Fortunately, there are thousands of programs for the SPC700 freely available online in the form of SPC files, solving half our problem.

# SPC files

SPC files contain the state of the SPC700, typically at the very beginning of a song in an SNES game. By restoring the state in an SPC700 and DSP emulator -- a.k.a. an SPC player -- you can listen to the song without the SNES ROM. We can likewise use SPC files to restore the SPC state inside of the SNES to play the song. You can get SPC files either by capturing them yourself using an SNES ROM and emulator or by downloading one of the thousands online at [SNESMusic.org](http://www.snesmusic.org/v2/).

# Extracting SPC700 state from an SPC file

The SPC700 file contains the SPC hardware state as well as a variety of additional information, such as title, game name, author, capturer, etc. An in-depth description of the format can be found at [SNESMusic.org](http://www.snesmusic.org/files/spc_file_format.txt), but the relevant fields for our purposes are:

*Offset* *Size* *Description* 00025h 2 bytes Program counter (PC) register 00027h 1 byte A register 00028h 1 byte X register 00029h 1 byte Y register 0002ah 1 byte Program status word (PSW) register 0002bh 1 byte Stack pointer (SP) register 00100h 10000h bytes 64k RAM 10100h 128 bytes The contents of the 128 DSP registers

We need to get this data from inside an SPC file and put it into our ROM. You *could* write a script to extract this data from the SPC file and turn it into a text file of assembly data directives, and `.include` in your assembly file. However, the `.incbin` directive in the WLA assembler makes this process much simpler, since it allows us to include pieces of binary files directly into our ROM. Here is how we include the above data:

```
; The SPC file from which we read our data.
.define spcFile "test000.spc"

dspData:  .incbin spcFile skip $10100 read $0080
audioPC:  .incbin spcFile skip $00025 read $0002
audioA:   .incbin spcFile skip $00027 read $0001
audioX:   .incbin spcFile skip $00028 read $0001
audioY:   .incbin spcFile skip $00029 read $0001
audioPSW: .incbin spcFile skip $0002a read $0001
audioSP:  .incbin spcFile skip $0002b read $0001
```

Notice that we have not included the SPC RAM data in the data definitions above. Because the SPC RAM data (64k) is larger than the SNES's ROM bank size (32k), we need to break it in half and store it in two banks of its own, separate from the rest of our code and data:

```
; The first half of the saved SPC RAM from the SPC file.
.bank 1
.section "musicData1"
spcMemory1: .incbin spcFile skip $00100 read $8000
.ends

; The second half of the saved SPC RAM from the SPC file.
.bank 2
.section "musicData2"
spcMemory2: .incbin spcFile skip $08100 read $8000
.ends
```

# The Main Program

We use most of the code from the SNES Initialization Tutorial for our main program:

```
Start:
    ; Initialize the SNES.
    Snes_Init

    jsr     LoadSPC

    ; Set the background color to green.
    sep     #$20        ; Set the A register to 8-bit.
    lda     #%10000000  ; Force VBlank and set brightness to 0%.
    sta     $2100
    stz     $2121
    lda     #%11100000  ; Load the low byte of the green background color.
    sta     $2122
    lda     #%00000000  ; Load the high byte of the green background color.
    sta     $2122
    lda     #%00001111  ; End VBlank, setting brightness to 100%.
    sta     $2100

    ; Loop forever.
Forever:
    jmp Forever
```

We have added a line to call a subroutine to load the SPC data, just before the graphics code from the initialization tutorial. The advantage of including this graphics code is that it does something on the screen after the music loads. Thus, when we execute the ROM, it tells us visually either that the music was loaded successfully or that execution halted somewhere in the music code.

# Uploading the SPC700 state

The SNES and the SPC700 communicate via four byte-wide channels, which we will call Audio0, Audio1, Audio2, and Audio3. On the SNES side, these are represented by the memory-mapped registers $2140-$2143, while the SPC represents them as $00f4-$00f7. Although there are four channels, there are actually eight values being stored behind the scenes -- four bytes for the channels from the SNES to the SPC and four bytes for the channels from the SPC to the SNES. For example, when the SNES writes a value to its Audio0, it is saved in one location so the SPC can read it from its Audio0. Likewise, when the SPC writes a value to its Audio0, it is saved in another location so the SNES can read it from its Audio0. Thus the value that is read from a channel's memory-mapped register may not be the value that was last written there.

## The SPC's communication routine

When the SNES is reset, the SPC maps a 64-byte chunk of ROM -- called the "IPL ROM" -- to locations $ffc0-$ffff and executes it. While it's mapped there, reads come from this ROM rather than normal RAM. It performs the necessary initialization of the SPC:

- Set the stack pointer to $01ef.
- Zero memory locations $0000-$00ef.
- Wait for data from the SNES.

The IPL ROM routine is capable of copying blocks of data from the SNES into SPC memory and then starting execution at a given location. You can view the routine by disassembling the IPL ROM bytecode included in the source code of SNES or SPC emulators or in SPC files themselves. Here, however, is a summary of the algorithm the SPC uses:

1. Initialization:
   
   - Set AudioOut0 to $aa and AudioOut1 to $bb.
   - Wait until AudioIn0 is $cc.
2. Prepare to copy a block:
   
   - Read the 16-bit destination address from AudioIn2 (low byte) and AudioIn3 (high byte).
   - Copy AudioIn0 to AudioOut0.
   - If AudioIn1 is zero, start execution at the destination address.
3. Copy a block:
   
   - Wait until AudioIn0 is zero.
   - Set a byte-sized counter to zero.
4. Copy a byte:
   
   - Wait while counter - AudioIn0 is greater than 0
   - If the counter - AudioIn0 equals 0:
     
     - Copy a byte from AudioIn1 to the memory location.
     - Increment the counter and the memory location.
     - Go to Step 4.
   - Otherwise (when the counter - AudioIn0 is less than 0), go to Step 2.

A particularly astute and/or paranoid programmer will observe that when the SPC's byte-sized counter rolls over (increments from $ff to $00), it becomes "less" than the value in AudioIn0. However, counter - AudioIn0 in this case will be $01, greater than 0, and therefore the SPC will know that the block is continuing. The only way to end the block is for AudioIn0 to be greater than the byte-szed counter, which means that we need to increment AudioIn0 by 2 to 127 after the final byte.

## The SNES's communication routine

Now that we have examined the protocol from the SPC's side, we need an SNES routine to interface with it. First, we will examine a routine similar to the one used in open-source demos (and, presumably, actual SNES games). Then, we will make a slight modification to it that simplifies our code.

Here is the general algorithm used in open-source demos:

1. Wait until Audio0 is $aa, signifying that the SPC has completed its initialization.
2. Initialize a byte-wide counter to $cc.
3. If there are no more blocks to send:
   
   - Send the 16-bit execution address to Audio2 and Audio3.
   - Send $00 to Audio1.
   - Send the counter to Audio0.
   - End routine.
4. Otherwise:
   
   - Send the 16-bit destination address to Audio2 and Audio3.
   - Send $01 to Audio1.
   - Send the counter to Audio0.
   - Wait until the counter value is echoed on Audio0.
   - Reset the counter to zero.
5. If there are bytes left in the current block:
   
   - Send the current byte to Audio1.
   - Send the counter to Audio0.
   - Wait until the counter value is echoed on Audio0.
   - Move on to the next byte.
   - Increment the counter.
   - Go to step 5.
6. Otherwise:
   
   - Add $02 to the counter. If the counter is now zero, add $01 to prevent the SPC from starting the transfer too early.
   - Move on to the next block.
   - Go to step 3.

(Note: there's nothing magical about the value $02. We can add almost any value to the counter -- the important thing is that the counter value the SNES sends needs to be greater than the value the SPC expects it to be, which is how the SPC knows the block has ended.)

This routine sends all the blocks at once. It would be nice, however, if we had a routine that just copied one block so that we could do other things between transferring blocks. If we tried to modify the above routine to do this, though, we would either need to know the address of the next block ahead of time or we would need to save the terminating byte of the previous block and send it with the next one. A simple solution to this problem is to send exactly one block, then give the start of the communications routine ($ffc9) as the address at which to begin execution. This resets the protocol state, so that we do not need to store any information between sending blocks.

### The communications routine in assembly

This section describes in detail our assembly routine to copy a block of memory from SNES RAM to SPC RAM.

First, we need to consider the parameters to our routine. We will need to pass the source location, the destination location, and the length of the block to copy. Since there is 64k of SPC RAM, the destination and length will fit in 16-bit variables, so we can pass those in the X and Y registers. The source memory location, on the other hand, is 24 bits long, since we will be reading from the expanded RAM block from $7f:0000-$7f:ffff. Thus, we define a location in the zero page where we can store the three bytes of a pointer to our source data:

```
.define musicSourceAddr $00fd
```

While we are at it, we can define the values of the audio ports and CPU flags, so that our code uses recognizable identifiers instead of hex values:

```
.define AUDIO_R0 $2140
.define AUDIO_R1 $2141
.define AUDIO_R2 $2142
.define AUDIO_R3 $2143

.define XY_8BIT $10
.define A_8BIT  $20
```

While writing the routine, we frequently will be waiting for the SPC to echo back the value we just sent to the Audio0 register. Rather than write this code repeatedly, we can put it in a macro, and the assembler will make the necessary substitutions:

```
.macro waitForAudio0M
-
    cmp     AUDIO_R0
    bne     -
.endm
```

With these initial definitions out of the way, we can write our routine. Here is the initialization phase, which waits until the SPC is ready to accept data, then sends the destination address. Note that we can send the two bytes of the destination address with a single 16-bit write to Audio2.

```
CopyBlockToSPC:
    ; musicSourceAddr - source address
    ; x - dest address
    ; y - count

    ; Wait until audio0 is 0xbbaa
    sep     #A_8BIT
    lda     #$aa
    waitForAudio0M

    ; Send the destination address to AUDIO2.
    stx     AUDIO_R2

    ; Transfer count to x.
    phy
    plx

    ; Send $01cc to AUDIO0 and wait for echo.
    lda     #$01
    sta     AUDIO_R1
    lda     #$cc
    sta     AUDIO_R0
    waitForAudio0M

    ; Zero counter.
    ldy     #$0000
```

Here is the communication routine's main loop, which sends a byte and waits for the SPC's response, then updates the memory and counter values. Note that we can swap the high and low bytes of *a* with the *xba* operation, even though *a* is in 8-bit mode at the time. Again, we use the trick of writing a 16-bit value to send to Audio0 and Audio1 in a single operation.

```
CopyBlockToSPC_loop:
    ; Load the high byte of a with the destination byte.
    xba
    lda     [$fd],y
    xba
    
    ; Load the low byte of a with the counter.
    tya

    ; Send the counter/byte.
    rep     #A_8BIT
    sta     AUDIO_R0
    sep     #A_8BIT

    ; Wait for counter to echo back.
    waitForAudio0M

    ; Update counter and number of bytes left to send.
    iny
    dex
    bne     CopyBlockToSPC_loop
```

Finally, we end the block and tell the SPC to start execution at the beginning of the SPC's communication routine, resetting the protocol:

```
    ; Send the start of IPL ROM send routine as starting address.
    ldx     #$ffc9
    stx     AUDIO_R2
    
    ; Clear high byte.
    xba
    lda     #0
    xba

    ; Add a value greater than one to the counter to terminate.
    clc
    adc     #$2

    ; Send the counter/byte.
    rep     #A_8BIT
    sta     AUDIO_R0
    sep     #A_8BIT

    ; Wait for counter to echo back.
    waitForAudio0M

    rts
```

## Sending the SPC state

The SPC state consists of three parts:

- The memory
- The DSP registers
- The CPU registers

The hardest thing to restore is the CPU state, since it changes just by executing the SPC communications routine. Also, restoring the program counter means that the SPC then will be executing the stored code, not the communications routine, so we can't send anything else after we have restored the program counter. Thus, we need to restore the CPU state last, after we have set up everything else. Whether we restore the memory or DSP registers first doesn't matter too much, but it will turn out to be convenient to restore the memory first.

### Sending memory state

To copy into the ARAM as fast a possible, the data we send needs to be stored in RAM; it can't be directly copied to the SPC from its original location in ROM. Thus, we use the following routine to assemble the two 32k banks of ROM containing the SPC memory state into one 64k segment in SNES RAM:

```
CopySPCMemoryToRam:
    ; Copy music data from ROM to RAM, from the end backwards.
    rep   #$XY_8BIT        ; xy in 16-bit mode.
    ldx.w #$7fff           ; Set counter to 32k-1.
-   lda.l spcMemory1,x     ; Copy byte from first music bank.
    sta.l $7f0000,x
    lda.l spcMemory2,x     ; Copy byte from second music bank.
    sta.l $7f8000,x
    dex
    bpl -
    rts
```

Now, we can use the macro we wrote earlier to transfer the SPC memory state:

```
    ; Copy RAM between 0x0002 and 0xffc0.
    sendMusicBlockM $7f $0002 $0002 $ffbf
```

We do not transfer the first two bytes of memory because they are used by the communications routine: the first two bytes are used during the routine to store the destination address. The last sixty-four bytes contain the routine itself but any write to that part of memory will go to the audio ram behind the communications routine. Most SPCs will not overwrite that part of memory, which mean we can skip that part. It is quite possible that an SPC will use the first two bytes of RAM, since they are in the zero page and easy to access. Therefore, we will set those bytes when we restore the CPU state, taking care not to overwrite them in the SNES RAM until then.

Note that because we are overwriting the block $f0-$ff, we actually write to a number of memory-mapped registers. This has the effect of restoring the timer state, as well as one DSP register. It also manipulates the Audio0-3 ports, but this doesn't interfere with the memory transfer process, probably because the SNES is only listening for a certain value on Audio0.

### Sending DSP state

To set the value of a DSP register, you first need to write its number to address $f2 of the SPC's memory, then you need to write its value to address $f3 of the SPC's memory. Because these addresses are right next to each other, we can restore a DSP register value by using our memory-copying routine to send a block of two bytes to $f2. We repeat this process for each of the 128 DSP registers:

```
InitDSP:
    rep     #XY_8BIT            ; x and y in 16-bit mode
    ldx     #$0000              ; Reset DSP address counter.
-
    sep     #A_8BIT
    txa                         ; Write DSP address register byte.
    sta     $7f0100             
    lda.l   dspData,x           ; Write DSP data register byte.
    sta     $7f0101             
    phx                         ; Save x on the stack.

    ; Send the address and data bytes to the DSP memory-mapped registers.
    sendMusicBlockM $7f $0100 $00f2 $0002

    rep     #XY_8BIT            ; Restore x.
    plx

    ; Loop if we haven't done 128 registers yet.
    inx
    cpx     #$0080
    bne     -
    rts
```

### Sending SPC initialization routine

Our SPC initialization routine restores the parts of the SPC state that would be altered just by running the SPC's communications routine. We will pass the SPC's control to the initialization routine after we are done copying everything, and the routine, as its final step, will jump to the saved program counter location. Here are the things our initialization routine needs to do:

- Restore the first two bytes of RAM.
- Restore the stack pointer (S).
- Push the restored PSW register onto the stack.
- Restore the A register.
- Restore the X register.
- Restore the Y register.
- Pop the PSW register value into its register.
- Jump to the saved program counter location.

We'll write the routine starting at (arbitrary) memory location $7f0000. Since we'll be needing the first two bytes at that location (that we have been careful thus far not to overwrite), we will first save these on the stack. Since we'll restore the first byte first, we push it last:

```
MakeSPCInitCode:
    sep     #A_8BIT

    ; Push [01] value to stack.
    lda.l   $7f0001
    pha

    ; Push [00] value to stack.
    lda.l   $7f0000
    pha
```

Next, we write the code to restore the first byte. Looking up the *mov dp,#imm* opcode in an SPC reference, we see that the opcode byte is $8f, so we write that, followed immediately by the first argument byte (imm -- the value to restore), then the second argument byte (dp -- the address to which to write the byte):

```
    ; Write code to set [00] byte.
    lda     #$8f        ; mov dp,#imm
    sta.l   $7f0000
    pla
    sta.l   $7f0001
    lda     #$00
    sta.l   $7f0002
```

We do the same thing for the second memory byte:

```
    ; Write code to set [01] byte.
    lda     #$8f        ; mov dp,#imm
    sta.l   $7f0003
    pla
    sta.l   $7f0004
    lda     #$01
    sta.l   $7f0005
```

As there is no opcode to write a value to S directly, we first move the stack value into X -- *mov x, #imm* ($cd) -- then we move X into the stack register -- *mov sp, x* ($bd).

```
    ; Write code to set s.
    lda     #$cd        ; mov x,#imm
    sta.l   $7f0006
    lda.l   audioSP
    sta.l   $7f0007
    lda     #$bd        ; mov sp,x
    sta.l   $7f0008
```

Now we write code to push the program status ward (PSW) register value onto the stack, so that we can pop it later. We need to push the value before we restore the other registers because we overwrite X in the process of pushing the value. We can't pop the value until after the other registers are restored, since the *mov* instruction that we use to restore them changes the PSW register.

```
    ; Write code to push psw
    lda     #$cd        ; mov x,#imm
    sta.l   $7f0009
    lda.l   audioPSW
    sta.l   $7f000a
    lda     #$4d        ; push x
    sta.l   $7f000b
```

Here we write the code to restore the registers:

```
    ; Write code to set a.
    lda     #$e8        ; mov a,#imm
    sta.l   $7f000c
    lda.l   audioA
    sta.l   $7f000d

    ; Write code to set x.
    lda     #$cd        ; mov x,#imm
    sta.l   $7f000e
    lda.l   audioX
    sta.l   $7f000f

    ; Write code to set y.
    lda     #$8d        ; mov y,#imm
    sta.l   $7f0010
    lda.l   audioY
    sta.l   $7f0011
```

Writing the code to restore PSW from the stack is fairly straightforward:

```
    ; Write code to pull psw.
    lda     #$8e        ; pop psw
    sta.l   $7f0012
```

Finally, we write the code to send control to the saved program counter position:

```
    ; Write code to jump.
    lda     #$5f        ; jmp labs
    sta.l   $7f0013
    rep     #A_8BIT
    lda.l   audioPC
    sep     #A_8BIT
    sta.l   $7f0014
    xba
    sta.l   $7f0015
    rts
```

After this routine is called, then, the region $7f0000-$7f0015 contains the initialization routine, so sending it using our communications routine is fairly straightforward. We must, however, have somewhere in the SPC RAM to put it. Here, we gamble that the region of memory just before the IPL ROM code is not in use:

```
; The address in SPC RAM where we put our 15-byte startup routine.
.define spcFreeAddr $ffa0
```

Calling the routine:

```
    ; Build code to initialize registers.
    jsr     MakeSPCInitCode

    ; Copy init code to some region of SPC memory that we hope isn't in use.
    sendMusicBlockM $7f $0000 spcFreeAddr $0016
```

# Starting SPC execution

Now that we have restored the memory and DSP state, and we have written an initialization routine to complete restoration, all we need to do is to tell the SPC to begin execution at our initialization routine. We do this by modifying our communications routine to send no blocks, but rather immediately start execution at the given address:

```
StartSPCExec:
    ; Starting address is in x.

    ; Wait until audio0 is 0xbbaa
    sep     #A_8BIT
    lda     #$aa
    waitForAudio0M

    ; Send the destination address to AUDIO2.
    stx     AUDIO_R2

    ; Send $00cc to AUDIO0 and wait for echo.
    lda     #$00
    sta     AUDIO_R1
    lda     #$cc
    sta     AUDIO_R0
    waitForAudio0M

    rts
```

At this point, the SPC should start playing the music originally stored in the SPC file.

# Analysis

This technique is really only good for playing one song on a ROM; after you start playing an SPC file, it is hard to stop it, upload another song, or play a sound effect. This is because the code in the SPC only understands the communications protocol of the game from which it is captured. To discover the protocol, you would have to reverse-engineer the code of either the SPC state or the original SNES ROM, and even then there is no guarantee that the protocol would support whatever you wanted to do. Writing a custom protocol for the audio in a game would be a good subject for a future tutorial.

## Problems

There are a number of reasons why the SPC state, restored in the manner described here, would refuse to play:

- The original SPC program used either the IPL ROM area or the area where we stored our initialization code. If it used the initialization area, we can write the code to another location, and this should allow the SPC to play. Restoring the IPL ROM region is harder because you need a communications routine somewhere else in SPC memory to allow you to do this. In either case, we can't get away from the fact that some space in RAM is needed for initialization and will not match the original RAM.

<!--THE END-->

- The state of the SPC when control is passed to the original code does not exactly match the state when it was captured, since the DSP and timers begin updating their values immediately upon restoration. If the SPC was waiting for some state change, like a timer or DSP value, then it may miss it and lock up.

<!--THE END-->

- It is possible for the SNES to play music entirely by sending values to the SPC in real-time. For instance, it could modify the DSP registers as we did when we were restoring them, except it would modify them over time so as to produce music, much as other SPC code would. In this way, the SPC could produce music with the IPL ROM communications routine as the only code in its memory. Such SPC files would not even play in a player, since they rely on the SNES for information.

# Complete Source Code

```
 ; SNES SPC700 Tutorial code
 ; (originally by Joe Lee)
 ; This code is in the public domain.
 
 .include "Header.inc"
 .include "Snes_Init.asm"
 
 ; These definitions are needed to satisfy some lines in "Snes_Init.asm".
 .define BG1MoveH $7E1A25
 .define BG1MoveV $7E1A26
 .define BG2MoveH $7E1A27
 .define BG2MoveV $7E1A28
 .define BG3MoveH $7E1A29
 .define BG3MoveV $7E1A2A
 
 ; Needed to satisfy interrupt definition in "Header.inc".
 VBlank:
   rti
 
 .define AUDIO_R0 $2140
 .define AUDIO_R1 $2141
 .define AUDIO_R2 $2142
 .define AUDIO_R3 $2143
 
 .define XY_8BIT $10
 .define A_8BIT  $20
 
 .define musicSourceAddr $00fd
 
 ; The SPC file from which we read our data.
 .define spcFile "test000.spc"
 
 ; The address in SPC RAM where we put our 15-byte startup routine.
 .define spcFreeAddr $ffa0
 
 ; The first half of the saved SPC RAM from the SPC file.
 .bank 1
 .section "musicData1"
 spcMemory1: .incbin spcFile skip $00100 read $8000
 .ends
 
 ; The second half of the saved SPC RAM from the SPC file.
 .bank 2
 .section "musicData2"
 spcMemory2: .incbin spcFile skip $08100 read $8000
 .ends
 
 .bank 0
 .section "MainCode"
 
 ; The rest of the saved SPC state from the SPC file.
 dspData:  .incbin spcFile skip $10100 read $0080
 audioPC:  .incbin spcFile skip $00025 read $0002
 audioA:   .incbin spcFile skip $00027 read $0001
 audioX:   .incbin spcFile skip $00028 read $0001
 audioY:   .incbin spcFile skip $00029 read $0001
 audioPSW: .incbin spcFile skip $0002a read $0001
 audioSP:  .incbin spcFile skip $0002b read $0001
 
 Start:
     ; Initialize the SNES.
     Snes_Init
 
     jsr LoadSPC
 
     ; Set the background color to green.
     sep     #$20        ; Set the A register to 8-bit.
     lda     #%10000000  ; Force VBlank and set brightness to 0%.
     sta     $2100
     lda     #%11100000  ; Load the low byte of the green background color.
     sta     $2122
     lda     #%00000000  ; Load the high byte of the green background color.
     sta     $2122
     lda     #%00001111  ; End VBlank, setting brightness to 100%.
     sta     $2100
 
     ; Loop forever.
 Forever:
     jmp Forever
 
 .macro sendMusicBlockM ; srcSeg srcAddr destAddr len
     ; Store the source address \1:\2 in musicSourceAddr.
     sep     #A_8BIT
     lda     #\1
     sta     musicSourceAddr + 2
     rep     #A_8BIT
     lda     #\2
     sta     musicSourceAddr
 
     ; Store the destination address in x.
     ; Store the length in y.
     rep     #XY_8BIT
     ldx     #\3
     ldy     #\4
     jsr     CopyBlockToSPC
 .endm
 
 .macro startSPCExecM ; startAddr
     rep     #XY_8BIT
     ldx     #\1
     jsr     StartSPCExec
 .endm
 
 LoadSPC:
     jsr     CopySPCMemoryToRam
 
     stz     $4200   ; Disable NMI
     sei             ; Disable IRQ
 
     ; Copy RAM between 0x0002 and 0xffc0.
     sendMusicBlockM $7f $0002 $0002 $ffbe
 
     ; Build code to initialize registers.
     jsr     MakeSPCInitCode
 
     ; Copy init code to some region of SPC memory that we hope isn't in use.
     sendMusicBlockM $7f $0000 spcFreeAddr $0016
 
     ; Initialize DSP registers.
     jsr     InitDSP
 
     ; Start SPC execution at init code region.
     startSPCExecM spcFreeAddr
 
     cli             ; Enable IRQ
     sep     #A_8BIT ; Enable NMI
     lda     #$80
     sta     $4200
 
     rts
 
 CopySPCMemoryToRam:
     ; Copy music data from ROM to RAM, from the end backwards.
     rep   #XY_8BIT        ; xy in 16-bit mode.
     ldx.w #$7fff           ; Set counter to 32k-1.
 -   lda.l spcMemory1,x     ; Copy byte from first music bank.
     sta.l $7f0000,x
     lda.l spcMemory2,x     ; Copy byte from second music bank.
     sta.l $7f8000,x
     dex
     bpl -
     rts
 
 InitDSP:
     rep     #XY_8BIT            ; x and y in 16-bit mode
     ldx     #$0000              ; Reset DSP address counter.
 -
     sep     #A_8BIT
     txa                         ; Write DSP address register byte.
     sta     $7f0100             
     lda.l   dspData,x           ; Write DSP data register byte.
     sta     $7f0101             
     phx                         ; Save x on the stack.
 
     ; Send the address and data bytes to the DSP memory-mapped registers.
     sendMusicBlockM $7f $0100 $00f2 $0002
 
     rep     #XY_8BIT            ; Restore x.
     plx
 
     ; Loop if we haven't done 128 registers yet.
     inx
     cpx     #$0080
     bne     -
     rts
 
 MakeSPCInitCode:
     ; Constructs SPC700 code to restore the remaining SPC state and start
     ; execution.
 
     ; The code we want to construct:
     ; Move 00 byte to 00.
     ; Move 01 byte to 01.
     ; Move s value into s.
     ; Push PSW value.
     ; Move a value into a.
     ; Move x value into x.
     ; Move y value into y.
     ; Pull PSW value.
     ; Jump to saved program counter location.
 
     sep     #A_8BIT
 
     ; Push [01] value to stack.
     lda.l   $7f0001
     pha
 
     ; Push [00] value to stack.
     lda.l   $7f0000
     pha
 
     ; Write code to set [00] byte.
     lda     #$8f        ; mov dp,#imm
     sta.l   $7f0000
     pla
     sta.l   $7f0001
     lda     #$00
     sta.l   $7f0002
 
     ; Write code to set [01] byte.
     lda     #$8f        ; mov dp,#imm
     sta.l   $7f0003
     pla
     sta.l   $7f0004
     lda     #$01
     sta.l   $7f0005
 
     ; Write code to set s.
     lda     #$cd        ; mov x,#imm
     sta.l   $7f0006
     lda.l   audioSP
     sta.l   $7f0007
     lda     #$bd        ; mov sp,x
     sta.l   $7f0008
 
     ; Write code to push psw
     lda     #$cd        ; mov x,#imm
     sta.l   $7f0009
     lda.l   audioPSW
     sta.l   $7f000a
     lda     #$4d        ; push x
     sta.l   $7f000b
 
     ; Write code to set a.
     lda     #$e8        ; mov a,#imm
     sta.l   $7f000c
     lda.l   audioA
     sta.l   $7f000d
 
     ; Write code to set x.
     lda     #$cd        ; mov x,#imm
     sta.l   $7f000e
     lda.l   audioX
     sta.l   $7f000f
 
     ; Write code to set y.
     lda     #$8d        ; mov y,#imm
     sta.l   $7f0010
     lda.l   audioY
     sta.l   $7f0011
 
     ; Write code to pull psw.
     lda     #$8e        ; pop psw
     sta.l   $7f0012
 
     ; Write code to jump.
     lda     #$5f        ; jmp labs
     sta.l   $7f0013
     rep     #A_8BIT
     lda.l   audioPC
     sep     #A_8BIT
     sta.l   $7f0014
     xba
     sta.l   $7f0015
     rts
 
 .macro waitForAudio0M
 -
     cmp     AUDIO_R0
     bne     -
 .endm
 
 CopyBlockToSPC:
     ; musicSourceAddr - source address
     ; x - dest address
     ; y - count
 
     ; Wait until audio0 is 0xbbaa
     sep     #A_8BIT
     lda     #$aa
     waitForAudio0M
 
     ; Send the destination address to AUDIO2.
     stx     AUDIO_R2
 
     ; Transfer count to x.
     phy
     plx
 
     ; Send $01cc to AUDIO0 and wait for echo.
     lda     #$01
     sta     AUDIO_R1
     lda     #$cc
     sta     AUDIO_R0
     waitForAudio0M
 
     ; Zero counter.
     ldy     #$0000
 
 CopyBlockToSPC_loop:
     ; Load the high byte of a with the destination byte.
     xba
     lda     [musicSourceAddr],y
     xba
     
     ; Load the low byte of a with the counter.
     tya
 
     ; Send the counter/byte.
     rep     #A_8BIT
     sta     AUDIO_R0
     sep     #A_8BIT
 
     ; Wait for counter to echo back.
     waitForAudio0M
 
     ; Update counter and number of bytes left to send.
     iny
     dex
     bne     CopyBlockToSPC_loop
 
     ; Send the start of IPL ROM send routine as starting address.
     ldx     #$ffc9
     stx     AUDIO_R2
     
     ; Clear high byte.
     xba
     lda     #0
     xba
 
     ; Add a value greater than one to the counter to terminate.
     clc
     adc     #$2
 
     ; Send the counter/byte.
     rep     #A_8BIT
     sta     AUDIO_R0
     sep     #A_8BIT
 
     ; Wait for counter to echo back.
     waitForAudio0M
 
     rts
 
 StartSPCExec:
     ; Starting address is in x.
 
     ; Wait until audio0 is 0xbbaa
     sep     #A_8BIT
     lda     #$aa
     waitForAudio0M
 
     ; Send the destination address to AUDIO2.
     stx     AUDIO_R2
 
     ; Send $00cc to AUDIO0 and wait for echo.
     lda     #$00
     sta     AUDIO_R1
     lda     #$cc
     sta     AUDIO_R0
     waitForAudio0M
 
     rts
 
 .ends
```
