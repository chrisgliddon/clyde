---
title: "Stripe image format"
reference_url: https://sneslab.net/wiki/Stripe_image_format
categories:
  - "Video"
downloaded_at: 2026-02-14T16:51:18-08:00
cleaned_at: 2026-02-14T17:55:19-08:00
---

The **Stripe image format** is the format in which, among other things, Layer 3 images are stored.

The image is stored as several horizontal or vertical "stripes" of tiles, each consisting of a four byte header followed by tile data (in YXPCCCTT format). Header format

|Byte 1| |Byte 2| |Byte 3| |Byte 4| EHHHYXyy yyyxxxxx DRLLLLLL llllllll

E = End of data HHH = Data destination (VRAM address, see below) Xxxxxx = X coordinate Yyyyyy = Y coordinate D = Direction (0 = Horizontal, 1 = Vertical) R = RLE (see below) LLLLLLllllllll = Length (amount of bytes to upload - 1)

RLE

If the RLE bit is set, the header is followed by a pair of bytes that gets repeated for a total of Length + 1 bytes. Data destinations

010 Layer 1 011 Layer 2 101 Layer 3
