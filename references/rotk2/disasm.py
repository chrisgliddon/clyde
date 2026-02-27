#!/usr/bin/env python3
"""Romance of the Three Kingdoms II (SNES) — Koei Bytecode Disassembler

Disassembles and decompiles the Koei bytecode VM used in RotK2 SNES.
The game was written in C, compiled to platform-neutral bytecode, and
executed by a native 65816 interpreter.

Usage:
    python3 disasm.py ROM.sfc [overlay|all] [--raw] [--func ADDR] [--xref]

References:
    - AWJ's Koei VM documentation (NESdev forums)
    - ROM verified: "ROMANCE 3 KINGDOMS 2" LoROM 1MB

Opcode map verified by tracing dispatch table at ROM $A0E6 and each
unique handler in the native 65816 interpreter. The SNES version differs
from AWJ's NES documentation in specific opcode assignments.
"""

import struct
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from typing import Optional

# =============================================================================
# ROM / Overlay Structures
# =============================================================================

OVERLAY_TABLE_OFFSET = 0x7800  # File offset of overlay table
OVERLAY_ENTRY_SIZE = 16
MAX_OVERLAYS = 40
FUNC_MARKER = bytes([0x20, 0xE6, 0x23])  # JSR $23E6
FRAME_SIZE_BYTES = 2  # Signed 16-bit frame allocation after JSR $23E6


@dataclass
class Overlay:
    name: str
    bank: int
    src_addr: int
    size: int
    file_offset: int
    data: bytes = b""


@dataclass
class Function:
    addr: int       # WRAM address
    overlay: str
    frame_size: int  # Signed — negative means locals allocated
    bc_start: int   # Offset within overlay data where bytecode begins
    bc_end: int     # Offset where bytecode ends
    n_locals: int = 0

    @property
    def local_bytes(self):
        return -self.frame_size if self.frame_size < 0 else 0


# =============================================================================
# ROM Loader
# =============================================================================

def lorom_file_offset(bank: int, addr: int) -> int:
    return bank * 0x8000 + (addr - 0x8000)


def load_rom(path: str) -> bytes:
    with open(path, "rb") as f:
        rom = f.read()
    title = rom[0x7FC0:0x7FD5].decode("ascii", errors="replace").strip()
    print(f"ROM: {title}  ({len(rom) // 1024}KB)", file=sys.stderr)
    return rom


def load_overlays(rom: bytes) -> list[Overlay]:
    overlays = []
    for i in range(MAX_OVERLAYS):
        off = OVERLAY_TABLE_OFFSET + i * OVERLAY_ENTRY_SIZE
        name_bytes = rom[off:off + 8]
        if name_bytes[0] == 0xFF or name_bytes[0] == 0x00:
            break
        name = name_bytes.rstrip(b"\x00").decode("ascii", errors="replace")
        bank = rom[off + 8]
        src_addr = struct.unpack_from("<H", rom, off + 10)[0]
        size = struct.unpack_from("<H", rom, off + 12)[0]
        file_off = lorom_file_offset(bank, src_addr)
        data = rom[file_off:file_off + size]
        overlays.append(Overlay(name, bank, src_addr, size, file_off, data))
    return overlays


def find_functions(ovl: Overlay, wram_base: int = 0x2000) -> list[Function]:
    funcs = []
    data = ovl.data
    pos = 0
    while True:
        pos = data.find(FUNC_MARKER, pos)
        if pos < 0:
            break
        frame_size = struct.unpack_from("<h", data, pos + 3)[0]
        bc_start = pos + 3 + FRAME_SIZE_BYTES
        wram_addr = wram_base + pos
        n_locals = (-frame_size) if frame_size < 0 else 0
        funcs.append(Function(
            addr=wram_addr, overlay=ovl.name, frame_size=frame_size,
            bc_start=bc_start, bc_end=0, n_locals=n_locals,
        ))
        pos += 1

    for i, fn in enumerate(funcs):
        if i + 1 < len(funcs):
            fn.bc_end = funcs[i + 1].bc_start - 5
        else:
            fn.bc_end = len(data)
    return funcs


def _trim_last_func(funcs: list[Function], data: bytes, wram_base: int):
    """Trim last function at its last decoded RETURN.

    Overlays contain native 65816 code after bytecode. The last function's
    bc_end extends to overlay end by default, so we decode it and trim.
    """
    if not funcs:
        return
    last = funcs[-1]
    dec = Decoder(data, last.bc_start, last.bc_end, wram_base)
    insns = dec.decode_all()
    last_ret_end = last.bc_start
    for ins in insns:
        if ins.mnemonic == "RETURN":
            last_ret_end = ins.addr - wram_base + 1
    if last_ret_end > last.bc_start:
        last.bc_end = last_ret_end


