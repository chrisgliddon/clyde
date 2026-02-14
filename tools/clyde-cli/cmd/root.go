package cmd

import (
	"github.com/spf13/cobra"
)

var dbPath string

var rootCmd = &cobra.Command{
	Use:   "clyde",
	Short: "Clyde project brain CLI — chunk, embed, search SNES docs",
}

func init() {
	rootCmd.PersistentFlags().StringVar(&dbPath, "db", "clyde.db", "Path to clyde.db")
}

func Execute() error {
	return rootCmd.Execute()
}
