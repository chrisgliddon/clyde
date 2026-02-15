Orchestrate a full phase workflow: research → code → build → test → commit.

Phase: $ARGUMENTS (e.g. "16" or "16 palette animation")

Steps:
1. Parse the phase number from the arguments. Look up the phase plan in the conversation context or clyde.db.
2. Research phase:
   - Use the `snes-researcher` agent to query clyde.db for relevant hardware facts, registers, and patterns
   - Use `/study-ref` if the phase plan references studying reference games
   - Summarize findings before proceeding to implementation
3. Implementation phase:
   - Use the `asm-coder` agent for all 65816/SPC700 assembly implementation
   - Provide the agent with research findings, target files, and specific requirements
   - For non-assembly changes (Makefiles, configs), edit directly
4. Build verification:
   - Run `make -C projects/akalabeth` to verify clean build
   - Fix any build errors before proceeding
5. Test regression:
   - Run `bash tools/mesen-test.sh akalabeth all` for full regression
   - If phase-specific diagnostics exist, run those too
   - Fix any test failures
6. Report results:
   - Summarize what was implemented
   - List files changed
   - Report build and test status
   - Note any issues or follow-ups
