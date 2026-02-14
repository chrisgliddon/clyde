package ui

import (
	"fmt"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	titleStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("86")).Bold(true)
	headingStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("205"))
	distStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
	contentStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("252"))
	selectedStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("229")).Bold(true)
	helpStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
)

type Result struct {
	ChunkID  int
	Distance float64
	Heading  string
	Content  string
	DocTitle string
	FilePath string
}

type SearchModel struct {
	query    string
	results  []Result
	cursor   int
	expanded bool
}

func NewSearchModel(query string, results []Result) SearchModel {
	return SearchModel{query: query, results: results}
}

func (m SearchModel) Init() tea.Cmd {
	return nil
}

func (m SearchModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
				m.expanded = false
			}
		case "down", "j":
			if m.cursor < len(m.results)-1 {
				m.cursor++
				m.expanded = false
			}
		case "enter":
			m.expanded = !m.expanded
		}
	}
	return m, nil
}

func (m SearchModel) View() string {
	var b strings.Builder
	b.WriteString(titleStyle.Render(fmt.Sprintf("Search: %q (%d results)", m.query, len(m.results))))
	b.WriteString("\n\n")

	for i, r := range m.results {
		cursor := "  "
		style := contentStyle
		if i == m.cursor {
			cursor = "> "
			style = selectedStyle
		}

		heading := r.Heading
		if heading == "" {
			heading = "(no heading)"
		}

		line := fmt.Sprintf("%s%s %s %s",
			cursor,
			style.Render(fmt.Sprintf("%d.", i+1)),
			headingStyle.Render(heading),
			distStyle.Render(fmt.Sprintf("(%.4f)", r.Distance)),
		)
		b.WriteString(line + "\n")
		b.WriteString(fmt.Sprintf("   %s\n", distStyle.Render(r.DocTitle)))

		if i == m.cursor && m.expanded {
			b.WriteString("\n")
			// Show content, truncated to ~500 chars for display
			content := r.Content
			if len(content) > 500 {
				content = content[:500] + "..."
			}
			for _, line := range strings.Split(content, "\n") {
				b.WriteString("   " + contentStyle.Render(line) + "\n")
			}
			b.WriteString("\n")
		}
	}

	b.WriteString("\n")
	b.WriteString(helpStyle.Render("↑/↓ navigate • enter expand • q quit"))
	b.WriteString("\n")
	return b.String()
}
