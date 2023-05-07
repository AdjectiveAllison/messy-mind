package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/go-playground/validator/v10"
	"github.com/jhillyerd/enmime"
	"gopkg.in/yaml.v3"
)

type Config struct {
	TestEmail string `yaml:"test_email"`
}

type BlogPost struct {
	Title       string    `validate:"required,min=1,max=240"`
	Author      string    `validate:"required,min=1,max=100"`
	Description string    `validate:"required,min=1,max=1000"`
	Image       string    `validate:"omitempty,url"`               // can do uuid validator later on once testing more
	Categories  []string  `validate:"omitempty,dive,min=1,max=10"` // manually increased max limit to 10 here due to strange counting behavior with dive
	PublishDate time.Time `validate:"required"`
	EditedDate  time.Time
	WritingDate time.Time `validate:"required"`
	AiGenerated bool
	Tags        []string       `validate:"omitempty,dive,min=1,max=50"`
	Content     []ContentBlock `validate:"required,dive"`
	Source      string         `validate:"omitempty"`
}

type ContentBlock struct {
	Type       string       `validate:"required,oneof=text heading list"`
	Text       string       `omitempty,validate:"required_if=Type text"`
	Align      string       `validate:"required_if=Type text,oneof=left center right justify"`
	Formatting []Formatting `validate:omitempty` // empty is fine if we don't have any formatting
	NewLine    bool
	Level      int      `validate:"omitempty,required_if=Type heading,min=1,max=6"` // only for heading
	ListType   string   `validate:"omitempty,required_if=Type list,oneof=unordered ordered"`
	Items      []string `validate:"required_if=Type list"`
}

type Formatting struct {
	Type  string `validate:"oneof=blockquote codeblock raw media"`
	Start int    `validate:"omitempty,min=0"`
	End   int    `validate:"omitempty,min=0,gtfield=Start"`
	Style string `validate:"omitempty,oneof=bold italic underline strikethrough superscript subscript"`
	URL   string `validate:"omitempty,url"`
	// Add additional formatting properties here as needed
}

func (c *Config) populateConfig(filePath string) error {
	configData, err := os.ReadFile(filePath)
	if err != nil {
		fmt.Println(err)
	}
	err = yaml.Unmarshal(configData, c)
	if err != nil {
		return err
	}
	return nil
}

func readEmailFromFile(filePath string) (string, error) {
	emailBytes, err := ioutil.ReadFile(filePath)
	if err != nil {
		return "", err
	}
	return string(emailBytes), nil
}

func emailToRawHTML(rawEmail string) string {
	// Create an io.Reader from the raw email string
	emailReader := strings.NewReader(rawEmail)

	// Parse the email using enmime
	envelope, err := enmime.ReadEnvelope(emailReader)
	if err != nil {
		fmt.Println(err)
	}

	return envelope.HTML
}
func parseHTMLContent(htmlContent string) []ContentBlock {
	contentBlocks := []ContentBlock{}

	// Load the HTML content into goquery
	doc, err := goquery.NewDocumentFromReader(strings.NewReader(htmlContent))
	if err != nil {
		log.Fatal(err)
	}

	// Iterate through the HTML elements and extract the relevant information
	doc.Find("*").Each(func(i int, s *goquery.Selection) {
		block := ContentBlock{}

		// Extract text content within <div> and <li> tags
		if s.Is("div") {
			block.Type = "list"
			block.Text = s.Text()
		} else if s.Is("li") {
			block.Type = "text"
			block.Text = s.Text()
		}

		// Extract formatting tags: <b>, <u>, <i>
		formatting := []Formatting{}
		s.Contents().Each(func(j int, c *goquery.Selection) {
			if c.Is("b") || c.Is("u") || c.Is("i") {
				style := ""
				if c.Is("b") {
					style = "bold"
				} else if c.Is("u") {
					style = "underline"
				} else if c.Is("i") {
					style = "italic"
				}
				text := c.Text()
				startIndex := strings.Index(block.Text, text)
				endIndex := startIndex + len(text)
				formatting = append(formatting, Formatting{Type: "style", Start: startIndex, End: endIndex, Style: style})
			}
		})
		block.Formatting = formatting

		// Extract alignment styles
		textAlign, _ := s.Attr("style")
		if strings.Contains(textAlign, "text-align:center") {
			block.Align = "center"
		}
		if strings.Contains(textAlign, "text-align:right") {
			block.Align = "right"
		}
		if strings.Contains(textAlign, "text-align:left") {
			block.Align = "left"
		}

		// Extract hyperlinks within the text
		if s.Is("a") {
			href, _ := s.Attr("href")
			linkText := s.Text()
			startIndex := strings.Index(block.Text, linkText)
			endIndex := startIndex + len(linkText)
			block.Formatting = append(block.Formatting, Formatting{Type: "url", Start: startIndex, End: endIndex, URL: href})
		}

		if block.Type != "" {
			contentBlocks = append(contentBlocks, block)
		}
	})

	return contentBlocks
}

func main() {
	config := &Config{}
	config.populateConfig("config.yml")

	rawEmail, err := readEmailFromFile(config.TestEmail)
	if err != nil {
		log.Fatalf("Error reading email: %v", err)
	}

	htmlContent := emailToRawHTML(rawEmail)
	contentblockResults, err := json.Marshal(parseHTMLContent(htmlContent))
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(contentblockResults))

	return

	validate := validator.New()

	readEmailFromFile(config.TestEmail)
	poem := BlogPost{
		Title:       "A Sample Poem",
		Author:      "John Doe",
		Description: "A beautiful poem about nature.",
		Image:       "",
		Categories:  []string{"poetry", "literature"},
		PublishDate: time.Now(),
		EditedDate:  time.Time{},
		WritingDate: time.Now(),
		AiGenerated: false,
		Tags:        []string{"poem", "nature"},
		Source:      "email",
		Content: []ContentBlock{
			{
				Type:    "text",
				Text:    "In the forest, the trees are tall;",
				NewLine: true,
				Formatting: []Formatting{
					{
						Type: "raw",
					},
				},
			},
			{
				Type:    "text",
				Text:    "Where the wind whispers, I hear their call.",
				NewLine: true,
				Formatting: []Formatting{
					{
						Type: "raw",
					},
				},
			},
			{
				Type:    "text",
				Text:    "",
				NewLine: true,
			},
			{
				Type:    "text",
				Text:    "The sun sets, casting shadows wide;",
				NewLine: true,
				Formatting: []Formatting{
					{
						Type: "raw",
					},
				},
			},
			{
				Type:    "text",
				Text:    "In the quiet of the evening, nature is my guide.",
				NewLine: true,
				Formatting: []Formatting{
					{
						Type: "raw",
					},
				},
			},
		},
	}

	err = validate.Struct(poem)
	if err != nil {
		validationErrors := err.(validator.ValidationErrors)
		fmt.Println("Validation errors:", validationErrors)
	} else {
		fmt.Println("Poem object is valid")
	}

	jsonPoem, err := json.Marshal(poem)
	if err != nil {
		fmt.Println(err)
	}
	fmt.Println(string(jsonPoem))
}
