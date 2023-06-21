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

## Running

1. Execute wasmer
```bash
wasmer build/thread_test.wasm 
```

2. Get output with multiple threads from web asembly!!!

```
-----Testing with 4 threads-----
Creating thread 0
Creating thread 1
Creating thread 2
Creating thread 3
Thread #3, counter value: 0
Thread #1, counter value: 0
Thread #0, counter value: 0
Thread #2, counter value: 0
Thread #1, counter value: 1
Thread #3, counter value: 1
Thread #2, counter value: 1
Thread #0, counter value: 1
```
## Future

TBD
