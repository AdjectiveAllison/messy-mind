package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"
	"sync"
	"time"

	vosk "github.com/alphacep/vosk-api/go"
)

type Transcription struct {
	Source    string            `json:"source"`
	Timestamp time.Time         `json:"timestamp"`
	Content   TranscriptContent `json:"content"`
}

type TranscriptContent struct {
	Parts      []string `json:"parts"`
	TimeStamps []string `json:"time_stamps"`
	Full       string   `json:"full"`
}

type ModelData struct {
	Path string
	Name string
}

type TestAudio struct {
	Path string
	Name string
}

func parseOutText(transcript string) string {
	var result map[string]interface{}
	err := json.Unmarshal([]byte(transcript), &result)
	if err != nil {
		fmt.Println("Error unmarshalling JSON:", err)
	}

	if text, ok := result["text"].(string); ok {
		return text
	} else {
		return ""
	}
}

func getModelList(modelDir string) []ModelData {
	modelList, err := ioutil.ReadDir(modelDir)
	if err != nil {
		fmt.Println(err)
	}

	models := make([]ModelData, 0, len(modelList)) // this breaks if I put something else in the directory other than a model -- don't do this

	for _, model := range modelList {
		if model.IsDir() {
			models = append(models, ModelData{Path: strings.Join([]string{modelDir, model.Name()}, "/"), Name: model.Name()})
		}
	}
	return models
}
func getTestAudioList(testDir string) []TestAudio {
	testDirList, err := ioutil.ReadDir(testDir)

	if err != nil {
		fmt.Println(err)
	}
	testAudios := make([]TestAudio, 0)

	for _, file := range testDirList {
		if strings.HasSuffix(file.Name(), "wav") {
			testAudios = append(testAudios, TestAudio{Path: strings.Join([]string{testDir, file.Name()}, "/"), Name: file.Name()})
		}
	}
	if len(testAudios) == 0 {
		fmt.Println("you broke something with your test files and you kinda suck, not hate tho")
	}

	return testAudios
}

func transcribeTest(audio TestAudio, model ModelData, outputDir string) {
	//Use vosk new speaker recognizer to detect language being spoken

	voskModel, err := vosk.NewModel(model.Path)

	if err != nil {
		fmt.Println(err)
	}
	recognizer, err := vosk.NewRecognizer(voskModel, 16000)
	if err != nil {
		fmt.Println(err)
	}

	fileName := audio.Path
	outputFile, err := os.Create(fmt.Sprintf("%s/%s-%s.json", outputDir, audio.Name, model.Name))
	if err != nil {
		fmt.Println(err)
	}
	transcript := &Transcription{Source: fileName, Timestamp: time.Now()}

	file, err := os.Open(fileName)
	if err != nil {
		fmt.Println(err)
	}
	defer file.Close()

	reader := bufio.NewReader(file)
	buf := make([]byte, 4096)

	//cmd := exec.Command("update_task", fmt.Sprintf("Transcribing Dev Agrawal youtube audio for the %d time while I go for a walk", i))
	//cmd.Output()
	//i := 0
	for {
		//fmt.Printf("Iteration in for loop: %d\n", i)
		_, err := reader.Read(buf)
		//fmt.Printf("%d number of bytes read from %s\n", bytesRead, fileName)
		if err != nil {
			if err != io.EOF {
				fmt.Println(err)
			}

			break
		}
		if recognizer.AcceptWaveform(buf) != 0 {
			fmt.Println("part of transcript added to content")
			text := parseOutText(recognizer.Result())

			transcript.Content.Parts = append(transcript.Content.Parts, text)
			currentTime := time.Now()
			formattedTime := currentTime.Format("2006-01-02 15:04:05.000")
			transcript.Content.TimeStamps = append(transcript.Content.TimeStamps, formattedTime)

			//fmt.Printf("%s - %s\n", formattedTime, recognizer.Result())
		}
		//currentTime := time.Now()
		//formattedTime := currentTime.Format("2006-01-02 15:04:05.000")
		//fmt.Printf("%s - %s\n", formattedTime, recognizer.PartialResult())
		//fmt.Printf("%s -- Regular result: %s\n", formattedTime, recognizer.Result())
		//fmt.Printf("%s -- Final result: %s\n", formattedTime, recognizer.FinalResult())
		//i++
	}

	transcript.Content.Parts = append(transcript.Content.Parts, parseOutText(recognizer.FinalResult()))

	currentTime := time.Now()
	formattedTime := currentTime.Format("2006-01-02 15:04:05.000")
	transcript.Content.TimeStamps = append(transcript.Content.TimeStamps, formattedTime)

	jsonTranscript, err := json.Marshal(transcript)
	if err != nil {
		fmt.Println(err)
	}

	io.WriteString(outputFile, string(jsonTranscript))
	//currentTime := time.Now()
	//formattedTime := currentTime.Format("2006-01-02 15:04:05.000")
	//fmt.Printf("%s -- Final result: %s\n", formattedTime, recognizer.FinalResult())

}

func main() {
	//fastTest()
	//return
	concurrencyLimit := 4
	modelDir := "/path/to/models"
	testDir := "/path/to/wav/files/for/testing"
	outputDir := "/path/to/output/Dir"

	modelList := getModelList(modelDir)
	testAudioList := getTestAudioList(testDir)

	// Create a buffered channel to control the number of concurrent tasks
	sem := make(chan struct{}, concurrencyLimit)
	// Create a wait group to wait for all goroutines to finish
	var wg sync.WaitGroup

	for _, model := range modelList {
		for _, audio := range testAudioList {

			// Acquire a spot in the semaphore
			sem <- struct{}{}
			// Increment the wait group counter
			wg.Add(1)

			// Launch a new goroutine to transcribe the test
			go func(audio TestAudio, model ModelData, outputDir string) {
				defer func() {
					// Release the spot in the semaphore
					<-sem
					// Decrement the wait group counter
					wg.Done()
				}()

				transcribeTest(audio, model, outputDir)
			}(audio, model, outputDir)
		}
	}

	// Wait for all goroutines to finish
	wg.Wait()
}
