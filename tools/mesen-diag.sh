#!/bin/bash
# mesen-diag.sh — Run a diagnostic Lua script against a ROM
# Usage: tools/mesen-diag.sh <project> <script.lua>
# Does NOT rebuild — use mesen-test.sh for build+test.

set -e
PROJECT="${1:?Usage: mesen-diag.sh <project> <script.lua>}"
SCRIPT="${2:?Usage: mesen-diag.sh <project> <script.lua>}"
ROM="projects/$PROJECT/build/$PROJECT.smc"
MESEN="/Applications/Mesen.app/Contents/MacOS/Mesen"

if [ ! -f "$ROM" ]; then
    echo "ROM not found: $ROM — building..."
    make -C "projects/$PROJECT" 2>&1
fi

$MESEN --testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true "$ROM" "$SCRIPT" 2>/dev/null
