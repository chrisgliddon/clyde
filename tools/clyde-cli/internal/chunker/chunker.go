package chunker

import (
	"crypto/sha256"
	"fmt"
	"regexp"
	"strings"

	"gopkg.in/yaml.v3"
)

var headingRe = regexp.MustCompile(`(?m)^(#{1,3})\s+(.+)$`)

type FrontMatter struct {
	Title string `yaml:"title"`
}

type Chunk struct {
	Index     int
	Heading   string
	Content   string
	CharCount int
	Hash      string
}

const (
	MaxChunkSize = 1500
	MinChunkSize = 100
)

func ChunkDocument(title, rawContent string) []Chunk {
	body := stripFrontMatter(rawContent)
	if strings.TrimSpace(body) == "" {
		return nil
	}

	sections := splitOnHeadings(body)
	var chunks []Chunk

	for _, sec := range sections {
		heading := sec.heading
		content := sec.content
		if strings.TrimSpace(content) == "" {
			continue
		}
		// Prepend context
		contextPrefix := fmt.Sprintf("Document: %s\n", title)
		if heading != "" {
			contextPrefix += fmt.Sprintf("Section: %s\n", heading)
		}
		contextPrefix += "\n"

		fullContent := contextPrefix + strings.TrimSpace(content)

		if len(fullContent) <= MaxChunkSize {
			chunks = append(chunks, Chunk{
				Heading:   heading,
				Content:   fullContent,
				CharCount: len(fullContent),
			})
		} else {
			// Split large sections at paragraph boundaries
			paras := splitParagraphs(strings.TrimSpace(content))
			// Further split any oversized paragraphs on single newlines
			paras = splitOversized(paras, MaxChunkSize-len(contextPrefix)-10)
			var buf strings.Builder
			buf.WriteString(contextPrefix)
			for _, p := range paras {
				if buf.Len()+len(p)+2 > MaxChunkSize && buf.Len() > len(contextPrefix) {
					chunks = append(chunks, Chunk{
						Heading:   heading,
						Content:   strings.TrimSpace(buf.String()),
						CharCount: buf.Len(),
					})
					buf.Reset()
					buf.WriteString(contextPrefix)
				}
				buf.WriteString(p)
				buf.WriteString("\n\n")
			}
			if buf.Len() > len(contextPrefix) {
				chunks = append(chunks, Chunk{
					Heading:   heading,
					Content:   strings.TrimSpace(buf.String()),
					CharCount: buf.Len(),
				})
			}
		}
	}

	// Merge small chunks with next
	chunks = mergeSmall(chunks)

	// Assign indexes and compute hashes
	for i := range chunks {
		chunks[i].Index = i
		chunks[i].Hash = hashContent(chunks[i].Content)
		chunks[i].CharCount = len(chunks[i].Content)
	}

	return chunks
}

func ParseFrontMatter(raw string) (FrontMatter, string) {
	var fm FrontMatter
	if !strings.HasPrefix(raw, "---\n") {
		return fm, raw
	}
	end := strings.Index(raw[4:], "\n---")
	if end < 0 {
		return fm, raw
	}
	yamlStr := raw[4 : 4+end]
	yaml.Unmarshal([]byte(yamlStr), &fm)
	body := raw[4+end+4:]
	return fm, body
}

func stripFrontMatter(raw string) string {
	_, body := ParseFrontMatter(raw)
	return body
}

type section struct {
	heading string
	content string
}

func splitOnHeadings(body string) []section {
	locs := headingRe.FindAllStringIndex(body, -1)
	if len(locs) == 0 {
		return []section{{content: body}}
	}

	var sections []section
	// Content before first heading
	if locs[0][0] > 0 {
		pre := body[:locs[0][0]]
		if strings.TrimSpace(pre) != "" {
			sections = append(sections, section{content: pre})
		}
	}

	for i, loc := range locs {
		match := headingRe.FindStringSubmatch(body[loc[0]:loc[1]])
		heading := ""
		if len(match) > 2 {
			heading = match[2]
		}
		var end int
		if i+1 < len(locs) {
			end = locs[i+1][0]
		} else {
			end = len(body)
		}
		content := body[loc[1]:end]
		sections = append(sections, section{heading: heading, content: content})
	}

	return sections
}

func splitParagraphs(text string) []string {
	parts := strings.Split(text, "\n\n")
	var result []string
	for _, p := range parts {
		p = strings.TrimSpace(p)
		if p != "" {
			result = append(result, p)
		}
	}
	return result
}

func splitOversized(paras []string, maxLen int) []string {
	var result []string
	for _, p := range paras {
		if len(p) <= maxLen {
			result = append(result, p)
			continue
		}
		// Split on single newlines first
		lines := strings.Split(p, "\n")
		var buf strings.Builder
		for _, line := range lines {
			// If a single line exceeds maxLen, hard-split it
			if len(line) > maxLen {
				if buf.Len() > 0 {
					result = append(result, strings.TrimSpace(buf.String()))
					buf.Reset()
				}
				for len(line) > maxLen {
					result = append(result, line[:maxLen])
					line = line[maxLen:]
				}
				if len(line) > 0 {
					buf.WriteString(line)
					buf.WriteString("\n")
				}
				continue
			}
			if buf.Len()+len(line)+1 > maxLen && buf.Len() > 0 {
				result = append(result, strings.TrimSpace(buf.String()))
				buf.Reset()
			}
			buf.WriteString(line)
			buf.WriteString("\n")
		}
		if buf.Len() > 0 {
			result = append(result, strings.TrimSpace(buf.String()))
		}
	}
	return result
}

func mergeSmall(chunks []Chunk) []Chunk {
	if len(chunks) <= 1 {
		return chunks
	}
	var result []Chunk
	for i := 0; i < len(chunks); i++ {
		c := chunks[i]
		if c.CharCount < MinChunkSize && i+1 < len(chunks) {
			// Merge with next chunk
			chunks[i+1].Content = c.Content + "\n\n" + chunks[i+1].Content
			chunks[i+1].CharCount = len(chunks[i+1].Content)
			if chunks[i+1].Heading == "" {
				chunks[i+1].Heading = c.Heading
			}
			continue
		}
		result = append(result, c)
	}
	return result
}

func hashContent(s string) string {
	h := sha256.Sum256([]byte(s))
	return fmt.Sprintf("%x", h)
}
