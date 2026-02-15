---
title: "Eyes & Lichty"
reference_url: https://sneslab.net/wiki/Eyes_&_Lichty
categories:
  - "Scene_Slang"
downloaded_at: 2026-02-14T11:58:39-08:00
cleaned_at: 2026-02-14T17:51:54-08:00
---

"**Eyes & Lichty**" is scene slang for the excellent manual "Programming the 65816 Including the 6502, 65C02, and 65802" by David Eyes & Ron Lichty. It may be the best unofficial textbook on SNES programming, due in no small part to the fact that the Ricoh 5A22 is based on the 65c816 and the SPC700 is based on the 6502.

### Addressing Mode

Eyes & Lichty divides the 65c816's various addressing modes into two groups: simple and complex. Simple addressing modes are explained first and require the processor to do little effective address calculation. They are:

#### Simple Addressing Modes

- Immediate
- Absolute
- Direct Page
- Accumulator
- Implied
- Stack
- Direct Page Indirect
- Absolute Long
- Direct Page Indirect Long
- Block Move

see [page 108](https://archive.org/details/0893037893ProgrammingThe65816/page/108)

#### Complex Addressing Modes

- Absolute Indexed by X
- Absolute Indexed by Y
- Direct Page Indexed by X
- Direct Page Indexed by Y
- Direct Page Indirect Indexed by Y
- Direct Page Indexed Indirect by X
- Absolute Indexed Indirect
- Non-zero Direct Page
- Absolute Long Indexed by X
- Direct Page Indirect Long Indexed by Y
- Stack Relative
- Stack Relative Indirect Indexed by Y

see [page 197](https://archive.org/details/0893037893ProgrammingThe65816/page/197)

### Errata

Applicable to the 2015 edition:

- Starting on page 389, several effective address diagrams have the bank byte labeled with too many zeros. Only two hex zero digits should fit in there.
- On page 498, opcode F5 has a "0" superscript on the # of cycles column.
- The stack diagram for RTI has the old status register value on the opposite side of the stack as the diagram for COP
- [page 75](https://archive.org/details/0893037893ProgrammingThe65816/page/75) says the 65c816 has 25 different addressing modes, but the datasheet says there are 24
- [Page 94](https://archive.org/details/0893037893ProgrammingThe65816/page/94) says the 65c816 has three push instructions that do not alter registers: PEA, PEI, and PER. But the stack pointer itself is modified. Even not counting that, there are more than three, for example PHA.
- PLB is not the only instruction that modifies the data bank register; MVP and MVN do too - see section 7.18 of the 65c816 datasheet
- In the section on accumulator addressing, a sentence implies that all read-modify-write instructions are unary, but TRB and TSB are not.
- [page 497](https://archive.org/details/0893037893ProgrammingThe65816/page/497) recommends making sure the carry flag is already set, or to set it with SEC prior to doing a SBC to "avoid subtracting the carry flag" but it should say "to avoid subtracting one"
- [Page 510](https://archive.org/details/0893037893ProgrammingThe65816/page/510) on TCD and page 512 on TDC mentions the direct page register, but this is missing from the index
- In the tables that show which MPU supports which instructions, an "X" denotes yes and a " " denotes no. Many readers would find a check mark less confusing.
- The Rockwell 65c02 does not have a direct page, but the four Rockwell instructions are listed as having Direct Page Addressing anyway "for consistency."
- The 65c02 datasheet does mention WAI and STP are supported ([page 532](https://archive.org/details/0893037893ProgrammingThe65816/page/532) has them listed as unavailable)
- The addressing mode for WDM is missing, but the datasheet says it is Implied
- Assemblers are described as requiring the signature byte for COP, but on the next page it says the signature byte is optional
- The page on PLA has a typo that says the 65x pull instructions "set" the zero and negative flags; it should say "affect."
- Table 18.2 seems to imply that the M flag does not exist in emulation mode but the 65c816 datasheet says the M flag is always equal to one in emulation mode in section 2.8.

### Quick Links

- [Table of Contents](https://archive.org/details/0893037893ProgrammingThe65816/page/n7)
- [Preface](https://archive.org/details/0893037893ProgrammingThe65816/page/n13)
- [Acknowledgments](https://archive.org/details/0893037893ProgrammingThe65816/page/n15)
- [Foreword](https://archive.org/details/0893037893ProgrammingThe65816/page/n17)
- [Introduction](https://archive.org/details/0893037893ProgrammingThe65816/page/n19)
- [How to Use this Book](https://archive.org/details/0893037893ProgrammingThe65816/page/n21)

#### [Part I Basics](https://archive.org/details/0893037893ProgrammingThe65816/page/n27)

- [Basic Assembly Language Programming Concepts](https://archive.org/details/0893037893ProgrammingThe65816/page/n29)

#### [Part II Architecture](https://archive.org/details/0893037893ProgrammingThe65816/page/n49)

- [Architecture of the 6502](https://archive.org/details/0893037893ProgrammingThe65816/page/n51)
- [Architecture of the 65C02](https://archive.org/details/0893037893ProgrammingThe65816/page/n71)
- [Sixteen-Bit Architecture: The 65816 and the 65802](https://archive.org/details/0893037893ProgrammingThe65816/page/n75)

#### [Part III Tutorial](https://archive.org/details/0893037893ProgrammingThe65816/page/n99)

- [SEP, REP, and Other Details](https://archive.org/details/0893037893ProgrammingThe65816/page/n101)
- [First Examples: Moving Data](https://archive.org/details/0893037893ProgrammingThe65816/page/n109)
- [The Simple Addressing Modes](https://archive.org/details/0893037893ProgrammingThe65816/page/n133)
- [The Flow of Control](https://archive.org/details/0893037893ProgrammingThe65816/page/n165)
- [Built-In Arithmetic Functions](https://archive.org/details/0893037893ProgrammingThe65816/page/n181)
- [Logic and Bit Manipulation Operations](https://archive.org/details/0893037893ProgrammingThe65816/page/n205)
- [The Complex Addressing Modes](https://archive.org/details/0893037893ProgrammingThe65816/page/n223)
- [The Basic Building Block: The Subroutine](https://archive.org/details/0893037893ProgrammingThe65816/page/n251)
- [Interrupts and System Control Instructions](https://archive.org/details/0893037893ProgrammingThe65816/page/n275)

#### [Part IV Applications](https://archive.org/details/0893037893ProgrammingThe65816/page/n291)

- [Selected Code Samples](https://archive.org/details/0893037893ProgrammingThe65816/page/n293)
- [DEBUG16 - A 65816 Programming Tool](https://archive.org/details/0893037893ProgrammingThe65816/page/n325)
- [Design and Debugging](https://archive.org/details/0893037893ProgrammingThe65816/page/n387)
- [Reference](https://archive.org/details/0893037893ProgrammingThe65816/page/n397)
- [The Addressing Modes](https://archive.org/details/0893037893ProgrammingThe65816/page/n399)
- [The Instruction Sets](https://archive.org/details/0893037893ProgrammingThe65816/page/n447)

<!--THE END-->

- [ADC](https://archive.org/details/0893037893ProgrammingThe65816/page/n449)
- [AND](https://archive.org/details/0893037893ProgrammingThe65816/page/n451)
- [ASL](https://archive.org/details/0893037893ProgrammingThe65816/page/n453)
- [BCC](https://archive.org/details/0893037893ProgrammingThe65816/page/n454)
- [BCS](https://archive.org/details/0893037893ProgrammingThe65816/page/n455)
- [BEQ](https://archive.org/details/0893037893ProgrammingThe65816/page/n456)
- [BIT](https://archive.org/details/0893037893ProgrammingThe65816/page/n457)
- [BMI](https://archive.org/details/0893037893ProgrammingThe65816/page/n458)
- [BNE](https://archive.org/details/0893037893ProgrammingThe65816/page/n459)
- [BPL](https://archive.org/details/0893037893ProgrammingThe65816/page/n460)
- [BRA](https://archive.org/details/0893037893ProgrammingThe65816/page/n461)
- [BRK](https://archive.org/details/0893037893ProgrammingThe65816/page/n462)
- [BRL](https://archive.org/details/0893037893ProgrammingThe65816/page/n463)
- [BVC](https://archive.org/details/0893037893ProgrammingThe65816/page/n465)
- [BVS](https://archive.org/details/0893037893ProgrammingThe65816/page/n466)
- [CLC](https://archive.org/details/0893037893ProgrammingThe65816/page/n467)
- [CLD](https://archive.org/details/0893037893ProgrammingThe65816/page/n468)
- [CLI](https://archive.org/details/0893037893ProgrammingThe65816/page/n469)
- [CLV](https://archive.org/details/0893037893ProgrammingThe65816/page/n470)
- [CMP](https://archive.org/details/0893037893ProgrammingThe65816/page/n471)
- [COP](https://archive.org/details/0893037893ProgrammingThe65816/page/n473)
- [CPX](https://archive.org/details/0893037893ProgrammingThe65816/page/n475)
- [CPY](https://archive.org/details/0893037893ProgrammingThe65816/page/n476)
- [DEC](https://archive.org/details/0893037893ProgrammingThe65816/page/n477)
- [DEX](https://archive.org/details/0893037893ProgrammingThe65816/page/n478)
- [DEY](https://archive.org/details/0893037893ProgrammingThe65816/page/n479)
- [EOR](https://archive.org/details/0893037893ProgrammingThe65816/page/n480)
- [INC](https://archive.org/details/0893037893ProgrammingThe65816/page/n482)
- [INX](https://archive.org/details/0893037893ProgrammingThe65816/page/n483)
- [INY](https://archive.org/details/0893037893ProgrammingThe65816/page/n484)
- [JMP](https://archive.org/details/0893037893ProgrammingThe65816/page/n485)
- [JSL](https://archive.org/details/0893037893ProgrammingThe65816/page/n486)
- [JSR](https://archive.org/details/0893037893ProgrammingThe65816/page/n487)
- [LDA](https://archive.org/details/0893037893ProgrammingThe65816/page/n488)
- [LDX](https://archive.org/details/0893037893ProgrammingThe65816/page/n489)
- [LDY](https://archive.org/details/0893037893ProgrammingThe65816/page/n490)
- [LSR](https://archive.org/details/0893037893ProgrammingThe65816/page/n491)
- [MVN](https://archive.org/details/0893037893ProgrammingThe65816/page/n492)
- [MVP](https://archive.org/details/0893037893ProgrammingThe65816/page/n493)
- [ORA](https://archive.org/details/0893037893ProgrammingThe65816/page/n497)
- [PEA](https://archive.org/details/0893037893ProgrammingThe65816/page/n499)
- [PEI](https://archive.org/details/0893037893ProgrammingThe65816/page/n500)
- [PER](https://archive.org/details/0893037893ProgrammingThe65816/page/n501)
- [PHA](https://archive.org/details/0893037893ProgrammingThe65816/page/n502)
- [PHB](https://archive.org/details/0893037893ProgrammingThe65816/page/n503)
- [PHD](https://archive.org/details/0893037893ProgrammingThe65816/page/n504)
- [PHK](https://archive.org/details/0893037893ProgrammingThe65816/page/n505)
- [PHP](https://archive.org/details/0893037893ProgrammingThe65816/page/n506)
- [PHX](https://archive.org/details/0893037893ProgrammingThe65816/page/n507)
- [PHY](https://archive.org/details/0893037893ProgrammingThe65816/page/n508)
- [PLA](https://archive.org/details/0893037893ProgrammingThe65816/page/n509)
- [PLB](https://archive.org/details/0893037893ProgrammingThe65816/page/n510)
- [PLD](https://archive.org/details/0893037893ProgrammingThe65816/page/n511)
- [PLP](https://archive.org/details/0893037893ProgrammingThe65816/page/n512)
- [PLX](https://archive.org/details/0893037893ProgrammingThe65816/page/n513)
- [PLY](https://archive.org/details/0893037893ProgrammingThe65816/page/n514)
- [REP](https://archive.org/details/0893037893ProgrammingThe65816/page/n515)
- [ROL](https://archive.org/details/0893037893ProgrammingThe65816/page/n516)
- [ROR](https://archive.org/details/0893037893ProgrammingThe65816/page/n517)
- [RTI](https://archive.org/details/0893037893ProgrammingThe65816/page/n518)
- [RTL](https://archive.org/details/0893037893ProgrammingThe65816/page/n520)
- [RTS](https://archive.org/details/0893037893ProgrammingThe65816/page/n522)
- [SBC](https://archive.org/details/0893037893ProgrammingThe65816/page/n523)
- [SEC](https://archive.org/details/0893037893ProgrammingThe65816/page/n525)
- [SED](https://archive.org/details/0893037893ProgrammingThe65816/page/n526)
- [SEI](https://archive.org/details/0893037893ProgrammingThe65816/page/n527)
- [SEP](https://archive.org/details/0893037893ProgrammingThe65816/page/n528)
- [STA](https://archive.org/details/0893037893ProgrammingThe65816/page/n529)
- [STP](https://archive.org/details/0893037893ProgrammingThe65816/page/n530)
- [STX](https://archive.org/details/0893037893ProgrammingThe65816/page/n531)
- [STY](https://archive.org/details/0893037893ProgrammingThe65816/page/n532)
- [STZ](https://archive.org/details/0893037893ProgrammingThe65816/page/n533)
- [TAX](https://archive.org/details/0893037893ProgrammingThe65816/page/n534)
- [TAY](https://archive.org/details/0893037893ProgrammingThe65816/page/n535)
- [TCD](https://archive.org/details/0893037893ProgrammingThe65816/page/n536)
- [TCS](https://archive.org/details/0893037893ProgrammingThe65816/page/n537)
- [TDC](https://archive.org/details/0893037893ProgrammingThe65816/page/n538)
- [TRB](https://archive.org/details/0893037893ProgrammingThe65816/page/n539)
- [TSB](https://archive.org/details/0893037893ProgrammingThe65816/page/n540)
- [TSC](https://archive.org/details/0893037893ProgrammingThe65816/page/n541)
- [TSX](https://archive.org/details/0893037893ProgrammingThe65816/page/n542)
- [TXA](https://archive.org/details/0893037893ProgrammingThe65816/page/n543)
- [TXS](https://archive.org/details/0893037893ProgrammingThe65816/page/n544)
- [TXY](https://archive.org/details/0893037893ProgrammingThe65816/page/n545)
- [TYA](https://archive.org/details/0893037893ProgrammingThe65816/page/n546)
- [TYA](https://archive.org/details/0893037893ProgrammingThe65816/page/n547)
- [WAI](https://archive.org/details/0893037893ProgrammingThe65816/page/n548)
- [WDM](https://archive.org/details/0893037893ProgrammingThe65816/page/n549)
- [XBA](https://archive.org/details/0893037893ProgrammingThe65816/page/n550)
- [XCE](https://archive.org/details/0893037893ProgrammingThe65816/page/n551)

<!--THE END-->

- [Instruction Lists](https://archive.org/details/0893037893ProgrammingThe65816/page/n553)
- [Appendices](https://archive.org/details/0893037893ProgrammingThe65816/page/n567)
- [65x Signal Description](https://archive.org/details/0893037893ProgrammingThe65816/page/n569)
- [65x Series Support Chips](https://archive.org/details/0893037893ProgrammingThe65816/page/n577)
- [The Rockwell 65C02](https://archive.org/details/0893037893ProgrammingThe65816/page/n587)
- [BBR](https://archive.org/details/0893037893ProgrammingThe65816/page/n588)
- [BBS](https://archive.org/details/0893037893ProgrammingThe65816/page/n589)
- [RMB](https://archive.org/details/0893037893ProgrammingThe65816/page/n590)
- [SMB](https://archive.org/details/0893037893ProgrammingThe65816/page/n591)
- [Instruction Groups](https://archive.org/details/0893037893ProgrammingThe65816/page/n593)
- [Group I Instructions](https://archive.org/details/0893037893ProgrammingThe65816/page/n594)
- [Group II Instructions](https://archive.org/details/0893037893ProgrammingThe65816/page/n595)
- [W65C816 Data Sheet](https://archive.org/details/0893037893ProgrammingThe65816/page/n599)
- [The ASCII Character Set](https://archive.org/details/0893037893ProgrammingThe65816/page/n621)
- [Index](https://archive.org/details/0893037893ProgrammingThe65816/page/n625)
