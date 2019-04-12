.DEFAULT_GOAL := all

.PHONY: all
all: git.js
	

.PHONY: distclean
distclean:
	rm -f git/git git.bc git.js
	cd git && \
	emmake make distclean

.PHONY: clean
clean:
	rm -f git/git git.bc git.js
	cd git && \
	emmake make clean

git/git: $(wildcard git/*.c) $(wildcard git/*.h) git/Makefile
	cd git && \
	NO_SETITIMER=1 CPPFLAGS='-UHAVE_SYSINFO -DNO_SETITIMER' CFLAGS='-g4 -s ASSERTIONS=2 -s RUNTIME_LOGGING=1 -s EXCEPTION_DEBUG=1 -s ALIASING_FUNCTION_POINTERS=0 -s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emmake make configure -j9 NO_SETITIMER=1 && \
	NO_SETITIMER=1 CPPFLAGS='-UHAVE_SYSINFO -DNO_SETITIMER' CFLAGS='-g4 -s ASSERTIONS=2 -s RUNTIME_LOGGING=1 -s EXCEPTION_DEBUG=1 -s ALIASING_FUNCTION_POINTERS=0 -s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emconfigure ./configure NO_SETITIMER=1 CPPFLAGS='-UHAVE_SYSINFO -DNO_SETITIMER' CFLAGS='-g4 -s ASSERTIONS=2 -s RUNTIME_LOGGING=1 -s EXCEPTION_DEBUG=1 -s ALIASING_FUNCTION_POINTERS=0 -s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' && \
	NO_SETITIMER=1 EMCC_DEBUG=2 CPPFLAGS='-UHAVE_SYSINFO -DNO_SETITIMER' CFLAGS='-g4 -s ASSERTIONS=2 -s RUNTIME_LOGGING=1 -s EXCEPTION_DEBUG=1 -s ALIASING_FUNCTION_POINTERS=0 -s USE_ZLIB=1 -UHAVE_SYSINFO' LDFLAGS='-s USE_ZLIB=1' emmake make -j9 NO_SETITIMER=1

git.bc: git/git
	cp git/git $@

git.js: git.bc prologue.js
	EMCC_DEBUG=2 emcc -g4 -s INVOKE_RUN=0 -s MODULARIZE=1 -s EXPORT_NAME=git -s ASSERTIONS=2 -s RUNTIME_LOGGING=1 -s EXCEPTION_DEBUG=1 -s ALIASING_FUNCTION_POINTERS=0 --js-opts 0 -s USE_ZLIB=1 -UHAVE_SYSINFO -DNO_SETITIMER -s EXPORTED_FUNCTIONS='["_main"]' -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap", "FS"]' --pre-js prologue.js git.bc -o $@

.PHONY: serve
serve: index.html git.js
	python3 -m http.server 8000 --bind 127.0.0.1