package cmd

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/clyde/clyde-cli/internal/chunker"
	"github.com/clyde/clyde-cli/internal/db"
	"github.com/spf13/cobra"
)

var (
	registerRe = regexp.MustCompile(`\$([0-9A-Fa-f]{4})\b`)
	opcodeRe   = regexp.MustCompile(`(?i)\b(ADC|AND|ASL|BCC|BCS|BEQ|BIT|BMI|BNE|BPL|BRA|BRK|BRL|BVC|BVS|CLC|CLD|CLI|CLV|CMP|COP|CPX|CPY|DEC|DEX|DEY|EOR|INC|INX|INY|JML|JMP|JSL|JSR|LDA|LDX|LDY|LSR|MVN|MVP|NOP|ORA|PEA|PEI|PER|PHA|PHB|PHD|PHK|PHP|PHX|PHY|PLA|PLB|PLD|PLP|PLX|PLY|REP|ROL|ROR|RTI|RTL|RTS|SBC|SEC|SED|SEI|SEP|STA|STP|STX|STY|STZ|TAX|TAY|TCD|TCS|TDC|TSC|TSX|TXA|TXS|TXY|TYA|TYX|WAI|WDM|XBA|XCE)\b`)
	warningRe  = regexp.MustCompile(`(?i)(warning|caution|gotcha|careful|important|note that|be aware|don't forget|must not|never)`)
)

var knowledgeCmd = &cobra.Command{
	Use:   "knowledge",
	Short: "Extract SNES/65816 facts from docs",
	RunE:  runKnowledge,
}

func init() {
	rootCmd.AddCommand(knowledgeCmd)
}

func runKnowledge(cmd *cobra.Command, args []string) error {
	d, err := db.Open(dbPath)
	if err != nil {
		return err
	}
	defer d.Close()

	docs, err := d.ListDocs()
	if err != nil {
		return err
	}

	docsDir := filepath.Join(filepath.Dir(dbPath), "docs")
	extracted := 0

	for _, doc := range docs {
		docFile := filepath.Join(docsDir, doc.FilePath)
		raw, err := os.ReadFile(docFile)
		if err != nil {
			continue
		}

		fm, body := chunker.ParseFrontMatter(string(raw))
		title := fm.Title
		if title == "" {
			title = doc.Title
		}

		paragraphs := strings.Split(body, "\n\n")
		for _, para := range paragraphs {
			para = strings.TrimSpace(para)
			if len(para) < 50 {
				continue
			}

			// Extract hardware register references
			if registerRe.MatchString(para) && len(para) < 1000 {
				regs := registerRe.FindAllString(para, -1)
				topic := "SNES Hardware"
				kTitle := fmt.Sprintf("Register %s usage", strings.Join(unique(regs), ", "))
				tags := strings.Join(unique(regs), ",")
				if err := d.UpsertKnowledge(topic, kTitle, para, "fact", doc.FilePath, tags); err == nil {
					extracted++
				}
			}

			// Extract warnings/gotchas
			if warningRe.MatchString(para) && len(para) < 1000 {
				topic := topicFromDoc(title)
				kTitle := truncate("Warning: "+firstSentence(para), 100)
				if err := d.UpsertKnowledge(topic, kTitle, para, "warning", doc.FilePath, "warning"); err == nil {
					extracted++
				}
			}
		}

		// Extract code blocks with context
		codeBlocks := extractCodeBlocks(body)
		for _, cb := range codeBlocks {
			if opcodeRe.MatchString(cb.code) && len(cb.code) > 20 {
				topic := topicFromDoc(title)
				kTitle := truncate("Code: "+cb.context, 100)
				if err := d.UpsertKnowledge(topic, kTitle, cb.code, "pattern", doc.FilePath, "assembly,code"); err == nil {
					extracted++
				}
			}
		}
	}

	fmt.Printf("Extracted %d knowledge entries from %d docs\n", extracted, len(docs))
	return nil
}

type codeBlock struct {
	context string
	code    string
}

func extractCodeBlocks(body string) []codeBlock {
	var blocks []codeBlock
	lines := strings.Split(body, "\n")
	inBlock := false
	var code strings.Builder
	var context string

	for i, line := range lines {
		if strings.HasPrefix(line, "```") {
			if inBlock {
				blocks = append(blocks, codeBlock{context: context, code: code.String()})
				code.Reset()
				inBlock = false
			} else {
				inBlock = true
				// Use previous non-empty line as context
				for j := i - 1; j >= 0 && j >= i-3; j-- {
					if strings.TrimSpace(lines[j]) != "" {
						context = strings.TrimSpace(lines[j])
						break
					}
				}
			}
			continue
		}
		if inBlock {
			code.WriteString(line)
			code.WriteString("\n")
		}
	}
	return blocks
}

func topicFromDoc(title string) string {
	t := strings.ToLower(title)
	switch {
	case strings.Contains(t, "dma"):
		return "SNES DMA"
	case strings.Contains(t, "spc700") || strings.Contains(t, "audio"):
		return "SPC700 Audio"
	case strings.Contains(t, "sprite") || strings.Contains(t, "graphic") || strings.Contains(t, "ppu"):
		return "SNES Graphics"
	case strings.Contains(t, "65816") || strings.Contains(t, "65c816") || strings.Contains(t, "assembly"):
		return "65816 CPU"
	case strings.Contains(t, "memory") || strings.Contains(t, "addressing"):
		return "SNES Memory"
	case strings.Contains(t, "register"):
		return "SNES Hardware"
	case strings.Contains(t, "init"):
		return "SNES Initialization"
	default:
		return "SNES Programming"
	}
}

func firstSentence(s string) string {
	for i, c := range s {
		if c == '.' && i > 10 {
			return s[:i+1]
		}
	}
	if len(s) > 100 {
		return s[:100]
	}
	return s
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n-3] + "..."
}

func unique(ss []string) []string {
	seen := make(map[string]bool)
	var result []string
	for _, s := range ss {
		if !seen[s] {
			seen[s] = true
			result = append(result, s)
		}
	}
	return result
}
