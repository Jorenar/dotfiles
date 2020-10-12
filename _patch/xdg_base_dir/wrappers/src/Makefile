CFLAGS = -std=gnu99 -O2

SOURCES := $(wildcard *.c)
TARGETS := $(patsubst %.c,$(_XDG_WRAPPERS)/%,$(SOURCES))

all: $(TARGETS)

$(_XDG_WRAPPERS)/%: %.c
	$(CC) $(CFLAGS) -o $@ $<
