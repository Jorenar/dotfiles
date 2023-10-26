PROGNAME := $(notdir $(CURDIR))

SRCDIR   := src
BUILD    := build
OBJDIR   := $(BUILD)/obj
BINDIR   := $(BUILD)/bin
DEPSDIR  := $(BUILD)/deps
DUMPDIR  := $(BUILD)/dump

CSTDFLAG := -std=c99

CFLAGS   := $(CSTDFLAG) -O2 -flto
CPPFLAGS :=

LDFLAGS  := -s
LDLIBS   :=

LIBS :=

ifneq ($(LIBS),)
	CFLAGS    += $(shell pkg-config --cflags-only-other $(LIBS))
	CPPFLAGS  += $(shell pkg-config --cflags-only-I $(LIBS))
	LDFLAGS   += $(shell pkg-config --libs-only-L $(LIBS))
	LDLIBS    += $(shell pkg-config --libs-only-l $(LIBS))
endif

SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

.PHONY: build clean debug compile_commands.json

build: $(BINDIR)/$(PROGNAME)

clean:
	@ [ "$(CURDIR)" != "$(abspath $(BUILD))" ]
	$(RM) -r $(BUILD)


$(BINDIR)/%: $(OBJS)
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS) $(STDERR_REDIR)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	@mkdir -p $(DUMPDIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $< $(STDERR_REDIR)

$(DEPSDIR)/%.d: $(SRCDIR)/%.c
	@mkdir -p $(DEPSDIR)
	@ $(CC) $(CPPFLAGS) -M $< -MT $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $<) > $@

-include $(patsubst $(OBJDIR)/%.o, $(DEPSDIR)/%.d, $(OBJS))


debug: CFLAGS = $(CSTDFLAG)
debug: CFLAGS += \
	-pedantic \
	-DDEBUG=1 \
	-g3 -O0 \
	-Wall -Wextra
debug: CFLAGS += \
	-masm=intel \
	-fverbose-asm \
	-save-temps -dumpbase $(DUMPDIR)/$(*F)
debug: CFLAGS += \
	-fsanitize=address,undefined,leak,signed-integer-overflow \
	-fno-omit-frame-pointer
debug: CFLAGS += \
	-Wcast-qual \
	-Wcast-align \
	-Wdouble-promotion
debug: CFLAGS += \
	-Wlogical-op \
	-Wfloat-equal
debug: CFLAGS += \
	-Wformat=2 \
	-Wwrite-strings
debug: CFLAGS += \
	-Winline \
	-Wmissing-prototypes \
	-Wstrict-prototypes \
	-Wold-style-definition \
	-Werror=implicit-function-declaration \
	-Werror=return-type
debug: CFLAGS += \
	-Wshadow \
	-Wnested-externs \
	-Werror=init-self
debug: CFLAGS += \
	-Wnull-dereference \
	-Wchar-subscripts \
	-Wsequence-point \
	-Wpointer-arith
debug: CFLAGS += \
	-Wduplicated-cond \
	-Wduplicated-branches
debug: CFLAGS += \
	-Werror=missing-braces \
	-Werror=misleading-indentation

debug: LDFLAGS =
debug: STDERR_REDIR := 2>&1 | tee -a $(BUILD)/stderr.log

debug: build


compile_commands.json:
	@ $(MAKE) --always-make --dry-run build \
		| grep -wE -e '$(CC)' \
		| grep -w -e '\-c' -e '\-x' \
		| jq -nR '[inputs|{directory:"'$$PWD'", command:., file: match("(?<=-c )\\S+").string}]' \
		> compile_commands.json
