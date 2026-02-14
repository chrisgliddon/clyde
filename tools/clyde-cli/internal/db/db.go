package db

import (
	"database/sql"
	_ "embed"
	"encoding/json"
	"fmt"

	sqlite_vec "github.com/asg017/sqlite-vec-go-bindings/cgo"
	_ "github.com/mattn/go-sqlite3"
)

//go:embed schema.sql
var schemaSQL string

func init() {
	sqlite_vec.Auto()
}

type DB struct {
	*sql.DB
}

type Doc struct {
	ID       int
	FilePath string
	Title    string
	Topic    string
}

type Chunk struct {
	ID          int
	DocID       int
	ChunkIndex  int
	Heading     string
	Content     string
	CharCount   int
	ContentHash string
}

type SearchResult struct {
	ChunkID   int
	Distance  float64
	Heading   string
	Content   string
	DocTitle  string
	FilePath  string
}

type Stats struct {
	DocCount       int
	ChunkCount     int
	VecCount       int
	KnowledgeCount int
	CodeRegCount   int
	DBSizeBytes    int64
}

func Open(path string) (*DB, error) {
	sqlDB, err := sql.Open("sqlite3", path+"?_journal_mode=WAL&_busy_timeout=5000")
	if err != nil {
		return nil, fmt.Errorf("open db: %w", err)
	}
	return &DB{sqlDB}, nil
}

func (db *DB) Migrate() error {
	_, err := db.Exec(schemaSQL)
	if err != nil {
		return fmt.Errorf("migrate: %w", err)
	}
	return nil
}

func (db *DB) GetStats() (Stats, error) {
	var s Stats
	queries := []struct {
		dest  *int
		query string
	}{
		{&s.DocCount, "SELECT COUNT(*) FROM documentation"},
		{&s.ChunkCount, "SELECT COUNT(*) FROM doc_chunks"},
		{&s.KnowledgeCount, "SELECT COUNT(*) FROM knowledge"},
		{&s.CodeRegCount, "SELECT COUNT(*) FROM code_registry"},
	}
	for _, q := range queries {
		if err := db.QueryRow(q.query).Scan(q.dest); err != nil {
			return s, fmt.Errorf("stats query %q: %w", q.query, err)
		}
	}
	// vec_chunks may not exist yet
	if err := db.QueryRow("SELECT COUNT(*) FROM vec_chunks").Scan(&s.VecCount); err != nil {
		s.VecCount = 0
	}
	// DB size via page_count * page_size
	var pageCount, pageSize int64
	db.QueryRow("PRAGMA page_count").Scan(&pageCount)
	db.QueryRow("PRAGMA page_size").Scan(&pageSize)
	s.DBSizeBytes = pageCount * pageSize
	return s, nil
}

func (db *DB) ListDocs() ([]Doc, error) {
	rows, err := db.Query("SELECT id, file_path, title, COALESCE(topic,'') FROM documentation ORDER BY id")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var docs []Doc
	for rows.Next() {
		var d Doc
		if err := rows.Scan(&d.ID, &d.FilePath, &d.Title, &d.Topic); err != nil {
			return nil, err
		}
		docs = append(docs, d)
	}
	return docs, nil
}

func (db *DB) GetChunkHashesForDoc(docID int) (map[int]string, error) {
	rows, err := db.Query("SELECT chunk_index, content_hash FROM doc_chunks WHERE doc_id = ?", docID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	hashes := make(map[int]string)
	for rows.Next() {
		var idx int
		var hash string
		if err := rows.Scan(&idx, &hash); err != nil {
			return nil, err
		}
		hashes[idx] = hash
	}
	return hashes, nil
}

func (db *DB) DeleteChunksForDoc(docID int) error {
	// Delete vectors first (referencing chunk IDs)
	_, err := db.Exec("DELETE FROM vec_chunks WHERE chunk_id IN (SELECT id FROM doc_chunks WHERE doc_id = ?)", docID)
	if err != nil {
		return fmt.Errorf("delete vectors: %w", err)
	}
	_, err = db.Exec("DELETE FROM doc_chunks WHERE doc_id = ?", docID)
	if err != nil {
		return fmt.Errorf("delete chunks: %w", err)
	}
	return nil
}

func (db *DB) InsertChunk(c Chunk) (int64, error) {
	res, err := db.Exec(
		"INSERT INTO doc_chunks (doc_id, chunk_index, heading, content, char_count, content_hash) VALUES (?, ?, ?, ?, ?, ?)",
		c.DocID, c.ChunkIndex, c.Heading, c.Content, c.CharCount, c.ContentHash,
	)
	if err != nil {
		return 0, err
	}
	return res.LastInsertId()
}

func (db *DB) InsertVector(chunkID int64, embedding []float32) error {
	embJSON, err := json.Marshal(embedding)
	if err != nil {
		return err
	}
	_, err = db.Exec("INSERT INTO vec_chunks (chunk_id, embedding) VALUES (?, ?)", chunkID, string(embJSON))
	return err
}

func (db *DB) SearchKNN(embedding []float32, limit int) ([]SearchResult, error) {
	embJSON, err := json.Marshal(embedding)
	if err != nil {
		return nil, err
	}
	query := `
		SELECT v.chunk_id, v.distance, c.heading, c.content, d.title, d.file_path
		FROM vec_chunks v
		JOIN doc_chunks c ON c.id = v.chunk_id
		JOIN documentation d ON d.id = c.doc_id
		WHERE v.embedding MATCH ?
		  AND k = ?
		ORDER BY v.distance
	`
	rows, err := db.Query(query, string(embJSON), limit)
	if err != nil {
		return nil, fmt.Errorf("knn search: %w", err)
	}
	defer rows.Close()
	var results []SearchResult
	for rows.Next() {
		var r SearchResult
		if err := rows.Scan(&r.ChunkID, &r.Distance, &r.Heading, &r.Content, &r.DocTitle, &r.FilePath); err != nil {
			return nil, err
		}
		results = append(results, r)
	}
	return results, nil
}

func (db *DB) UpsertKnowledge(topic, title, content, ktype, sourceURL, tags string) error {
	_, err := db.Exec(`
		INSERT INTO knowledge (topic, title, content, type, verified, source_url, tags)
		VALUES (?, ?, ?, ?, 1, ?, ?)
		ON CONFLICT DO NOTHING
	`, topic, title, content, ktype, sourceURL, tags)
	return err
}
