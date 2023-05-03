# Vosk Speech Recognition Transcription Tool

This tool uses the Vosk API to transcribe speech from WAV files. It processes multiple WAV files using different Vosk models concurrently, and outputs the transcriptions as JSON files. This README was generated with AI, look at nerd-dictation python repo or vosk-api for actual relevant information.

## Features

- Uses Vosk API for speech recognition
- Supports multiple Vosk models
- Transcribes multiple WAV files concurrently
- Outputs transcriptions as JSON files with timestamps

## Dependencies

- Vosk API: [github.com/alphacep/vosk-api/go](https://github.com/alphacep/vosk-api/go)

## Usage
1. Download any audio with speech. I used audacity to export to .ogg format and then ffmpeg to create a wav file with the right format: `ffmpeg -i test.ogg -acodec pcm_s16le -ac 1 -ar 16000 test.wav`
2. Configure the following paths in the `main` function:
   - `modelDir`: Directory containing Vosk models
   - `testDir`: Directory containing WAV files for transcription
   - `outputDir`: Directory for saving the output JSON files

3. Run the program:
`go run main.go`

## Output JSON Structure

The output JSON files will have the following structure:

```json
{
"source": "path/to/audio-file.wav",
"timestamp": "2023-05-03T14:30:00.000Z",
"content": {
 "parts": [
   "First part of the transcript",
   "Second part of the transcript",
   ...
 ],
 "time_stamps": [
   "2023-05-03 14:30:15.000",
   "2023-05-03 14:30:30.000",
   ...
 ],
 "full": "Full transcript (to be implemented)"
}
```

## Limitations

- Only supports WAV files
- Assumes a single speaker
- Requires Vosk models to be in separate directories
- Assumes a sample rate of 16000 Hz for the recognizer

## Future Improvements

- Support more audio formats
- Implement speaker recognition
- Improve error handling and input validation
- Allow custom sample rate configuration for the recognizer
- Implement a more robust method to detect and load Vosk models
- Add command line arguments for specifying directories and options
- Enhance the output JSON structure to include additional metadata, such as confidence scores
- Integrate a progress reporting mechanism for tracking the transcription process

## Contributing

Contributions to this project are welcome! If you'd like to help improve the code or add new features, please follow these steps:

1. Fork the repository
2. Create a new branch with a descriptive name for your changes
3. Make your changes in the new branch
4. Commit your changes with a clear and concise commit message
5. Push your changes to your forked repository
6. Create a pull request, describing the changes you've made and their benefits

We appreciate your help in making this tool better!

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). Please see the `LICENSE` file for more information.

## Acknowledgements

- [Vosk API](https://github.com/alphacep/vosk-api) for providing an open-source speech recognition library