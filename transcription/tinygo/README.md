# Tinygo attempts at vosk transcription in-browser

## Notes
* I wanted to do the same thing as vosk transcription in golang above but with tinygo and run it in the browser.
* I learned a lot about how much I didn't understand web assembly or compilers. 
* wasm_exec.js (the tinygo version) isn't committed because it had a copyright. You'll need that. I think you can find it in variuos places including syumyai/workers-go
* It looks like I likely did this on June 17th and June 20th. twitch vods are probably avaiable for this research.

```
grep -r "vosk"
```

### stream/06/20/plans.txt:
```
Figure out how to get vosk compiled into wasix and then how to interact with it. (...)
```
### stream/06/20/notes.txt:
```
Working on web assembly vosk and wasix wasmer
---
https://alphacephei.com/vosk/install -- compile from source instructions
---
https://github.com/alphacep/vosk-server/tree/master -- Not super relevant, primarily just python implementation of several types of server protocols
---
https://github.com/alphacep/vosk-api/blob/master/src/Makefile -- Idk why this is important.
---
https://github.com/alphacep/vosk-server/blob/master/docker/Dockerfile.kaldi-vosk-server -- idk why this one is either
---
https://github.com/alphacep/vosk-server/blob/master/docker/Dockerfile.kaldi-vosk-server-gpu -- alternative to above
---
I ended up browsing some of the repositories that utilize vosk-browser and landed at https://github.com/Rodeoclash/captioner which is hosted at https://captioner.richardson.co.nz/
---
It uses an upload video feature and then transcribes. Vosk in a single thread(using enscriptem) was rather slow. I realized I needed to ensure wasix multi threading worked in a local browser execution environment before spending time attemtping to port vosk over as that would be the biggest performance stopping problem if it didn't work. 
```

### stream/06/17/notes.txt:
```
I think it may be possible to do vosk in web assembly in a better way than empscripten and cross assembly javascript calling via the https://netlib.org/clapack/ compiled version. the documents are here: https://github.com/kaldi-asr/kaldi And it says it's an alternative.
---
https://github.com/ccoreilly/vosk-browser
```

## Feel free to reach out if you have questions. My nonsensical notes are just he intro in how much I learned.
* I remember now that multi threading is possible with empscripten but requires certain security settings. I suspect that the captioner by Rodeoclash approach would be solid if properly multithreaded. 