# =============================================================================
# Instruction Set — Verified from dispatch table at ROM $A0E6
# =============================================================================
# Addressing mode routines (ROM addresses):
#   $A089 read_sbyte: read 1 signed byte from bytecode, IP += 1
#   $A09B near_frame: read 1 signed byte + frame pointer → address
#   $A0BC read_word:  read 2 unsigned bytes from bytecode, IP += 2
#   $A0C4 read_abs:   read 2 bytes as absolute address, IP += 2
#   $A0CE far_frame:  read 2 signed bytes + frame pointer → address
#
# Register mapping:
#   $0A-$0B = L (left register, 16-bit)
#   $0E-$0F = R (right register, 16-bit)
#   $04-$05 = Frame pointer
#   $06-$07 = Instruction pointer
#   $08     = IP bank ($7E)
#   Hardware stack = bytecode stack
#
# Opcode table (256 entries):
#
# $00-$0B: LOADL quick local[0..11]  (no operand, 1 byte)
# $0C-$0F: LOADL quick arg[1..4]     (no operand, 1 byte)
# $10-$1B: LOADR quick local[0..11]  (no operand, 1 byte)
# $1C-$1F: LOADR quick arg[1..4]     (no operand, 1 byte)
# $20-$2B: STORE quick local[0..11]  (no operand, 1 byte)
# $2C-$2F: STORE quick arg[1..4]     (no operand, 1 byte)
# $30-$3B: PUSH quick local[0..11]   (no operand, 1 byte)
# $3C-$3F: PUSH quick arg[1..4]      (no operand, 1 byte)
# $40:     LOADL #0                   (no operand, 1 byte)
# $41-$4F: LOADL #(op & 0xF)         (no operand, 1 byte)
# $50:     LOADR #0                   (no operand, 1 byte)
# $51-$5F: LOADR #(op & 0xF)         (no operand, 1 byte)
# $60-$6F: PUSH #(op & 0xF)          (no operand, 1 byte)
# $70:     ADD #0                     (no operand, 1 byte)
# $71-$7F: ADD #(op & 0xF)           (no operand, 1 byte)
# $80:     ILLEGAL
# $81:     LOADL near                 (1B signed frame offset, 2 bytes)
# $82:     LOADL far                  (2B signed frame offset, 3 bytes)
# $83:     LOADR near                 (1B, 2 bytes)
# $84:     LOADR far                  (2B, 3 bytes)
# $85:     STORE near                 (1B, 2 bytes)
# $86:     STORE far                  (2B, 3 bytes)
# $87:     PUSH near                  (1B, 2 bytes)
# $88:     PUSH far                   (2B, 3 bytes)
# $89:     LOADL #imm8               (1B sign-extended, 2 bytes)
# $8A:     LOADL #imm16              (2B, 3 bytes)
# $8B:     LOADR #imm8               (1B, 2 bytes)
# $8C:     LOADR #imm16              (2B, 3 bytes)
# $8D:     PUSH #imm8                (1B, 2 bytes)
# $8E:     PUSH #imm16               (2B, 3 bytes)
# $8F:     ADD #imm8                 (1B, 2 bytes)
# $90:     ADD #imm16                (2B, 3 bytes)
# $91-$9F: ILLEGAL
# $A0:     LOADLB far                (2B frame, 3 bytes)
# $A1:     LOADRB far                (2B frame, 3 bytes)
# $A2:     STOREB far                (2B frame, 3 bytes)
# $A3:     PUSHB far                 (2B frame, 3 bytes)
# $A4:     LOADL abs                 (2B address, 3 bytes)
# $A5:     LOADLB abs                (2B address, 3 bytes)
# $A6:     LOADR abs                 (2B address, 3 bytes)
# $A7:     LOADRB abs                (2B address, 3 bytes)
# $A8:     STORE abs                 (2B address, 3 bytes)
# $A9:     STOREB abs                (2B address, 3 bytes)
# $AA:     PUSH abs                  (2B address, 3 bytes)
# $AB:     PUSHB abs                 (2B address, 3 bytes)
# $AC:     CALL                      (2B target, 3 bytes)
# $AD:     MEMCPY                    (2B count, 3 bytes)
# $AE:     ADJSP                     (1B signed, 2 bytes)
# $AF:     ADJSP16                   (2B signed, 3 bytes)
# $B0:     DEREF                     (L = *L, 1 byte)
# $B1:     POPSTORE                  (pop addr, *addr = L, 1 byte)
# $B2:     ILLEGAL
# $B3:     PUSHL                     (push L, 1 byte)
# $B4:     POPR                      (pop → R, 1 byte)
# $B5:     MULT                      (L = L * R, 1 byte)
# $B6:     SDIV                      (L = L / R signed, 1 byte)
# $B7:     LONG prefix               (next byte is sub-opcode, 2+ bytes)
# $B8:     UDIV                      (L = L / R unsigned, 1 byte)
# $B9:     SMOD                      (L = L % R signed, 1 byte)
# $BA:     UMOD                      (L = L % R unsigned, 1 byte)
# $BB:     ADD                       (L = L + R, 1 byte)
# $BC:     SUB                       (L = L - R, 1 byte)
# $BD:     SHL                       (L = L << R, 1 byte)
# $BE:     USHR                      (L = L >>> R, 1 byte)
# $BF:     SSHR                      (L = L >> R, 1 byte)
# $C0:     CMP_EQ                    (L = (L == R), 1 byte)
# $C1:     CMP_NE                    (L = (L != R), 1 byte)
# $C2:     CMP_LT                    (L = (L < R) signed, 1 byte)
# $C3:     CMP_LE                    (L = (L <= R) signed, 1 byte)
# $C4:     CMP_GT                    (L = (L > R) signed, 1 byte)
# $C5:     CMP_GE                    (L = (L >= R) signed, 1 byte)
# $C6:     UCMP_LT                   (unsigned, 1 byte)
# $C7:     UCMP_LE                   (unsigned, 1 byte)
# $C8:     UCMP_GT                   (unsigned, 1 byte)
# $C9:     UCMP_GE                   (unsigned, 1 byte)
# $CA:     NOT                       (L = !L, 1 byte)
# $CB:     NEGATE                    (L = -L, 1 byte)
# $CC:     COMPLEMENT                (L = ~L, 1 byte)
# $CD:     SWAP                      (swap L ↔ R, 1 byte)
# $CE:     ILLEGAL
# $CF:     RETURN                    (1 byte)
# $D0:     INC                       (L++, 1 byte)
# $D1:     DEC                       (L--, 1 byte)
# $D2:     SHL1                      (L <<= 1, 1 byte)
# $D3:     DEREFB                    (L = *(byte*)L, 1 byte)
# $D4:     POPSTOREB                 (pop addr, *(byte*)addr = L, 1 byte)
# $D5:     SWITCH_CONTIG             (base:2B + limit:2B + default:2B + limit*target:2B)
# $D6:     JUMP                      (2B target, 3 bytes)
# $D7:     JUMPT                     (2B target, 3 bytes)
# $D8:     JUMPF                     (2B target, 3 bytes)
# $D9:     SWITCH_SPARSE             (2B count + entries, variable)
# $DA:     AND                       (L = L & R, 1 byte)
# $DB:     OR                        (L = L | R, 1 byte)
# $DC:     XOR                       (L = L ^ R, 1 byte)
# $DD:     CALLIND                   (call *L, 1 byte)
# $DE:     LEA far                   (L = &fp[off], 2B frame, 3 bytes)
# $DF:     LEAR far                  (R = &fp[off], 2B frame, 3 bytes)
# $E0:     SLOADBF                   (2B descriptor, 3 bytes)
# $E1:     ULOADBF                   (2B descriptor, 3 bytes)
# $E2:     STOREBF                   (2B descriptor, 3 bytes)
# $E3:     RJUMP                     (1B signed offset, 2 bytes)
# $E4:     RJUMPT                    (1B signed offset, 2 bytes)
# $E5:     RJUMPF                    (1B signed offset, 2 bytes)
# $E6:     RJUMP2                    (1B signed offset, 2 bytes)  [alias]
# $E7:     RJUMPT2                   (1B signed offset, 2 bytes)  [alias]
# $E8:     RJUMPF2                   (1B signed offset, 2 bytes)  [alias]
# $E9:     CALL_ADJSP                (2B target + 1B adjsp, 4 bytes)
# $EA:     CALLIND_ADJSP             (1B adjsp, 2 bytes)
# $EB-$FE: ILLEGAL
# $FF:     SPECIAL / BRK             (1 byte)


