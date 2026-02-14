Investigate a failing Mesen2 test crash.

$ARGUMENTS (format: "<project> <test_name>")

Steps:
1. Delegate to the **test-runner** agent to run the failing test and capture output.
2. Delegate to the **snes-researcher** agent to query clyde.db for known crash patterns matching the symptoms.
3. Delegate to the **asm-debugger** agent with: test output from step 1, knowledge base results from step 2, and the test name. Ask it to diagnose the root cause.
4. Review the debugger's findings. Present the root cause and suggested fix.
