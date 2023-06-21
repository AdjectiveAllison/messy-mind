# WASIX Threads Testing

This repository contains a sample application that demonstrates the use of threads in WebAssembly using the Wasix and Wasmer runtime. The code is written in C and is compiled to WebAssembly using the Wasi SDK.

## Content Overview

The main contents of the repository include:

- `thread_test.c`: A C program that creates up to four threads and prints a message from each thread. This code is used to test the threading capabilities of WebAssembly.
- `Makefile`: Contains instructions to compile the `thread_test.c` to WebAssembly using the Wasix and Wasmer runtime.

## Compilation

The program can be compiled using the provided Makefile. Before compilation, please ensure you have the following environment variables set:

```bash
export SYSROOT=/usr/share/wasix-sysroot
export CC=/opt/wasi-sdk/bin/clang
export LLD_PATH=/opt/wasi-sdk/bin/lld
```

To compile, simply run:
```bash
make
```

This will generate a WebAssembly module in the build directory.

## Future

TBD
