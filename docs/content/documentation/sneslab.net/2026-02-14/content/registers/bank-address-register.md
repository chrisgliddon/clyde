---
title: "Bank Address Register"
reference_url: https://sneslab.net/wiki/Bank_Address_Register
categories:
  - "Registers"
  - "ASM"
downloaded_at: 2026-02-14T11:09:34-08:00
cleaned_at: 2026-02-14T17:53:58-08:00
---

*Note: this page is likely inaccurate/confusing;*

The **Bank Address Register** (also known as the **bank byte**) is Nintendo's name for the 8-bit register that fills in the most significant bits of a 24-bit address memory access by the 5A22. It keeps track of what bank the CPU is configured to use. It is cleared to zero on reset.\[2]

WDC calls this register the **Data Bank Register** (DBR). Even in emulation mode, DBR still exists and tells the '816 which bank to use.

PLB, MVN, and MVP modify this register. PHB pushes it onto the stack. TSB does not transfer the stack pointer to the DBR despite appearing like a transfer mnemonic.

### See Also

- Program Bank Register
- Address Bus A

### References

1. Figure 2-21-2 on [page 2-21-3 of Book I](https://archive.org/details/SNESDevManual/book1/page/n94) of the official Super Nintendo development manual
2. section 2.5 on page 6 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
3. Eyes & Lichty, [page 53](https://archive.org/details/0893037893ProgrammingThe65816/page/53)
4. lbid, [page 55](https://archive.org/details/0893037893ProgrammingThe65816/page/55)
5. lbid, [page 114](https://archive.org/details/0893037893ProgrammingThe65816/page/114)
