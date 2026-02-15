---
title: "Bent Line Mode"
reference_url: https://sneslab.net/wiki/Bent_Line_Mode
categories:
  - "Audio"
  - "Official_Jargon"
downloaded_at: 2026-02-14T11:10:45-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

**Bent Line Mode** is one of the increase modes for controlling gain. Figure 3-7-4 of the official Super Nintendo development manual has a graph of the inverted exponential decay function that bent line mode is trying to approximate. \[1] The formula that generates the graph is:

```
1 - ke^(-t)
```

but there is a typo in the manual where the exponent is missing the minus sign.

### See Also

- Table of Gain Modes

### Reference

1. [page 3-7-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n170)
