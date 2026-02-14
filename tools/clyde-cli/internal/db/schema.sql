-- doc_chunks: stores chunked document content for embedding
CREATE TABLE IF NOT EXISTS doc_chunks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    doc_id INTEGER NOT NULL REFERENCES documentation(id),
    chunk_index INTEGER NOT NULL,
    heading TEXT,
    content TEXT NOT NULL,
    char_count INTEGER NOT NULL,
    content_hash TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE(doc_id, chunk_index)
);

CREATE INDEX IF NOT EXISTS idx_doc_chunks_doc_id ON doc_chunks(doc_id);
CREATE INDEX IF NOT EXISTS idx_doc_chunks_hash ON doc_chunks(content_hash);

-- vec_chunks: sqlite-vec virtual table for KNN search
CREATE VIRTUAL TABLE IF NOT EXISTS vec_chunks USING vec0(
    chunk_id INTEGER PRIMARY KEY,
    embedding float[768]
);