def slot_name(idx: int) -> str:
    if idx < 12:
        return f"local{idx}"
    return f"arg{idx - 11}"


def frame_name(offset: int) -> str:
    if offset < 0:
        return f"fp[{offset}]"
    return f"fp[+{offset}]"


@dataclass
class Instruction:
    offset: int
    addr: int      # WRAM address
    opcode: int
    mnemonic: str
    operand_bytes: bytes
    operand_str: str
    size: int
    target: int = 0
    is_jump: bool = False
    is_call: bool = False
    is_return: bool = False
    is_switch: bool = False
    switch_cases: list = field(default_factory=list)


class Decoder:
    def __init__(self, data: bytes, bc_start: int, bc_end: int, wram_base: int):
        self.data = data
        self.start = bc_start
        self.end = bc_end
        self.base = wram_base

    def addr(self, offset: int) -> int:
        return self.base + offset

    def u8(self, pos: int) -> int:
        return self.data[pos]

    def s8(self, pos: int) -> int:
        v = self.data[pos]
        return v - 256 if v > 127 else v

    def u16(self, pos: int) -> int:
        if pos + 2 > len(self.data):
            return 0
        return struct.unpack_from("<H", self.data, pos)[0]

    def s16(self, pos: int) -> int:
        if pos + 2 > len(self.data):
            return 0
        return struct.unpack_from("<h", self.data, pos)[0]

    def insn(self, pos, op, mnem, ob, ostr, sz, **kw):
        return Instruction(pos, self.addr(pos), op, mnem, ob, ostr, sz, **kw)

    def decode_all(self) -> list[Instruction]:
        instructions = []
        pos = self.start
        while pos < self.end:
            insn = self.decode_one(pos)
            if insn is None:
                break
            instructions.append(insn)
            pos += insn.size
        return instructions

    def decode_one(self, pos: int) -> Optional[Instruction]:
        if pos >= len(self.data):
            return None
        op = self.data[pos]
        a = self.addr(pos)

        # === Quick slots: $00-$3F ===
        if op <= 0x0F:
            return self.insn(pos, op, "LOADL", b"", slot_name(op), 1)
        if op <= 0x1F:
            return self.insn(pos, op, "LOADR", b"", slot_name(op & 0xF), 1)
        if op <= 0x2F:
            return self.insn(pos, op, "STORE", b"", slot_name(op & 0xF), 1)
        if op <= 0x3F:
            return self.insn(pos, op, "PUSH", b"", slot_name(op & 0xF), 1)

        # === Quick immediates: $40-$7F ===
        if op <= 0x4F:
            return self.insn(pos, op, "LOADL", b"", f"#{op & 0xF}", 1)
        if op <= 0x5F:
            return self.insn(pos, op, "LOADR", b"", f"#{op & 0xF}", 1)
        if op <= 0x6F:
            return self.insn(pos, op, "PUSH", b"", f"#{op & 0xF}", 1)
        if op <= 0x7F:
            return self.insn(pos, op, "ADD", b"", f"#{op & 0xF}", 1)

        # === $80: ILLEGAL ===
        if op == 0x80:
            return self.insn(pos, op, "ILLEGAL", b"", "", 1)

        # === Extended: $81-$90 ===
        if 0x81 <= op <= 0x90:
            return self._extended(op, pos)

        # === $91-$9F: ILLEGAL ===
        if 0x91 <= op <= 0x9F:
            return self.insn(pos, op, "ILLEGAL", b"", f"${op:02X}", 1)

        # === $A0-$AF ===
        if 0xA0 <= op <= 0xAF:
            return self._ax_range(op, pos)

        # === $B0-$BF: ALU / stack / LONG ===
        if 0xB0 <= op <= 0xBF:
            return self._bx_range(op, pos)

        # === $C0-$CF: Compare / logic / RETURN ===
        if 0xC0 <= op <= 0xCF:
            return self._cx_range(op, pos)

        # === $D0-$DF ===
        if 0xD0 <= op <= 0xDF:
            return self._dx_range(op, pos)

        # === $E0-$EA ===
        if 0xE0 <= op <= 0xEA:
            return self._ex_range(op, pos)

        # === $EB-$FE: ILLEGAL ===
        if 0xEB <= op <= 0xFE:
            return self.insn(pos, op, "ILLEGAL", b"", f"${op:02X}", 1)

        # === $FF: SPECIAL ===
        return self.insn(pos, op, "SPECIAL", b"", "", 1)

    def _extended(self, op, pos):
        """$81-$90: paired near(1B)/far(2B) operations."""
        #  $81/$82: LOADL near/far
        #  $83/$84: LOADR near/far
        #  $85/$86: STORE near/far
        #  $87/$88: PUSH near/far
        #  $89/$8A: LOADL #imm8/#imm16
        #  $8B/$8C: LOADR #imm8/#imm16
        #  $8D/$8E: PUSH #imm8/#imm16
        #  $8F/$90: ADD #imm8/#imm16
        group = (op - 0x81) // 2
        is_far = (op - 0x81) % 2  # 0=near/imm8, 1=far/imm16

        mnemonics = ["LOADL", "LOADR", "STORE", "PUSH",
                     "LOADL", "LOADR", "PUSH", "ADD"]
        mnem = mnemonics[group]

        if group < 4:
            # Frame-relative addressing
            if is_far:
                off = self.s16(pos + 1)
                return self.insn(pos, op, mnem, self.data[pos+1:pos+3],
                                 f"far {frame_name(off)}", 3)
            else:
                off = self.s8(pos + 1)
                return self.insn(pos, op, mnem, self.data[pos+1:pos+2],
                                 f"near {frame_name(off)}", 2)
        else:
            # Immediate
            if is_far:
                v = self.u16(pos + 1)
                sv = self.s16(pos + 1)
                label = f"#{sv}" if sv < 0 else f"#{v}"
                return self.insn(pos, op, mnem, self.data[pos+1:pos+3],
                                 f"{label} (${v:04X})", 3)
            else:
                v = self.s8(pos + 1)
                uv = self.u8(pos + 1)
                return self.insn(pos, op, mnem, self.data[pos+1:pos+2],
                                 f"#{v} (${uv:02X})", 2)

    def _ax_range(self, op, pos):
        """$A0-$AF."""
        # $A0-$A3: byte ops with far frame (2B operand, size 3)
        if op == 0xA0:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "LOADLB", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)
        if op == 0xA1:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "LOADRB", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)
        if op == 0xA2:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "STOREB", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)
        if op == 0xA3:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "PUSHB", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)

        # $A4-$AB: word/byte ops with absolute addr (2B operand, size 3)
        if op == 0xA4:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "LOADL", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xA5:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "LOADLB", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xA6:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "LOADR", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xA7:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "LOADRB", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xA8:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "STORE", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xA9:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "STOREB", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xAA:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "PUSH", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)
        if op == 0xAB:
            a = self.u16(pos + 1)
            return self.insn(pos, op, "PUSHB", self.data[pos+1:pos+3],
                             f"[${a:04X}]", 3)

        # $AC: CALL (2B target)
        if op == 0xAC:
            t = self.u16(pos + 1)
            return self.insn(pos, op, "CALL", self.data[pos+1:pos+3],
                             f"${t:04X}", 3, target=t, is_call=True)
        # $AD: MEMCPY (2B count)
        if op == 0xAD:
            n = self.u16(pos + 1)
            return self.insn(pos, op, "MEMCPY", self.data[pos+1:pos+3],
                             f"#{n}", 3)
        # $AE: ADJSP (1B signed)
        if op == 0xAE:
            v = self.s8(pos + 1)
            return self.insn(pos, op, "ADJSP", self.data[pos+1:pos+2],
                             f"#{v}", 2)
        # $AF: ADJSP16 (2B signed)
        if op == 0xAF:
            v = self.s16(pos + 1)
            return self.insn(pos, op, "ADJSP", self.data[pos+1:pos+3],
                             f"#{v}", 3)

        return self.insn(pos, op, "???", b"", "", 1)

    def _bx_range(self, op, pos):
        """$B0-$BF: ALU, stack ops, LONG prefix."""
        SIMPLE = {
            0xB0: "DEREF",    0xB1: "POPSTORE",  0xB2: "ILLEGAL",
            0xB3: "PUSHL",    0xB4: "POPR",      0xB5: "MULT",
            0xB6: "SDIV",     0xB8: "UDIV",      0xB9: "SMOD",
            0xBA: "UMOD",     0xBB: "ADD",       0xBC: "SUB",
            0xBD: "SHL",      0xBE: "USHR",      0xBF: "SSHR",
        }
        if op in SIMPLE:
            return self.insn(pos, op, SIMPLE[op], b"", "", 1)

        if op == 0xB7:
            return self._long_prefix(pos)

        return self.insn(pos, op, "???", b"", "", 1)

    # Valid LONG sub-opcodes (handler pointer >= $8000 in sub-dispatch at $A2FE)
    _LONG_VALID = {
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B,
        0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13,
        0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
        0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B,
        0x2C, 0x2D, 0x2E, 0x2F, 0x33, 0x36, 0x37, 0x3B, 0x3C,
        0x41, 0x43, 0x44, 0x47, 0x49, 0x52, 0x53, 0x55, 0x56,
        0x58, 0x59, 0x5A, 0x5B, 0x5C,
        0x70, 0x72, 0x73, 0x74, 0x77, 0x78, 0x7C, 0x7D,
        0x81, 0x82, 0x83, 0x87, 0x88, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F,
        0x91, 0x92, 0x93, 0x94, 0x97, 0x98,
        0xA2, 0xA3, 0xA4, 0xA5, 0xA8, 0xA9,
        0xB0, 0xB1, 0xB2, 0xB3, 0xB4, 0xB7, 0xB8, 0xBE,
        0xC1, 0xC2, 0xC3, 0xC7, 0xC9, 0xCA, 0xCE,
        0xD0, 0xD1, 0xD5, 0xD7, 0xD8, 0xDB, 0xDC, 0xDD, 0xDE, 0xDF,
        0xE0, 0xE2, 0xE3, 0xE6, 0xEA, 0xEB, 0xEE, 0xEF, 0xF0, 0xF1,
        0xF3, 0xF5, 0xF9, 0xFA, 0xFB, 0xFE,
    }

    # Best-effort names for LONG sub-opcodes (all 2-byte quick unless in far/abs sets)
    _LONG_NAMES = {
        0xB0: "LONG_DEREF", 0xB1: "LONG_POPSTORE",
        0xB2: "LONG_PUSHL", 0xB3: "LONG_POPR", 0xB4: "LONG_MULT",
        0xB7: "LONG_UDIV", 0xB8: "LONG_SMOD", 0xBE: "LONG_USHR",
        0xC1: "LONG_CMP_NE", 0xC2: "LONG_CMP_LT", 0xC3: "LONG_CMP_LE",
        0xC7: "LONG_CMP_GE", 0xC9: "LONG_NEGATE", 0xCA: "LONG_NOT",
        0xCE: "LONG_RETURN",
        0xD0: "LONG_INC", 0xD1: "LONG_DEC", 0xD5: "LONG_DEREFB",
        0xDB: "LONG_OR", 0xDC: "LONG_XOR", 0xDD: "LONG_CALLIND",
        0xDE: "LONG_LEA", 0xDF: "LONG_LEAR",
    }

    def _long_prefix(self, pos):
        """$B7: LONG prefix — next byte is sub-opcode for 32-bit ops.

        The LONG sub-dispatch table at ROM $A2FE has its own 256-entry layout
        that does NOT mirror the regular opcode encoding. Only sub-opcodes
        $0C-$0F (far_frame) and $10-$13 (read_abs) read operands from IP.
        All other valid sub-opcodes are 2-byte (quick).
        """
        if pos + 1 >= len(self.data):
            return self.insn(pos, 0xB7, "LONG", b"", "???", 1)
        sub = self.u8(pos + 1)

        # Sub-opcodes $0C-$0F: read 2-byte signed frame offset from IP (4 bytes)
        if sub in (0x0C, 0x0D, 0x0E, 0x0F):
            NAMES = {0x0C: "LONG_LOADL", 0x0D: "LONG_LOADR",
                     0x0E: "LONG_STORE", 0x0F: "LONG_PUSH"}
            off = self.s16(pos + 2)
            return self.insn(pos, 0xB7, NAMES[sub], self.data[pos+1:pos+4],
                             f"far {frame_name(off)}", 4)

        # Sub-opcodes $10-$13: read 2-byte absolute address from IP (4 bytes)
        if sub in (0x10, 0x11, 0x12, 0x13):
            NAMES = {0x10: "LONG_LOADL", 0x11: "LONG_LOADR",
                     0x12: "LONG_STORE", 0x13: "LONG_PUSH"}
            a = self.u16(pos + 2)
            return self.insn(pos, 0xB7, NAMES[sub], self.data[pos+1:pos+4],
                             f"[${a:04X}]", 4)

        # Sub-opcodes $18/$19: 32-bit immediate into L/R (6 bytes)
        if sub in (0x18, 0x19):
            name = "LONG_LOADL" if sub == 0x18 else "LONG_LOADR"
            if pos + 5 < len(self.data):
                v = struct.unpack_from("<I", self.data, pos + 2)[0]
                return self.insn(pos, 0xB7, name, self.data[pos+1:pos+6],
                                 f"#{v} (${v:08X})", 6)
            return self.insn(pos, 0xB7, name, bytes([sub]), "???", 2)

        # All other valid sub-opcodes are 2 bytes (no IP operands)
        if sub in self._LONG_VALID:
            name = self._LONG_NAMES.get(sub, f"LONG_${sub:02X}")
            return self.insn(pos, 0xB7, name, bytes([sub]), "", 2)

        # Invalid sub-opcode (handler pointer < $8000)
        return self.insn(pos, 0xB7, "LONG_ILLEGAL", bytes([sub]),
                         f"${sub:02X}", 2)

    def _cx_range(self, op, pos):
        """$C0-$CF."""
        NAMES = {
            0xC0: "CMP_EQ",  0xC1: "CMP_NE",
            0xC2: "CMP_LT",  0xC3: "CMP_LE",
            0xC4: "CMP_GT",  0xC5: "CMP_GE",
            0xC6: "UCMP_LT", 0xC7: "UCMP_LE",
            0xC8: "UCMP_GT", 0xC9: "UCMP_GE",
            0xCA: "NOT",     0xCB: "NEGATE",
            0xCC: "COMPLEMENT", 0xCD: "SWAP",
            0xCE: "ILLEGAL",
        }
        if op == 0xCF:
            return self.insn(pos, op, "RETURN", b"", "", 1, is_return=True)
        return self.insn(pos, op, NAMES.get(op, "???"), b"", "", 1)

    def _dx_range(self, op, pos):
        """$D0-$DF."""
        if op == 0xD0:
            return self.insn(pos, op, "INC", b"", "", 1)
        if op == 0xD1:
            return self.insn(pos, op, "DEC", b"", "", 1)
        if op == 0xD2:
            return self.insn(pos, op, "SHL1", b"", "", 1)
        if op == 0xD3:
            return self.insn(pos, op, "DEREFB", b"", "", 1)
        if op == 0xD4:
            return self.insn(pos, op, "POPSTOREB", b"", "", 1)

        if op == 0xD5:
            return self._switch_contig(pos)
        if op == 0xD6:
            t = self.u16(pos + 1)
            return self.insn(pos, op, "JUMP", self.data[pos+1:pos+3],
                             f"${t:04X}", 3, target=t, is_jump=True)
        if op == 0xD7:
            t = self.u16(pos + 1)
            return self.insn(pos, op, "JUMPT", self.data[pos+1:pos+3],
                             f"${t:04X}", 3, target=t, is_jump=True)
        if op == 0xD8:
            t = self.u16(pos + 1)
            return self.insn(pos, op, "JUMPF", self.data[pos+1:pos+3],
                             f"${t:04X}", 3, target=t, is_jump=True)
        if op == 0xD9:
            return self._switch_sparse(pos)

        if op == 0xDA:
            return self.insn(pos, op, "AND", b"", "", 1)
        if op == 0xDB:
            return self.insn(pos, op, "OR", b"", "", 1)
        if op == 0xDC:
            return self.insn(pos, op, "XOR", b"", "", 1)
        if op == 0xDD:
            return self.insn(pos, op, "CALLIND", b"", "", 1, is_call=True)

        if op == 0xDE:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "LEA", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)
        if op == 0xDF:
            off = self.s16(pos + 1)
            return self.insn(pos, op, "LEAR", self.data[pos+1:pos+3],
                             f"far {frame_name(off)}", 3)

        return self.insn(pos, op, "???", b"", "", 1)

    def _ex_range(self, op, pos):
        """$E0-$EA."""
        if op == 0xE0:
            d = self.u16(pos + 1)
            return self.insn(pos, op, "SLOADBF", self.data[pos+1:pos+3],
                             f"${d:04X}", 3)
        if op == 0xE1:
            d = self.u16(pos + 1)
            return self.insn(pos, op, "ULOADBF", self.data[pos+1:pos+3],
                             f"${d:04X}", 3)
        if op == 0xE2:
            d = self.u16(pos + 1)
            return self.insn(pos, op, "STOREBF", self.data[pos+1:pos+3],
                             f"${d:04X}", 3)

        # Relative jumps: 1B signed offset
        if op in (0xE3, 0xE6):  # RJUMP / RJUMP2
            off = self.s8(pos + 1)
            t = self.addr(pos + 2) + off
            return self.insn(pos, op, "RJUMP", self.data[pos+1:pos+2],
                             f"${t:04X} ({off:+d})", 2, target=t, is_jump=True)
        if op in (0xE4, 0xE7):  # RJUMPT / RJUMPT2
            off = self.s8(pos + 1)
            t = self.addr(pos + 2) + off
            return self.insn(pos, op, "RJUMPT", self.data[pos+1:pos+2],
                             f"${t:04X} ({off:+d})", 2, target=t, is_jump=True)
        if op in (0xE5, 0xE8):  # RJUMPF / RJUMPF2
            off = self.s8(pos + 1)
            t = self.addr(pos + 2) + off
            return self.insn(pos, op, "RJUMPF", self.data[pos+1:pos+2],
                             f"${t:04X} ({off:+d})", 2, target=t, is_jump=True)

        if op == 0xE9:  # CALL + ADJSP: 2B target + 1B adjsp
            t = self.u16(pos + 1)
            adj = self.s8(pos + 3)
            return self.insn(pos, op, "CALL_ADJSP", self.data[pos+1:pos+4],
                             f"${t:04X}, adjsp={adj}", 4,
                             target=t, is_call=True)
        if op == 0xEA:  # CALLIND + ADJSP: 1B adjsp
            adj = self.s8(pos + 1)
            return self.insn(pos, op, "CALLIND_ADJSP", self.data[pos+1:pos+2],
                             f"adjsp={adj}", 2, is_call=True)

        return self.insn(pos, op, "???", b"", "", 1)

    def _switch_contig(self, pos):
        # Format: base(u16) + limit(u16) + default(u16) + limit × target(u16)
        base = self.u16(pos + 1)
        limit = self.u16(pos + 3)
        default = self.u16(pos + 5)
        sz = 7 + limit * 2
        cases = []
        for i in range(limit):
            toff = pos + 7 + i * 2
            if toff + 1 < len(self.data):
                t = self.u16(toff)
                cases.append((base + i, t))
        cases.append(("default", default))
        insn = self.insn(pos, 0xD5, "SWITCH_CONTIG", self.data[pos+1:pos+sz],
                         f"base={base},n={limit}", sz, is_switch=True)
        insn.switch_cases = cases
        return insn

    def _switch_sparse(self, pos):
        n = self.u16(pos + 1)
        sz = 3 + n * 4 + 2
        cases = []
        for i in range(n):
            eoff = pos + 3 + i * 4
            if eoff + 3 < len(self.data):
                val = self.u16(eoff)
                t = self.u16(eoff + 2)
                cases.append((val, t))
        doff = pos + 3 + n * 4
        if doff + 1 < len(self.data):
            cases.append(("default", self.u16(doff)))
        insn = self.insn(pos, 0xD9, "SWITCH_SPARSE", self.data[pos+1:pos+sz],
                         f"n={n}", sz, is_switch=True)
        insn.switch_cases = cases
        return insn


