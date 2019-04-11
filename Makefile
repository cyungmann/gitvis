.DEFAULT_GOAL := all

.PHONY: all
all: git.js
	

git/git.bc:
	cd git && \
	emmake make clean && \
	CPPFLAGS='-UHAVE_SYSINFO' CFLAGS='-s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emmake make configure && \
	CPPFLAGS='-UHAVE_SYSINFO' CFLAGS='-s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emconfigure ./configure CPPFLAGS='-UHAVE_SYSINFO' CFLAGS='-s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' && \
	CPPFLAGS='-UHAVE_SYSINFO' CFLAGS='-s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emmake make && \
	cp git git.bc

git.js: git/git.bc prologue.js
	emcc -s INVOKE_RUN=0 -s MODULARIZE=1 -s EXPORT_NAME=git -s USE_ZLIB=1 -UHAVE_SYSINFO -s EXPORTED_FUNCTIONS='["_main"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' --pre-js prologue.js git/git.bc -o git.js
