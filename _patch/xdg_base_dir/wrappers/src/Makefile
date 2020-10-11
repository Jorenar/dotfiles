CFLAGS = -std=gnu99 -O2

all: $(patsubst %.c,%,$(wildcard *.c))

%: %.c
	$(CC) $(CFLAGS) -o $(_XDG_WRAPPERS)/$@ $<
