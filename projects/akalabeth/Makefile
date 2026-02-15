# Akalabeth: World of Doom — SNES port
# Assembler: ca65 | Linker: ld65 (cc65 suite)

ROM      = build/akalabeth.smc
CFG      = config/lorom128k.cfg
LIBDIR   = ../../lib

# Source files (order matters for linking)
SRC      = src/main.s src/overworld.s src/dungeon.s src/combat.s src/ui.s src/gfx.s src/save.s src/audio.s src/audio_data.s
LIBSRC   = $(LIBDIR)/init.s $(LIBDIR)/joypad.s $(LIBDIR)/nmi.s $(LIBDIR)/spc.s $(LIBDIR)/sprites.s

# Object files
OBJ      = $(SRC:.s=.o) $(patsubst $(LIBDIR)/%.s,build/lib_%.o,$(LIBSRC))

CA65     = ca65
LD65     = ld65
CA65FLAGS = --cpu 65816 -I $(LIBDIR)

# Mesen2 test runner
MESEN    = /Applications/Mesen.app/Contents/MacOS/Mesen
TESTS    = tests/test_chargen.lua tests/test_overworld.lua tests/test_dungeon.lua tests/test_shop_buy.lua

.PHONY: all clean test

all: $(ROM)

$(ROM): $(OBJ) $(CFG) | build
	$(LD65) -C $(CFG) -o $@ -Ln build/akalabeth.sym --dbgfile build/akalabeth.dbg $(OBJ)

test: $(ROM)
	@for t in $(TESTS); do \
		echo "Running $$t..."; \
		$(MESEN) --testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true $(ROM) $$t || exit 1; \
	done
	@echo "All tests passed."

# Assemble project sources
src/%.o: src/%.s | build
	$(CA65) $(CA65FLAGS) -o $@ $<

# Assemble shared lib sources
build/lib_%.o: $(LIBDIR)/%.s | build
	$(CA65) $(CA65FLAGS) -o $@ $<

build:
	mkdir -p build

clean:
	rm -rf build src/*.o