# =============================================================================
# Cross-Reference Builder
# =============================================================================

@dataclass
class XRef:
    from_func: int
    from_addr: int
    to_addr: int
    call_type: str


def build_xrefs(all_funcs, all_insns):
    xrefs = []
    for fa, insns in all_insns.items():
        for i in insns:
            if i.is_call and i.target:
                xrefs.append(XRef(fa, i.addr, i.target, i.mnemonic))
    return xrefs


# =============================================================================
# Pseudo-C Decompiler
# =============================================================================

C_BINOP = {
    "CMP_EQ": "==", "CMP_NE": "!=", "CMP_LT": "<", "CMP_LE": "<=",
    "CMP_GT": ">", "CMP_GE": ">=",
    "UCMP_LT": "< /*u*/", "UCMP_LE": "<= /*u*/",
    "UCMP_GT": "> /*u*/", "UCMP_GE": ">= /*u*/",
    "ADD": "+", "SUB": "-", "MULT": "*",
    "SDIV": "/", "UDIV": "/ /*u*/", "SMOD": "%", "UMOD": "% /*u*/",
    "SHL": "<<", "USHR": ">>>", "SSHR": ">>",
    "AND": "&", "OR": "|", "XOR": "^",
}
# Add LONG_ versions
for k, v in list(C_BINOP.items()):
    C_BINOP[f"LONG_{k}"] = v


