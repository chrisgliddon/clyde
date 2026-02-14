package ui

import (
	"fmt"

	"github.com/charmbracelet/bubbles/spinner"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var (
	spinnerStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("205"))
	docStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("86"))
	countStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
	doneStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("82")).Bold(true)
	errStyle     = lipgloss.NewStyle().Foreground(lipgloss.Color("196"))
)

type ProgressMsg struct {
	Current  int
	Total    int
	DocName  string
	Chunks   int
	Skipped  bool
}

type DoneMsg struct {
	Total   int
	Chunks  int
	Skipped int
	Errors  int
}

type ErrMsg struct {
	Err error
}

type ProgressModel struct {
	spinner  spinner.Model
	current  int
	total    int
	docName  string
	chunks   int
	skipped  bool
	done     bool
	result   DoneMsg
	lastErr  string
}

func NewProgressModel() ProgressModel {
	s := spinner.New()
	s.Spinner = spinner.Dot
	s.Style = spinnerStyle
	return ProgressModel{spinner: s}
}

func (m ProgressModel) Init() tea.Cmd {
	return m.spinner.Tick
}

func (m ProgressModel) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		if msg.String() == "q" || msg.String() == "ctrl+c" {
			return m, tea.Quit
		}
	case ProgressMsg:
		m.current = msg.Current
		m.total = msg.Total
		m.docName = msg.DocName
		m.chunks = msg.Chunks
		m.skipped = msg.Skipped
		return m, nil
	case DoneMsg:
		m.done = true
		m.result = msg
		return m, tea.Quit
	case ErrMsg:
		m.lastErr = msg.Err.Error()
		return m, nil
	case spinner.TickMsg:
		var cmd tea.Cmd
		m.spinner, cmd = m.spinner.Update(msg)
		return m, cmd
	}
	return m, nil
}

func (m ProgressModel) View() string {
	if m.done {
		return doneStyle.Render(fmt.Sprintf(
			"Done! %d docs indexed (%d chunks), %d skipped, %d errors\n",
			m.result.Total-m.result.Skipped, m.result.Chunks, m.result.Skipped, m.result.Errors,
		))
	}

	status := ""
	if m.skipped {
		status = countStyle.Render(" (unchanged, skipped)")
	} else if m.chunks > 0 {
		status = countStyle.Render(fmt.Sprintf(" (%d chunks)", m.chunks))
	}

	s := fmt.Sprintf("%s %s %s%s",
		m.spinner.View(),
		countStyle.Render(fmt.Sprintf("[%d/%d]", m.current, m.total)),
		docStyle.Render(m.docName),
		status,
	)
	if m.lastErr != "" {
		s += "\n" + errStyle.Render("  error: "+m.lastErr)
	}
	return s + "\n"
}
