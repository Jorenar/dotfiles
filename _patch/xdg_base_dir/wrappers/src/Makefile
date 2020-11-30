CFLAGS = -std=gnu99 -O2

# Env var _XDG_WRAPPERS is defined in the script install.sh at the root of the repo

SOURCES := $(wildcard *.c)
TARGETS := $(patsubst %.c,$(_XDG_WRAPPERS)/%,$(SOURCES))

all: $(TARGETS)

$(_XDG_WRAPPERS)/%: %.c
	$(CC) $(CFLAGS) -o $@ $< -ljoren
