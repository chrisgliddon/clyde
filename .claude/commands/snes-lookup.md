Look up SNES hardware facts, register addresses, opcodes, or patterns in clyde.db.

Query: $ARGUMENTS

Steps:
1. Search the `knowledge` table for matching entries:
   ```sql
   SELECT topic, title, content, type, tags FROM knowledge
   WHERE title LIKE '%<query>%' OR content LIKE '%<query>%' OR tags LIKE '%<query>%'
   ORDER BY verified DESC, type LIMIT 10;
   ```
2. If knowledge results are sparse, also search `doc_chunks`:
   ```sql
   SELECT d.title, dc.heading, dc.content FROM doc_chunks dc
   JOIN documentation d ON dc.doc_id = d.id
   WHERE dc.content LIKE '%<query>%'
   LIMIT 5;
   ```
3. If the query looks like a register address (e.g. "$2100", "$4200"), search for that hex pattern specifically.
4. Present results concisely: topic, fact/pattern, source. No fluff.
5. If nothing found, say so and suggest checking the online references listed in CLAUDE.md.
