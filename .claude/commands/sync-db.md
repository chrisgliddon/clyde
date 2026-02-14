Sync docs to clyde.db — register new/changed docs, chunk content, attempt embeddings.

Arguments: $ARGUMENTS (optional: specific file path to sync, or "all" for full scan)

Steps:
1. Scan `docs/content/` for .md files not yet in the `documentation` table:
   ```sql
   SELECT file_path FROM documentation;
   ```
   Compare against `find docs/content -name "*.md"` output.

2. For each new doc:
   - Read the file, extract frontmatter (title, description, weight)
   - INSERT into `documentation` with appropriate topic, categories, quality, summary, key_concepts
   - Report what was added

3. Run chunking for new docs:
   - Try `cd /Users/polofield/dev/clyde && tools/clyde-cli/clyde index`
   - If clyde CLI isn't built or fails, chunk manually:
     - Split doc content by ## headings
     - Each chunk max 1500 chars
     - SHA-256 hash each chunk
     - INSERT into doc_chunks (doc_id, chunk_index, heading, content, char_count, content_hash)

4. Attempt embeddings:
   - Check if Ollama is running: `curl -s http://localhost:11434/api/tags`
   - If available, run `clyde index` which handles embedding automatically
   - If not available, report that embeddings are pending

5. Run knowledge extraction:
   - Try `clyde knowledge`
   - If CLI unavailable, scan new docs for register refs ($XXXX), opcodes (LDA, STA, etc.), and warning keywords
   - INSERT into knowledge table

6. Report final counts:
   ```sql
   SELECT COUNT(*) FROM documentation;
   SELECT COUNT(*) FROM doc_chunks;
   SELECT COUNT(*) FROM knowledge;
   ```
