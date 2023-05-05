package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/go-playground/validator/v10"
)

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
}

type ContentBlock struct {
	Type       string     `validate:"required,oneof=text heading list"`
	Text       string     `omitempty,validate:"required_if=Type text"`
	Formatting Formatting `validate:"required_if=Type text"` // I think this should be a slice of formats and Alignment should move to the content block and outside of formatting
	NewLine    bool
	Level      int      `validate:"omitempty,required_if=Type heading,min=1,max=6"`
	ListType   string   `validate:"omitempty,required_if=Type list,oneof=unordered ordered"`
	Items      []string `validate:"required_if=Type list"`
}

type Formatting struct {
	Type  string `validate:"oneof=blockquote codeblock raw media"`
	Start int    `validate:"omitempty,min=0"`
	End   int    `validate:"omitempty,min=0,gtfield=Start"`
	Style string `validate:"omitempty,oneof=bold italic underline strikethrough superscript subscript"`
	Align string `validate:"required_if=Type raw,oneof=left center right justify"` // need a way to handle blank text better/just a new line or formatting section
	URL   string `validate:"omitempty,url"`
	// Add additional formatting properties here as needed
}

func main() {
	validate := validator.New()

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
		Content: []ContentBlock{
			{
				Type:    "text",
				Text:    "In the forest, the trees are tall;",
				NewLine: true,
				Formatting: Formatting{
					Type:  "raw",
					Align: "center",
				},
			},
			{
				Type:    "text",
				Text:    "Where the wind whispers, I hear their call.",
				NewLine: true,
				Formatting: Formatting{
					Type:  "raw",
					Align: "center",
				},
			},
			{
				Type:       "text",
				Text:       "",
				Formatting: Formatting{Type: "raw", Align: "center"},
				NewLine:    true,
			},
			{
				Type:    "text",
				Text:    "The sun sets, casting shadows wide;",
				NewLine: true,
				Formatting: Formatting{
					Type:  "raw",
					Align: "center",
				},
			},
			{
				Type:    "text",
				Text:    "In the quiet of the evening, nature is my guide.",
				NewLine: true,
				Formatting: Formatting{
					Type:  "raw",
					Align: "center",
				},
			},
		},
	}

	err := validate.Struct(poem)
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
