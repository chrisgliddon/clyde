---
title: "Direct Page Register"
reference_url: https://sneslab.net/wiki/Direct_Page_Register
categories:
  - "ASM"
  - "Registers"
  - "65c816_additions"
downloaded_at: 2026-02-14T11:48:46-08:00
cleaned_at: 2026-02-14T17:51:50-08:00
---

The **Direct Page Register** exists on the 65c816 and is 16 bits wide.\[1] It holds current the location of the direct page.

The direct page register is cleared to point to the zero page on reset.\[2]

Its value can be pushed to the stack with PHD and pulled off the stack with PLD.

It can be transferred to and from the full 16 bit accumulator with TCD and TDC.

### References

1. page 5 of the official 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
2. section 2.6 on page 7, lbid.
3. Eyes & Lichty, [page 53](https://archive.org/details/0893037893ProgrammingThe65816/page/53)