def decompile_function(func, insns, func_addrs):
    lines = []
    n_args = 0
    for i in insns:
        if i.opcode in range(0x0C, 0x10) or i.opcode in range(0x1C, 0x20) or \
           i.opcode in range(0x2C, 0x30) or i.opcode in range(0x3C, 0x40):
            n_args = max(n_args, (i.opcode & 0xF) - 11)

    args_str = ", ".join(f"arg{i}" for i in range(1, n_args + 1))
    name = f"sub_{func.addr:04X}"
    lines.append(f"// {func.overlay}:{name}  frame={func.frame_size} "
                 f"({func.local_bytes}B locals)")
    lines.append(f"void {name}({args_str}) {{")

    if func.local_bytes > 0:
        nw = func.local_bytes // 2
        nr = func.local_bytes % 2
        for i in range(nw):
            lines.append(f"    int16 local{i};")
        if nr:
            lines.append(f"    int8 local{nw};")

    jtargets = set()
    for i in insns:
        if i.is_jump and i.target:
            jtargets.add(i.target)
        if i.is_switch:
            for _, t in i.switch_cases:
                jtargets.add(t)

    ind = "    "
    for i in insns:
        if i.addr in jtargets:
            lines.append(f"  L_{i.addr:04X}:")
        m = i.mnemonic
        o = i.operand_str

        # Loads
        if m in ("LOADL", "LONG_LOADL"):
            lines.append(f"{ind}L = {o};")
            continue
        if m in ("LOADR", "LONG_LOADR"):
            lines.append(f"{ind}R = {o};")
            continue
        if m in ("LOADLB", "LONG_LOADLB"):
            lines.append(f"{ind}L = (byte){o};")
            continue
        if m in ("LOADRB", "LONG_LOADRB"):
            lines.append(f"{ind}R = (byte){o};")
            continue

        # Stores
        if m in ("STORE", "LONG_STORE"):
            lines.append(f"{ind}{o} = L;")
            continue
        if m in ("STOREB", "LONG_STOREB"):
            lines.append(f"{ind}(byte){o} = L;")
            continue

        # Push
        if m in ("PUSH", "LONG_PUSH"):
            lines.append(f"{ind}push({o});")
            continue
        if m in ("PUSHB", "LONG_PUSHB"):
            lines.append(f"{ind}push((byte){o});")
            continue
        if m in ("PUSHL", "LONG_PUSHL"):
            lines.append(f"{ind}push(L);")
            continue

        # Pop
        if m in ("POPR", "LONG_POPR"):
            lines.append(f"{ind}R = pop();")
            continue
        if m in ("POPSTORE", "LONG_POPSTORE"):
            lines.append(f"{ind}*pop() = L;")
            continue
        if m in ("POPSTOREB", "LONG_POPSTOREB"):
            lines.append(f"{ind}*(byte*)pop() = L;")
            continue

        # Binary ops
        if m in C_BINOP:
            lines.append(f"{ind}L = L {C_BINOP[m]} R;")
            continue

        # ADD with operand (quick immediate or extended immediate)
        if m == "ADD" and o:
            lines.append(f"{ind}L += {o};")
            continue

        # Unary
        if m in ("DEREF", "LONG_DEREF"):
            lines.append(f"{ind}L = *L;")
            continue
        if m in ("DEREFB", "LONG_DEREFB"):
            lines.append(f"{ind}L = *(byte*)L;")
            continue
        if m in ("NOT", "LONG_NOT"):
            lines.append(f"{ind}L = !L;")
            continue
        if m in ("NEGATE", "LONG_NEGATE"):
            lines.append(f"{ind}L = -L;")
            continue
        if m in ("COMPLEMENT", "LONG_COMPL"):
            lines.append(f"{ind}L = ~L;")
            continue
        if m in ("SWAP", "LONG_SWAP"):
            lines.append(f"{ind}swap(L, R);")
            continue
        if m in ("INC", "LONG_INC"):
            lines.append(f"{ind}L++;")
            continue
        if m in ("DEC", "LONG_DEC"):
            lines.append(f"{ind}L--;")
            continue
        if m in ("SHL1", "LONG_SHL1"):
            lines.append(f"{ind}L <<= 1;")
            continue

        # LEA
        if m in ("LEA", "LONG_LEA"):
            lines.append(f"{ind}L = &{o};")
            continue
        if m == "LEAR":
            lines.append(f"{ind}R = &{o};")
            continue

        # ADJSP
        if m == "ADJSP":
            lines.append(f"{ind}sp += {o};")
            continue

        # MEMCPY
        if m == "MEMCPY":
            lines.append(f"{ind}memcpy(R, L, {o});")
            continue

        # Calls
        if m == "CALL":
            lines.append(f"{ind}sub_{i.target:04X}();")
            continue
        if m == "CALL_ADJSP":
            parts = o.split(", ")
            lines.append(f"{ind}sub_{i.target:04X}(/* {parts[1]} */);")
            continue
        if m == "CALLIND":
            lines.append(f"{ind}(*L)();")
            continue
        if m == "CALLIND_ADJSP":
            lines.append(f"{ind}(*L)(/* {o} */);")
            continue

        # Jumps
        if m in ("JUMP", "RJUMP"):
            lines.append(f"{ind}goto L_{i.target:04X};")
            continue
        if m in ("JUMPT", "RJUMPT"):
            lines.append(f"{ind}if (L) goto L_{i.target:04X};")
            continue
        if m in ("JUMPF", "RJUMPF"):
            lines.append(f"{ind}if (!L) goto L_{i.target:04X};")
            continue

        if m == "RETURN":
            lines.append(f"{ind}return;")
            continue

        # Switch
        if m in ("SWITCH_CONTIG", "SWITCH_SPARSE"):
            lines.append(f"{ind}switch (L) {{")
            for cv, t in i.switch_cases:
                if cv == "default":
                    lines.append(f"{ind}    default: goto L_{t:04X};")
                else:
                    lines.append(f"{ind}    case {cv}: goto L_{t:04X};")
            lines.append(f"{ind}}}")
            continue

        # Bitfields
        if m == "SLOADBF":
            lines.append(f"{ind}L = sloadbf(L, {o});")
            continue
        if m == "ULOADBF":
            lines.append(f"{ind}L = uloadbf(L, {o});")
            continue
        if m == "STOREBF":
            lines.append(f"{ind}storebf(L, {o});")
            continue

        if m == "SPECIAL":
            lines.append(f"{ind}__brk();")
            continue
        if m == "ILLEGAL":
            lines.append(f"{ind}/* ILLEGAL ${i.opcode:02X} */")
            continue

        lines.append(f"{ind}/* {m} {o} */")

    lines.append("}")
    return "\n".join(lines)


