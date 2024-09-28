# SPDX-License-Identifier:  MIT
# Copyright 2023-2024 Jorengarenar
# Makefile dialect: GNU

# ~ ----------------------------------------------------------------------- {{{1

.PHONY: regular dev debug build clean stderr scan-build compile_commands.json

cache_build = @ echo "$@:" > $(BUILD)/.target

# VARS -------------------------------------------------------------------- {{{1

EXE := $(notdir $(CURDIR))

SRCDIR   := src
BUILD    := build
EXTERN   := extern
OBJDIR   := $(BUILD)/obj
BINDIR   := $(BUILD)/bin
DEPSDIR  := $(BUILD)/deps
DUMPDIR  := $(BUILD)/dump

LIBS :=

CFLAGS   +=
CPPFLAGS +=

LDFLAGS  +=
LDLIBS   +=

SANS += address bounds leak signed-integer-overflow undefined unreachable

SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

ifneq ($(LIBS),)
	CFLAGS   += $(shell pkg-config --cflags-only-other $(LIBS))
	CPPFLAGS += $(shell pkg-config --cflags-only-I $(LIBS))
	LDFLAGS  += $(shell pkg-config --libs-only-L $(LIBS))
	LDLIBS   += $(shell pkg-config --libs-only-l $(LIBS))
endif

# BUILDS ------------------------------------------------------------------ {{{1

-include $(BUILD)/.target


regular: CFLAGS += -O2 -flto -DNDEBUG
regular: LDFLAGS += -s -flto
regular: build
	$(cache_build)


native: CFLAGS += -march=native -mtune=native
native: regular
	$(cache_build)


dev: CFLAGS += \
	-O3 -flto \
	-march=native -mtune=native
dev: CFLAGS += \
	-Wall -Wextra \
	-fanalyzer
dev: CFLAGS += \
	-pedantic # -pedantic-errors
dev: CFLAGS += \
	-Wcast-qual \
	-Wcast-align \
	-Wdouble-promotion \
	-Wuseless-cast
dev: CFLAGS += \
	-Wlogical-op \
	-Wfloat-equal
dev: CFLAGS += \
	-Wformat=2 \
	-Wwrite-strings
dev: CFLAGS += \
	-Winline \
	-Wmissing-prototypes \
	-Wstrict-prototypes \
	-Wold-style-definition \
	-Werror=implicit-function-declaration \
	-Werror=return-type
dev: CFLAGS += \
	-Wshadow \
	-Wnested-externs \
	-Werror=init-self
dev: CFLAGS += \
	-Wnull-dereference \
	-Wchar-subscripts \
	-Wsequence-point \
	-Wpointer-arith
dev: CFLAGS += \
	-Wduplicated-cond \
	-Wduplicated-branches
dev: CFLAGS += \
	-Walloca \
	-Werror=vla-larger-than=0
dev: CFLAGS += \
	-Werror=parentheses \
	-Werror=missing-braces \
	-Werror=misleading-indentation
dev: CFLAGS += \
	-g \
	-fno-omit-frame-pointer \
	-fsanitize=$(subst $(eval) ,$(shell echo ","),$(SANS))
dev: build
	$(cache_build)


debug: CFLAGS += \
	-Og \
	-g3 -ggdb3
debug: CFLAGS += \
	-masm=intel -fverbose-asm \
	-save-temps -dumpbase $(DUMPDIR)/$(*F)
debug: build
	$(cache_build)


build: $(BINDIR)/$(EXE)


# RULES ------------------------------------------------------------------- {{{1

$(BINDIR)/%: $(OBJS)
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	@mkdir -p $(DUMPDIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

# $(OBJDIR)/%.o: $(SRCS)
# 	@mkdir -p $(OBJDIR)
# 	@mkdir -p $(DUMPDIR)
# 	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $(filter %/$(notdir $(@:.o=.c)),$(SRCS))

$(DEPSDIR)/%.o.d: $(SRCDIR)/%.c
	@mkdir -p $(DEPSDIR)
	@ $(CC) $(CPPFLAGS) -M $< -MT $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $<) > $@

-include $(patsubst $(OBJDIR)/%.o, $(DEPSDIR)/%.d, $(OBJS))

# MISC -------------------------------------------------------------------- {{{1

clean:
	@ [ "$(CURDIR)" != "$(abspath $(BUILD))" ]
	$(RM) -r $(BUILD)

stderr:
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS)) 2> $(BUILD)/stderr.log
	@ false

scan-build:
	@mkdir -p $(BUILD)/scan-build
	scan-build -o $(BUILD)/scan-build $(MAKE) $(filter-out $@,$(MAKECMDGOALS))

compile_commands.json:
	@ $(MAKE) --always-make --dry-run dev \
		| grep -wE -e '$(CC)' \
		| grep -w -e '\-c' -e '\-x' \
		| jq -nR '[inputs|{command:., directory:"'$$PWD'", file: match("(?<=-c )\\S+").string}]' \
		> compile_commands.json
