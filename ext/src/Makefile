ifeq "$(PLATFORM)" ""
PLATFORM := $(shell uname)
endif

ifeq "$(PLATFORM)" "Linux"
UNAME = "$(shell llvm-config --host-target)"
CRYSTAL_BIN = $(shell readlink -f `which crystal`)
LIBRARY_PATH = $(shell dirname $(CRYSTAL_BIN))/../embedded/lib
LIBCRYSTAL = $(shell dirname $(CRYSTAL_BIN) )/../src/ext/libcrystal.a
LIBRUBY = $(shell ruby -e "puts RbConfig::CONFIG['libdir']")
LIBS = -levent -lpcre -lgc -lpthread -lrt -ldl
LDFLAGS = -rdynamic -undefined,dynamic_lookup

install: all

all: fast_blank.so

fast_blank.so: cr_fast_blank.o
	$(CC) -shared $^ -o $@ $(LIBCRYSTAL) -L$(LIBRARY_PATH) -L$(LIBRUBY) $(LIBS) $(LDFLAGS)

cr_fast_blank.o: ../../../../ext/src/cr_fast_blank.cr
	crystal compile --cross-compile --release --target $(UNAME) $<

.PHONY: clean
clean:
	rm -f bc_flags
	rm -f *.o
	rm -f *.so
endif

ifeq "$(PLATFORM)" "Darwin"
CRYSTAL_FLAGS = -dynamic -bundle -Wl,-undefined,dynamic_lookup

install: all

all: fast_blank.bundle

fast_blank.bundle: ../../../../ext/src/cr_fast_blank.cr
	crystal $^ --release --link-flags "$(CRYSTAL_FLAGS)" -o $@

clean:
	rm -f *.log
	rm -f *.o
	rm -f *.bundle
endif

