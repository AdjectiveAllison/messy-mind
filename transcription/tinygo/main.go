package main

import (
	"fmt"
	"syscall/js"
)

func sayHi() string {
	return "Hello. this is cool code."
}

func testCallBack() {

}
func main() {
	fmt.Println("heyo")
	js.Global().Set("sayHi", sayHi())
	vosk := js.Global().Get("Vosk")
	fmt.Println("testing")
	if !vosk.IsUndefined() {
		model := vosk.Call("createModel", "model.tar.gz")

		if !model.IsUndefined() {

			fmt.Println("model is here")
			//model.Get("KaldiRecognizer").New(16000) // second parameter is grammer and idk if I need it or not but I suspect I don't. - https://github.com/ccoreilly/vosk-browser/blob/adf09505c686e1be31dd3bcf1e1ab7604c27b4b9/examples/words-vanilla/index.js#LL22C85-L22C85

			//buffer := make([]byte, 4096)
			//js.Global().Get("fs").Call("readFile", "test.wav", buffer)

			//fmt.Println(buffer)
			/* 			//recognizer.Call("acceptWaveForm", buffer)
			   			// The following is a sketch, it may not work as-is because the js.FuncOf call requires a function that matches its signature exactly.
			   			resultFunc := js.FuncOf(func(this js.Value, args []js.Value) interface{} {
			   				// Assuming args[0] is the event object
			   				event := args[0]
			   				result := event.Get("result")
			   				if !result.IsUndefined() {
			   					text := result.Get("text")
			   					if !text.IsUndefined() {
			   						fmt.Println(text.String())
			   					}
			   				}
			   				return nil
			   			})

			   			recognizer.Call("on", "result", resultFunc)
			   			resultFunc.Release() */
		} else {
			fmt.Println("model is undefined")
		}
	} else {
		fmt.Println("Vosk is undefined")
	}

	<-make(chan bool)
}
