WASI_ROOT := ./wasi-sysroot
CPPFRONT_INCLUDE := -I../cppfront/include
HOMEBREW_PREFIX := $(brew --prefix)

LDFLAGS  := -L$(HOMEBREW_PREFIX)/opt/llvm/lib
INCLUDE := -I$(HOMEBREW_PREFIX)/opt/llvm/include

INCLUDE += $(CPPFRONT_INCLUDE)

CXXFLAGS := --target=wasm32-wasi --sysroot $(WASI_ROOT) \
	-W -Wall -Wextra -Werror -Wno-unused -Wconversion \
	-Wsign-conversion -std=c++20 # -MMD -MP -fno-exceptions

# tweak the needed library here (c++ or c or whatever else)
LDFLAGS += -Wl,-zstack-size=8192, -lstdc++
LDFLAGS += -Wl,--initial-memory=262144,--max-memory=262144,--global-base=98304
# LDFLAGS += --no-entry,--import-memory -mexec-model=reactor

OBJS := example.o

OBJECTS = $(foreach o, $(OBJS), build/$o)

main: $(OBJECTS)
	clang $(INCLUDE) $(CXXFLAGS) $(LDFLAGS) $(OBJECTS) -o cart.wasm

run: main
	wasmtime cart.wasm

build/%.o: build/%.cpp
	clang $(INCLUDE) $(CXXFLAGS) \
		-c $< -o $@

# keep intermediary files
.SECONDARY:
build/%.cpp: src/%.cpp2
	mkdir -p build
	cppfront $< -o $@

zig-run: zig
	wasmtime cart.wasm

zig:
	zig c++ --target=wasm32-wasi $(CPPFRONT_INCLUDE) -std=c++20 -shared -Os -o cart.wasm \
		build/example-cppfront.cpp

.PHONY: clean
clean:
	rm -rf build
	rm -f cart.wasm