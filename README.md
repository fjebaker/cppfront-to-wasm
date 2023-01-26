# cppfront to WASM

This repository contains a tiny hello world example for compiling [cppfront](https://github.com/hsutter/cppfront) (aka C++ Syntax 2) to WASM, using clang or optionally [zig](https://ziglang.org/).

Requires that [cppfront](https://github.com/hsutter/cppfront) is in the path. The Makefile also needs to be modified at the top to point the include directory for cppfront to the right place.

## Setup (no zig)

Install LLVM via Homebrew and link
```bash
brew install llvm \
    && echo 'export PATH="$(brew --prefix)/opt/llvm/bin:$PATH"' >> ~/.zshrc \
    && source ~/.zshrc
```

Download releases from [WebAssembly/wasi-sdk](https://github.com/WebAssembly/wasi-sdk/releases): 
```bash
wget "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-19/wasi-sysroot-19.0.tar.gz" \
    && wget "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-19/libclang_rt.builtins-wasm32-wasi-19.0.tar.gz" \
    && tar xf wasi-sysroot-19.0.tar.gz \
    && tar xf libclang_rt.builtins-wasm32-wasi-19.0.tar.gz
```

Move the `lib/wasi` directory extracted to clang lib (note: versions may differ):

```bash
mv lib/wasi $(brew --prefix)/Cellar/llvm/15.0.7_1/lib/clang/15.0.7/lib/ \
    && rm -d lib
```

Then
```bash
make
```

Run it with [bytecodealliance/wasmtime](https://github.com/bytecodealliance/wasmtime):

```bash
wasmtime cart.wasm
# Hello world from cppfront!
```

## Cool and nice and fast with zig

Use Zig target (none of the above required, only needs zig in `PATH`):

```bash
make zig
```

## Recommended tools
- [WebAssembly/wabt](https://github.com/WebAssembly/wabt)
