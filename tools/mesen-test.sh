#!/bin/bash
# mesen-test.sh — Build & run Mesen2 test(s) for a project
# Usage: tools/mesen-test.sh <project> [test_name]
#   project: e.g. "akalabeth"
#   test_name: e.g. "test_chargen" (without .lua), or "all" (default)
# Exit code: 0 = all pass, 1 = failure

set -e
PROJECT="${1:?Usage: mesen-test.sh <project> [test_name]}"
TEST="${2:-all}"
DIR="projects/$PROJECT"
ROM="$DIR/build/$PROJECT.smc"
MESEN="/Applications/Mesen.app/Contents/MacOS/Mesen"
FLAGS="--testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true"

# Build
echo "=== Building $PROJECT ==="
make -C "$DIR" clean >/dev/null 2>&1
make -C "$DIR" 2>&1
echo ""

# Run tests
if [ "$TEST" = "all" ]; then
    TESTS=$(ls "$DIR/tests/test_"*.lua 2>/dev/null | grep -v diag | grep -v template)
else
    TESTS="$DIR/tests/${TEST}.lua"
fi

FAILED=0
for t in $TESTS; do
    name=$(basename "$t" .lua)
    echo "=== Running $name ==="
    if $MESEN $FLAGS "$ROM" "$t" 2>/dev/null; then
        echo "  -> PASSED"
    else
        echo "  -> FAILED (exit $?)"
        FAILED=1
    fi
    echo ""
done

if [ $FAILED -eq 0 ]; then
    echo "All tests passed."
else
    echo "Some tests FAILED."
    exit 1
fi
