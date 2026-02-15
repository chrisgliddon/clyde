Deep-read a reference disassembly to extract patterns for our code.

Query: $ARGUMENTS (format: "<game> <topic>" e.g. "earthbound dma" or "bs-zelda sprites")

Steps:
1. Parse the game name and topic from the query. Map game names to directories:
   - earthbound → references/earthbound/EB/
   - simcity → references/simcity/
   - bs-zelda → references/bs-zelda/
   - smrpg, mario-rpg → references/super-mario-rpg/SMRPG/
   - framework → references/snes-rom-framework/
   - doom → references/doom/
   - ff4, final-fantasy-4 → references/final-fantasy-4/
   - ff5, final-fantasy-5 → references/final-fantasy-5/
   - ff6, final-fantasy-6 → references/final-fantasy-6/
   - gargoyles → references/gargoyles_quest/
   - harvest-moon → references/harvest_moon/
   - akalabeth → references/akalabeth/
   - mesen2 → references/mesen2/
2. Search the relevant source files for the topic:
   - Use grep to find related labels, routines, and data structures
   - Focus on Routine_Macros, RAM_Map, and Misc_Defines files
   - For SPC700 topics, look in SPC700/ subdirectories or audio-related files
3. Read the most relevant sections (limit to ~200 lines per file to stay focused).
4. Extract the pattern:
   - What does it do?
   - How is the data structured?
   - What registers/RAM addresses are involved?
   - How many cycles/bytes does it cost?
5. Suggest how to adapt the pattern for our ca65-based code:
   - Translate asar syntax to ca65 syntax if showing code
   - Note any differences in our memory map (LoROM vs source game's layout)
   - Identify which of our existing macros/routines could be extended
