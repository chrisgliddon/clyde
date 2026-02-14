package cmd

import (
	"fmt"
	"os"
	"path/filepath"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/clyde/clyde-cli/internal/chunker"
	"github.com/clyde/clyde-cli/internal/db"
	"github.com/clyde/clyde-cli/internal/embedder"
	"github.com/clyde/clyde-cli/internal/ui"
	"github.com/spf13/cobra"
	"golang.org/x/term"
)

var (
	forceReindex bool
	batchSize    int
)

var indexCmd = &cobra.Command{
	Use:   "index",
	Short: "Chunk docs, generate embeddings, store in DB",
	RunE:  runIndex,
}

func init() {
	indexCmd.Flags().BoolVar(&forceReindex, "force", false, "Force full rebuild")
	indexCmd.Flags().IntVar(&batchSize, "batch", 20, "Embedding batch size")
	rootCmd.AddCommand(indexCmd)
}

func runIndex(cmd *cobra.Command, args []string) error {
	d, err := db.Open(dbPath)
	if err != nil {
		return err
	}
	defer d.Close()

	if err := d.Migrate(); err != nil {
		return err
	}

	docs, err := d.ListDocs()
	if err != nil {
		return err
	}

	docsDir := filepath.Join(filepath.Dir(dbPath), "docs")
	emb := embedder.New("", "")

	// Use plain output if not a TTY
	if !term.IsTerminal(int(os.Stdout.Fd())) {
		return plainIndex(d, docsDir, docs, emb)
	}

	p := tea.NewProgram(ui.NewProgressModel())

	go func() {
		indexDocs(d, docsDir, docs, emb, func(msg tea.Msg) { p.Send(msg) })
	}()

	_, err = p.Run()
	return err
}

type sendFunc func(tea.Msg)

func indexDocs(d *db.DB, docsDir string, docs []db.Doc, emb *embedder.Client, send sendFunc) {
	totalChunks := 0
	skipped := 0
	errors := 0

	for i, doc := range docs {
		docFile := filepath.Join(docsDir, doc.FilePath)
		docName := filepath.Base(doc.FilePath)

		raw, err := os.ReadFile(docFile)
		if err != nil {
			send(ui.ErrMsg{Err: fmt.Errorf("%s: %w", docName, err)})
			errors++
			continue
		}

		fm, _ := chunker.ParseFrontMatter(string(raw))
		title := fm.Title
		if title == "" {
			title = doc.Title
		}

		chunks := chunker.ChunkDocument(title, string(raw))

		if !forceReindex && len(chunks) > 0 {
			existing, err := d.GetChunkHashesForDoc(doc.ID)
			if err == nil && len(existing) == len(chunks) {
				allMatch := true
				for _, c := range chunks {
					if h, ok := existing[c.Index]; !ok || h != c.Hash {
						allMatch = false
						break
					}
				}
				if allMatch {
					send(ui.ProgressMsg{
						Current: i + 1, Total: len(docs),
						DocName: docName, Skipped: true,
					})
					skipped++
					continue
				}
			}
		}

		if err := d.DeleteChunksForDoc(doc.ID); err != nil {
			send(ui.ErrMsg{Err: fmt.Errorf("%s delete: %w", docName, err)})
			errors++
			continue
		}

		var allEmbeddings [][]float32
		for j := 0; j < len(chunks); j += batchSize {
			end := j + batchSize
			if end > len(chunks) {
				end = len(chunks)
			}
			batch := make([]string, end-j)
			for k, c := range chunks[j:end] {
				batch[k] = c.Content
			}
			embeddings, err := emb.EmbedDocumentBatch(batch)
			if err != nil {
				send(ui.ErrMsg{Err: fmt.Errorf("%s embed: %w", docName, err)})
				errors++
				break
			}
			allEmbeddings = append(allEmbeddings, embeddings...)
		}

		if len(allEmbeddings) != len(chunks) {
			continue
		}

		for j, c := range chunks {
			chunkID, err := d.InsertChunk(db.Chunk{
				DocID: doc.ID, ChunkIndex: c.Index, Heading: c.Heading,
				Content: c.Content, CharCount: c.CharCount, ContentHash: c.Hash,
			})
			if err != nil {
				send(ui.ErrMsg{Err: fmt.Errorf("%s insert: %w", docName, err)})
				errors++
				break
			}
			if err := d.InsertVector(chunkID, allEmbeddings[j]); err != nil {
				send(ui.ErrMsg{Err: fmt.Errorf("%s vec: %w", docName, err)})
				errors++
				break
			}
		}

		totalChunks += len(chunks)
		send(ui.ProgressMsg{
			Current: i + 1, Total: len(docs),
			DocName: docName, Chunks: len(chunks),
		})
	}

	send(ui.DoneMsg{
		Total: len(docs), Chunks: totalChunks,
		Skipped: skipped, Errors: errors,
	})
}

func plainIndex(d *db.DB, docsDir string, docs []db.Doc, emb *embedder.Client) error {
	totalChunks := 0
	skipped := 0

	for i, doc := range docs {
		docFile := filepath.Join(docsDir, doc.FilePath)
		docName := filepath.Base(doc.FilePath)

		raw, err := os.ReadFile(docFile)
		if err != nil {
			fmt.Fprintf(os.Stderr, "  error: %s: %v\n", docName, err)
			continue
		}

		fm, _ := chunker.ParseFrontMatter(string(raw))
		title := fm.Title
		if title == "" {
			title = doc.Title
		}

		chunks := chunker.ChunkDocument(title, string(raw))

		if !forceReindex && len(chunks) > 0 {
			existing, err := d.GetChunkHashesForDoc(doc.ID)
			if err == nil && len(existing) == len(chunks) {
				allMatch := true
				for _, c := range chunks {
					if h, ok := existing[c.Index]; !ok || h != c.Hash {
						allMatch = false
						break
					}
				}
				if allMatch {
					fmt.Printf("[%d/%d] %s (skipped)\n", i+1, len(docs), docName)
					skipped++
					continue
				}
			}
		}

		d.DeleteChunksForDoc(doc.ID)

		var allEmbeddings [][]float32
		for j := 0; j < len(chunks); j += batchSize {
			end := j + batchSize
			if end > len(chunks) {
				end = len(chunks)
			}
			batch := make([]string, end-j)
			for k, c := range chunks[j:end] {
				batch[k] = c.Content
			}
			embeddings, err := emb.EmbedDocumentBatch(batch)
			if err != nil {
				fmt.Fprintf(os.Stderr, "  error: %s: %v\n", docName, err)
				break
			}
			allEmbeddings = append(allEmbeddings, embeddings...)
		}
		if len(allEmbeddings) != len(chunks) {
			continue
		}

		for j, c := range chunks {
			chunkID, err := d.InsertChunk(db.Chunk{
				DocID: doc.ID, ChunkIndex: c.Index, Heading: c.Heading,
				Content: c.Content, CharCount: c.CharCount, ContentHash: c.Hash,
			})
			if err != nil {
				break
			}
			d.InsertVector(chunkID, allEmbeddings[j])
		}

		totalChunks += len(chunks)
		fmt.Printf("[%d/%d] %s (%d chunks)\n", i+1, len(docs), docName, len(chunks))
	}

	fmt.Printf("\nDone! %d docs indexed (%d chunks), %d skipped\n", len(docs)-skipped, totalChunks, skipped)
	return nil
}
