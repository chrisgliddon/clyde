package embedder

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

const DefaultModel = "nomic-embed-text"

type Client struct {
	BaseURL string
	Model   string
}

func New(baseURL, model string) *Client {
	if baseURL == "" {
		baseURL = "http://localhost:11434"
	}
	if model == "" {
		model = DefaultModel
	}
	return &Client{BaseURL: baseURL, Model: model}
}

type embedRequest struct {
	Model string   `json:"model"`
	Input []string `json:"input"`
}

type embedResponse struct {
	Embeddings [][]float32 `json:"embeddings"`
}

// Embed returns embeddings for the given texts.
// For documents, prefix with "search_document: "
// For queries, prefix with "search_query: "
func (c *Client) Embed(texts []string) ([][]float32, error) {
	reqBody := embedRequest{
		Model: c.Model,
		Input: texts,
	}
	body, err := json.Marshal(reqBody)
	if err != nil {
		return nil, err
	}
	resp, err := http.Post(c.BaseURL+"/api/embed", "application/json", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("ollama request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		b, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("ollama error %d: %s", resp.StatusCode, string(b))
	}

	var result embedResponse
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return nil, fmt.Errorf("decode response: %w", err)
	}
	return result.Embeddings, nil
}

// EmbedDocument embeds a single document text with the search_document prefix.
func (c *Client) EmbedDocument(text string) ([]float32, error) {
	embs, err := c.Embed([]string{"search_document: " + text})
	if err != nil {
		return nil, err
	}
	if len(embs) == 0 {
		return nil, fmt.Errorf("no embedding returned")
	}
	return embs[0], nil
}

// EmbedQuery embeds a query text with the search_query prefix.
func (c *Client) EmbedQuery(text string) ([]float32, error) {
	embs, err := c.Embed([]string{"search_query: " + text})
	if err != nil {
		return nil, err
	}
	if len(embs) == 0 {
		return nil, fmt.Errorf("no embedding returned")
	}
	return embs[0], nil
}

// EmbedDocumentBatch embeds multiple documents with the search_document prefix.
func (c *Client) EmbedDocumentBatch(texts []string) ([][]float32, error) {
	prefixed := make([]string, len(texts))
	for i, t := range texts {
		prefixed[i] = "search_document: " + t
	}
	return c.Embed(prefixed)
}
