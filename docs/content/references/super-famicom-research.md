---
title: "Super Famicom Japanese Sources"
description: "Japanese-language resources for SFC/SNES development — tools, dev kits, communities, technical docs"
weight: 9
---

# Super Famicom development through the lens of Japanese sources

**Japanese-language resources for SFC/SNES 65816 development exist but are remarkably sparse compared to English equivalents — scattered across personal blogs, archived wikis, ROM hacking communities, and rare first-hand developer memoirs.** The most significant finding is that no centralized Japanese forum equivalent to nesdev.org or romhacking.net exists for SFC development. Instead, the Japanese SFC homebrew scene lives in fragmented pockets: a handful of dedicated reference sites, a few influential blog posts, doujin circles selling physical cartridges at Comiket, and archived 5ch threads. What these Japanese sources lack in volume, they compensate for with unique perspectives — first-hand accounts from professional-era developers, detailed hardware teardowns, concrete cost data for official dev kits, and insights into the Nintendo–Sony–Intelligent Systems development ecosystem that remain virtually unknown to English-speaking communities.

---

## Japanese-made tools and assembler ecosystems

The Japanese SFC development community has produced several unique tools, though most Japanese hobbyists ultimately rely on Western-origin assemblers with Japanese documentation layered on top.

**a816** is a Japanese-made 65816 assembler with a distinctive syntax using `@` prefixes and `.b/.w/.l` size specifiers (e.g., `lda.b @$2100`). It ships with SFC sample programs but lacks macro support, limiting its usefulness for larger projects. It was discussed on the ミクプラ (MikuPra) programming forum at [dixq.net/forum/viewtopic.php?t=15071](https://dixq.net/forum/viewtopic.php?t=15071) and appears to date from the early 2010s.

**YY-CHR** remains the essential Japanese-made graphics tool for SFC tile and sprite editing, supporting SNES 4BPP alongside NES, Game Boy, Mega Drive, and GBA formats. Originally hosted on Geocities Japan (now defunct), mirrors remain available. **SFCGENEditor**, created by dq_492 of the RetroGameHackers community, is a plugin-based SFC ROM editor with assembler-like capabilities and XML-defined ROM map support, documented at [retrogamehackers.net/sfcgeneditor-doctop/](https://retrogamehackers.net/sfcgeneditor-doctop/). **SNESGT**, a Japanese-made emulator by GIGO and Hii with native Japanese interface and memory map/SPC dump features, served as a development testing tool at [gigo.retrogames.com](http://gigo.retrogames.com/), though it is no longer actively developed.

The dominant workflow among Japanese hobbyists, as documented by the influential blogger gyuque, uses **cc65/ca65** for 65816 main CPU code and **bass** (by byuu) for SPC700 sound code, with **WLA-DX** noted as a superior all-in-one alternative supporting both processors. This toolchain is detailed at [gyuque.hatenablog.com/entry/2016/11/16/214830](https://gyuque.hatenablog.com/entry/2016/11/16/214830). In the ROM hacking community, **xkas** (also by byuu) dominates, with Japanese documentation maintained on the Super Mario World hacking wiki at [w.atwiki.jp/sm4wiki_mix/pages/53.html](https://w.atwiki.jp/sm4wiki_mix/pages/53.html).

---

## The official development kit cost millions of yen

Japanese sources reveal concrete details about the official SFC development ecosystem that are rarely documented in English. The hardware was manufactured by **Intelligent Systems** (インテリジェントシステムズ), an independent company physically co-located near Nintendo's Kyoto headquarters that has built Nintendo dev tools since the original Famicom era.

The **IS-DEBUGGER** and **IS-SOUND** connected to host PCs via SCSI interface. A former developer at [lettuce-h.co.jp/posts/retoro_games_dev2.html](https://www.lettuce-h.co.jp/posts/retoro_games_dev2.html) provides photographs and describes the workflow: commands entered on a DOS-V machine (specifically Fujitsu FMR-designated), with game output displayed on an analog TV. The IS-SOUND unit combined both program debugging and sound development capabilities — it was not solely an audio tool. Manual covers read: *"S-HVC プログラム開発システム S-HVC DEBUGGING ツールソフト SHVC取扱説明書 IS-DEBUGGER、IS-SOUND 共通 Nintendo INTELLIGENT SYSTEMS."*

The cost structure was staggering. SFC development initially **required Sony's NEWS workstation at approximately ¥10,000,000** (~$65,000+ USD at the time) per unit, as documented at [famicoms.net/blog-entry-1003.html](https://famicoms.net/blog-entry-1003.html). The **Ricoh SF-BOX II** development kit cost approximately **¥2,500,000** including licensing fees. BEEP, the famous Akihabara retro shop, documented an SF-BOX II's internals at [beep-shop.com/blog/7721/](https://www.beep-shop.com/blog/7721/), revealing four internal boards, GP-IB (IEEE-488) host interface, RS-232C port, and DIP switches controlling NTSC/PAL output and ROM load modes. Later in the SFC lifecycle, PC-9801-based development kits brought costs down to the ¥2,000,000 range.

Developer Takashi Makimoto's memoir at [note.com/mackie376/n/n38e49b0f802a](https://note.com/mackie376/n/n38e49b0f802a) confirms that **no published reference books existed** for SFC development — developers received only I/O specifications and the 65816 instruction set from Nintendo, working in near-total isolation. The Sony NEWS workstation requirement was likely bundled with the discounted Sony sound chip deal, as detailed through CESA testimonies from SFC hardware designer Masayuki Uemura at [cesa.or.jp/genealogy/uemura/uemura03.html](https://www.cesa.or.jp/genealogy/uemura/uemura03.html).

---

## Where the Japanese community actually lives online

No single Japanese hub for SFC development exists. The community is dispersed across these key locations:

- **SNES研究室 (SNES Lab)** at [tekepen.com/snes/index.html](https://tekepen.com/snes/index.html) — the most comprehensive standalone Japanese SFC development reference, covering 65816 CPU, memory mapping, PPU graphics, SPC700 sound, and downloadable sample code. Also mirrored on Vector at [hp.vector.co.jp/authors/VA042397/snes/](https://hp.vector.co.jp/authors/VA042397/snes/).
- **レトロゲームハッカーズ (Retro Game Hackers)** at [retrogamehackers.net](https://retrogamehackers.net/) — an active Japanese ROM hacking community, particularly strong on Dragon Quest titles, maintaining curated 65816 resources and tools like SFCGENEditor.
- **5ch threads** — scattered across boards rather than consolidated. Key archived threads include the 65816/SNES development thread at [mevius.5ch.net/test/read.cgi/gamedev/1109955393/](https://mevius.5ch.net/test/read.cgi/gamedev/1109955393/) and the スーファミのプログラム thread at [mevius.5ch.net/test/read.cgi/gamedev/1095063252/](https://mevius.5ch.net/test/read.cgi/gamedev/1095063252/), both on the game development board.
- **SnesLab** maintains a Japanese portal at [sneslab.net/wiki/jp/Main_Page](https://sneslab.net/wiki/jp/Main_Page), and the **Super Famicom Development Wiki** at [wiki.superfamicom.org](https://wiki.superfamicom.org/) hosts Japanese-language articles including an extensive SNES reverse engineering introduction.

The **ツクール会** (RPG Maker Gathering) in Aichi Prefecture represents a unique physical community — enthusiasts collect 250+ SFC RPG Maker 2 cartridges, extract saved game data before battery death, and archive user-created SFC RPGs, documented on Nico Nico Douga. For physical distribution, **家電のケンちゃん** ([kadenken.com](https://www.kadenken.com/)) and **BEEP** ([beep-shop.com](https://www.beep-shop.com/)) in Akihabara serve as primary retail channels for SFC homebrew hardware and software. Multiple Japanese blog authors note candidly that detailed SFC programming documentation is primarily available in English, with Japanese resources being scarce.

---

## Japanese technical documentation fills critical gaps

The most ambitious Japanese documentation project is **snes-docs-ja** on GitHub at [github.com/akatsuki105/snes-docs-ja](https://github.com/akatsuki105/snes-docs-ja), a work-in-progress repository systematically documenting SNES hardware in Japanese. It covers CPU registers, all addressing modes, DMA/HDMA with detailed table format examples, PPU layer systems and BG modes 0–7, VRAM data formats, SPC700 I/O registers, and cartridge headers. The author candidly warns: *"このレポジトリは大半が執筆途中です。なので現在、ドキュメントとしての信頼性は皆無です"* (Most of this repository is mid-writing, so currently it has zero reliability as documentation).

The **改造ドンキーの館 (Donkey Hacks Mansion)** provides the most complete instruction set references in Japanese for both processors. The 65C816 reference at [donkeyhacks.zouri.jp/html/Ja-jp/snes/cpu/index.html](https://donkeyhacks.zouri.jp/html/Ja-jp/snes/cpu/index.html) has dedicated pages for every opcode with Japanese descriptions, flag changes, and code examples. Their **SPC700 reference** at [donkeyhacks.zouri.jp/html/En-Us/snes/apu/spc700/](https://donkeyhacks.zouri.jp/html/En-Us/snes/apu/spc700/) (Japanese content despite the URL path) mirrors this completeness for the sound processor, covering all SPC700-specific instructions including bit branch operations and hardware multiply/divide.

For memory mapping, **boldowa's nest** at [boldowa.github.io/snes/2018/06/06/snescartridge](https://boldowa.github.io/snes/2018/06/06/snescartridge) provides visual memory map diagrams covering LoROM, HiROM, ExLoROM, ExHiROM, plus the unique memory mapping peculiarities of SA-1 and Super FX co-processor cartridges. The **えぬえす工房 (NS Workshop)** blog at [ns-koubou.com/blog/2017/04/11/snesapu/](https://www.ns-koubou.com/blog/2017/04/11/snesapu/) offers deep technical details on CPU-to-SPC700 communication protocols via the $2140–$2143 registers, boot sequences, and IPL ROM behavior — including practical hardware interfacing for connecting the SHVC-SOUND module to a PC.

A niche but valuable source is **nkomatsu's W65C816 reference** at [st.rim.or.jp/~nkomatsu/miscproc/W65C816.html](http://www.st.rim.or.jp/~nkomatsu/miscproc/W65C816.html), which discusses instruction nuances like JML vs. JMP disambiguation and how different assemblers handle mnemonic conflicts — details that other references skip. Japanese Wikipedia's 65816 article also contains a practical development insight rarely stated explicitly: **16-bit mode operations consumed more clock cycles, so developers used 8-bit mode whenever possible** to avoid processing lag.

---

## Notable Japanese developers pushing SFC homebrew forward

**PA GAMES** stands as the most prominent active Japanese SFC doujin circle, having produced **ねこたこ (Nekotako)** — a polished action game where a space octopus girl retrieves stolen fish from cats. Debuting at Comiket C97 in December 2019 as a physical SFC cartridge (¥6,600), it features original graphics, a custom **qSPC** sound driver, and professional-quality production. The team comprises 豊井祐太 (graphics), 二宮裕司 (music), and 上山智士 (programming), with cartridge manufacturing by CUBIC STYLE. Still available for purchase at [pagam.es](http://pagam.es/) and through 家電のケンちゃん.

**松原拓也 (Takuya Matsubara)**, known online as nicotakuya, is the most prolific active Japanese SFC developer/writer. He designed open-source SFC cartridge PCBs documented at [sites.google.com/site/yugenkaisyanico/diy-sfc-cartridge](https://sites.google.com/site/yugenkaisyanico/diy-sfc-cartridge), published a 5-part C-language SFC development tutorial series in 2025 using PVSnesLib, collaborated on PA GAMES' Nekotako, and contributes to **日経ソフトウエア (Nikkei Software)** magazine — indicating growing mainstream interest in SFC development. His actively maintained blog is at [nicotakuya.hatenablog.com](https://nicotakuya.hatenablog.com/).

**gyuque** (GitHub) / @pornanime (Twitter) wrote the most influential Japanese-language SFC development blog series, starting with the 2015 post *"スーパーファミコンのプログラムを書きたい"* and culminating in the comprehensive 2016 development environment guide. His demo source code is on GitHub at [github.com/gyuque/SNESZoi](https://github.com/gyuque/SNESZoi). **pgate1** pursued FPGA-based SNES reproduction at [pgate1.at-ninja.jp/SNES_on_FPGA/](https://pgate1.at-ninja.jp/SNES_on_FPGA/), while **Aios Dev.** released the **RAM Cartrish**, an FPGA-based SFC development cartridge board sold in Akihabara for ¥22,800–¥26,980 as covered by [Akiba PC Hotline](https://akiba-pc.watch.impress.co.jp/docs/news/news/1229400.html).

---

## Conclusion

The Japanese SFC development landscape reveals a paradox: the console was born in Japan, yet Japanese-language development resources are significantly sparser than their English counterparts. This gap has deep historical roots — Nintendo's secretive approach meant that even professional developers in the 1990s worked with minimal documentation, and no "Super Famicom Master Bible" was ever published. The ¥10M Sony NEWS workstation requirement created an enormous barrier to entry that persisted until cheaper PC-9801 alternatives emerged late in the console's lifecycle.

Today, the Japanese SFC scene operates through three distinct channels: **technical documentation sites** (SNES研究室, 改造ドンキーの館, snes-docs-ja) that serve as reference material, **ROM hacking communities** (RetroGameHackers, Donkey Hacks) that focus on modification of existing games, and **doujin production circles** (PA GAMES, Aios Dev.) that create original hardware and software distributed through Akihabara specialty shops and Comiket. The most actionable insight for English-speaking developers is that the 改造ドンキーの館 instruction set references for both 65C816 and SPC700, the snes-docs-ja GitHub repository, and the first-hand developer memoirs on note.com and lettuce-h.co.jp contain unique technical knowledge and historical context unavailable anywhere in English.