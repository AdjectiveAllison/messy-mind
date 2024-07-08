# WebView Zig Project

## Overview

This project demonstrates the use of WebView in Zig to create cross-platform desktop applications with web technologies. It combines a local file server with a WebView to serve and display web content securely.

## Key Features

1. **Local File Server**: Serves files from a 'web' directory, allowing for secure content delivery.
2. **WebView Integration**: Displays the local server's content in a native window.
3. **Cross-Platform Compatibility**: Targets Windows, Linux, and macOS.
4. **Two-Way Communication**: Enables interaction between Zig backend and JavaScript frontend.
5. **Logging System**: Comprehensive logging for debugging and development purposes.

## Why WebView in Zig?

Zig's ability to easily import and interact with C and C++ libraries makes it an excellent choice for creating desktop applications with WebView. This approach allows developers to:

- Write backend code in Zig, leveraging its performance and safety features.
- Use familiar web technologies (HTML, CSS, JavaScript) for the frontend.
- Create fast, native desktop applications for multiple platforms.
- Avoid security issues associated with manual HTML setting or JavaScript evaluation by serving content from a local directory.

## Project Structure

```
├── README.md
├── build.zig
├── build.zig.zon
├── src
│   ├── file_server.zig
│   ├── main.zig
│   └── webview.zig
└── web
    └── index.html
```

## Setup and Running

1. Ensure Zig is installed on your system. Visit [ziglearn.org](https://ziglearn.org/) for installation instructions.
2. Clone this repository.
3. Navigate to the project directory.
4. Run the following command:
   ```
   zig build run
   ```

## Development Notes

- The project uses [webview](https://github.com/thechampagne/webview-zig) for WebView functionality and [httpz](https://github.com/karlseguin/http.zig) for the local server.
- Extensive logging is implemented throughout the application. While this is useful for development, it may be optimized for production use.
- The `web` directory contains the frontend files served by the local file server.

## Future Improvements

- Optimize logging for production environments.
- Enhance error handling and user feedback.
- Implement more complex interactions between Zig and JavaScript.
- Explore additional WebView features and capabilities.
