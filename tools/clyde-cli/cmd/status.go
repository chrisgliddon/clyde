package cmd

import (
	"fmt"

	"github.com/charmbracelet/lipgloss"
	"github.com/clyde/clyde-cli/internal/db"
	"github.com/spf13/cobra"
)

var (
	labelStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("86")).Width(20)
	valueStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
	headerSty  = lipgloss.NewStyle().Foreground(lipgloss.Color("205")).Bold(true)
)

var statusCmd = &cobra.Command{
	Use:   "status",
	Short: "Show database stats",
	RunE: func(cmd *cobra.Command, args []string) error {
		d, err := db.Open(dbPath)
		if err != nil {
			return err
		}
		defer d.Close()

		if err := d.Migrate(); err != nil {
			return err
		}

		stats, err := d.GetStats()
		if err != nil {
			return err
		}

		fmt.Println(headerSty.Render("Clyde DB Status"))
		fmt.Println()
		row := func(label string, value any) {
			fmt.Printf("%s %s\n", labelStyle.Render(label+":"), valueStyle.Render(fmt.Sprint(value)))
		}
		row("Documents", stats.DocCount)
		row("Chunks", stats.ChunkCount)
		row("Vectors", stats.VecCount)
		row("Knowledge", stats.KnowledgeCount)
		row("Code Registry", stats.CodeRegCount)
		row("DB Size", formatBytes(stats.DBSizeBytes))
		row("Embedding Model", "nomic-embed-text (768d)")
		return nil
	},
}

func formatBytes(b int64) string {
	const unit = 1024
	if b < unit {
		return fmt.Sprintf("%d B", b)
	}
	div, exp := int64(unit), 0
	for n := b / unit; n >= unit; n /= unit {
		div *= unit
		exp++
	}
	return fmt.Sprintf("%.1f %cB", float64(b)/float64(div), "KMGTPE"[exp])
}

func init() {
	rootCmd.AddCommand(statusCmd)
}
