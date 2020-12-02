CFLAGS = -std=gnu99 -O2

# Env var _XDG_WRAPPERS is defined in the script install.sh at the root of the repo

_XDG_WRAPPERS = ~/.local/bin/_patch/xdg_wrappers

SOURCES := $(wildcard *.c)
TARGETS := $(patsubst %.c,$(_XDG_WRAPPERS)/%,$(SOURCES))

all: $(TARGETS)

$(_XDG_WRAPPERS)/%: %.c
	$(CC) $(CFLAGS) -o $@ $< -ljoren -lwrapper_exec

clean:
	rm $(_XDG_WRAPPERS)/firefox
