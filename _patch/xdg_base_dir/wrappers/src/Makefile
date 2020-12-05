CFLAGS = -std=gnu99 -O2

# Env var _XDG_WRAPPERS is defined in the script install.sh at the root of the repo
ifndef _XDG_WRAPPERS
	override _XDG_WRAPPERS = $(HOME)/.local/bin/_patch/xdg_wrappers
endif

SOURCES := $(wildcard *.c)
TARGETS := $(patsubst %.c,$(_XDG_WRAPPERS)/%,$(SOURCES))

all: $(TARGETS)

$(_XDG_WRAPPERS)/%: %.c
	$(CC) $(CFLAGS) -o $@ $< -static -ljcbc

clean:
	rm $(_XDG_WRAPPERS)/firefox
