package cmd

import (
	"fmt"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/clyde/clyde-cli/internal/db"
	"github.com/clyde/clyde-cli/internal/embedder"
	"github.com/clyde/clyde-cli/internal/ui"
	"github.com/spf13/cobra"
)

var (
	searchLimit int
	rawOutput   bool
)

var searchCmd = &cobra.Command{
	Use:   "search [query]",
	Short: "Semantic search across indexed docs",
	Args:  cobra.MinimumNArgs(1),
	RunE:  runSearch,
}

func init() {
	searchCmd.Flags().IntVar(&searchLimit, "limit", 10, "Max results")
	searchCmd.Flags().BoolVar(&rawOutput, "raw", false, "Plain text output")
	rootCmd.AddCommand(searchCmd)
}

func runSearch(cmd *cobra.Command, args []string) error {
	query := strings.Join(args, " ")

	d, err := db.Open(dbPath)
	if err != nil {
		return err
	}
	defer d.Close()

	emb := embedder.New("", "")
	queryVec, err := emb.EmbedQuery(query)
	if err != nil {
		return fmt.Errorf("embed query: %w", err)
	}

	results, err := d.SearchKNN(queryVec, searchLimit)
	if err != nil {
		return fmt.Errorf("search: %w", err)
	}

	if len(results) == 0 {
		fmt.Println("No results found.")
		return nil
	}

	if rawOutput {
		for i, r := range results {
			heading := r.Heading
			if heading == "" {
				heading = "(no heading)"
			}
			fmt.Printf("%d. [%.4f] %s — %s\n", i+1, r.Distance, r.DocTitle, heading)
			fmt.Println(r.Content)
			fmt.Println("---")
		}
		return nil
	}

	// Bubble Tea interactive UI
	uiResults := make([]ui.Result, len(results))
	for i, r := range results {
		uiResults[i] = ui.Result{
			ChunkID:  r.ChunkID,
			Distance: r.Distance,
			Heading:  r.Heading,
			Content:  r.Content,
			DocTitle: r.DocTitle,
			FilePath: r.FilePath,
		}
	}

	p := tea.NewProgram(ui.NewSearchModel(query, uiResults))
	_, err = p.Run()
	return err
}