# =============================================================================
# Raw Disassembly Output
# =============================================================================

def format_raw(func, insns):
    lines = []
    lines.append(f"; === sub_{func.addr:04X} ({func.overlay}) "
                 f"frame={func.frame_size} ({func.local_bytes}B locals) ===")

    jtargets = set()
    for i in insns:
        if i.is_jump and i.target:
            jtargets.add(i.target)
        if i.is_switch:
            for _, t in i.switch_cases:
                jtargets.add(t)

    for i in insns:
        label = f"L{i.addr:04X}: " if i.addr in jtargets else "        "
        raw = " ".join(f"{b:02X}" for b in [i.opcode] + list(i.operand_bytes))
        line = f"  {label}${i.addr:04X}: {raw:16s} {i.mnemonic}"
        if i.operand_str:
            line += f"  {i.operand_str}"
        if i.is_switch and i.switch_cases:
            lines.append(line)
            for cv, t in i.switch_cases:
                if cv == "default":
                    lines.append(f"{'':38s}default -> ${t:04X}")
                else:
                    lines.append(f"{'':38s}case {cv} -> ${t:04X}")
            continue
        lines.append(line)
    return "\n".join(lines)


# =============================================================================
# CLI
# =============================================================================

def print_overlay_map(overlays):
    print(f"\n{'Name':10s} {'Bank':>4s} {'Addr':>6s} {'Size':>6s} {'Bytes':>7s} {'FileOff':>8s}")
    print("-" * 50)
    total = 0
    for o in overlays:
        print(f"{o.name:10s} ${o.bank:02X}  ${o.src_addr:04X}  "
              f"${o.size:04X}  {o.size:6d}  ${o.file_offset:06X}")
        total += o.size
    print(f"{'TOTAL':10s}                   {total:6d}")


