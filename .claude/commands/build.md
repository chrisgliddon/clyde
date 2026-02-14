Build and verify an SNES ROM project.

Project: $ARGUMENTS

Steps:
1. Run `make -C projects/$ARGUMENTS` to build the ROM.
2. If build fails, report the error with file and line number. Suggest fixes based on common ca65/ld65 issues (register width directives, undefined symbols, segment overflow).
3. If build succeeds, verify the output:
   - Check ROM exists: `ls -la projects/$ARGUMENTS/build/*.smc`
   - Check ROM size: should be power of 2 (32KB, 64KB, 128KB, 256KB, etc.)
   - Read ROM header at file offset $7FC0 (LoROM) or $FFC0 (HiROM) to verify title and checksum
4. Report: build status, ROM size, any warnings from assembler or linker.