def print_xrefs(xrefs, func_addrs):
    by_target = defaultdict(list)
    for x in xrefs:
        by_target[x.to_addr].append(x)

    print(f"\n=== Cross References ({len(xrefs)} calls, "
          f"{len(by_target)} targets) ===")

    unresolved = [t for t in by_target if t not in func_addrs]
    if unresolved:
        print(f"\nUnresolved ({len(unresolved)}):")
        for t in sorted(unresolved)[:20]:
            callers = [f"sub_{c.from_func:04X}" for c in by_target[t][:5]]
            print(f"  ${t:04X} <- {', '.join(callers)}")

    print(f"\nMost-called:")
    for t, callers in sorted(by_target.items(), key=lambda x: -len(x[1]))[:20]:
        tag = "ok" if t in func_addrs else "??"
        print(f"  sub_{t:04X} [{tag}] x{len(callers)}")


def main():
    import argparse
    p = argparse.ArgumentParser(description="RotK2 Koei Bytecode Disassembler")
    p.add_argument("rom", help="ROM file (.sfc/.smc)")
    p.add_argument("overlay", nargs="?", default="root",
                   help="Overlay name or 'all' (default: root)")
    p.add_argument("--raw", action="store_true", help="Raw disassembly")
    p.add_argument("--func", metavar="ADDR", help="Single function (hex)")
    p.add_argument("--xref", action="store_true", help="Cross-references")
    p.add_argument("--map", action="store_true", help="Overlay map only")
    p.add_argument("--stats", action="store_true", help="Statistics")
    args = p.parse_args()

    rom = load_rom(args.rom)
    overlays = load_overlays(rom)

    if args.map:
        print_overlay_map(overlays)
        return

    ovl_map = {o.name: o for o in overlays}
    if args.overlay == "all":
        target_ovls = overlays
    elif args.overlay in ovl_map:
        target_ovls = [ovl_map[args.overlay]]
    else:
        print(f"Unknown overlay '{args.overlay}'. Available:")
        for o in overlays:
            print(f"  {o.name}")
        sys.exit(1)

    all_funcs = {}
    all_insns = {}
    total_funcs = total_insns = total_illegals = 0

    for ovl in target_ovls:
        wram_base = 0x2000
        funcs = find_functions(ovl, wram_base)
        _trim_last_func(funcs, ovl.data, wram_base)
        total_funcs += len(funcs)

        for func in funcs:
            dec = Decoder(ovl.data, func.bc_start, func.bc_end, wram_base)
            insns = dec.decode_all()
            all_funcs[func.addr] = func
            all_insns[func.addr] = insns
            total_insns += len(insns)
            total_illegals += sum(1 for i in insns if i.mnemonic == "ILLEGAL")

        if not args.func and not args.xref and not args.stats:
            print(f"\n{'='*60}")
            print(f"Overlay: {ovl.name}  ({ovl.size} bytes, {len(funcs)} functions)")
            print(f"{'='*60}")
            for func in funcs:
                insns = all_insns[func.addr]
                print()
                if args.raw:
                    print(format_raw(func, insns))
                else:
                    print(decompile_function(func, insns, set(all_funcs.keys())))

    if args.func:
        ta = int(args.func, 16)
        if ta in all_funcs:
            func = all_funcs[ta]
            insns = all_insns[ta]
            if args.raw:
                print(format_raw(func, insns))
            else:
                print(decompile_function(func, insns, set(all_funcs.keys())))
        else:
            print(f"Function ${ta:04X} not found.")
            sys.exit(1)
        return

    if args.xref or args.stats:
        xrefs = build_xrefs(all_funcs, all_insns)
        if args.xref:
            print_xrefs(xrefs, set(all_funcs.keys()))

    if args.stats:
        print(f"\n=== Statistics ===")
        print(f"Overlays: {len(target_ovls)}")
        print(f"Functions: {total_funcs}")
        print(f"Instructions: {total_insns}")
        print(f"Illegal opcodes: {total_illegals}")

        mnem_freq = defaultdict(int)
        op_freq = defaultdict(int)
        for insns in all_insns.values():
            for i in insns:
                mnem_freq[i.mnemonic] += 1
                op_freq[i.opcode] += 1

        print(f"\nTop 20 mnemonics:")
        for m, c in sorted(mnem_freq.items(), key=lambda x: -x[1])[:20]:
            print(f"  {m:20s} {c:6d}")
        print(f"\nTop 20 opcodes:")
        for o, c in sorted(op_freq.items(), key=lambda x: -x[1])[:20]:
            print(f"  ${o:02X}  {c:6d}")

        xrefs = build_xrefs(all_funcs, all_insns)
        targets = set(x.to_addr for x in xrefs)
        unr = targets - set(all_funcs.keys())
        print(f"\nCall targets: {len(targets)}, resolved: {len(targets)-len(unr)}, "
              f"unresolved: {len(unr)}")


if __name__ == "__main__":
    main()
