# SPDX-License-Identifier:  MIT
# Copyright 2023 Jorengarenar
# Makefile dialect: GNU

# ~ ----------------------------------------------------------------------- {{{1

.PHONY: default dev debug build clean stderr compile_commands.json

define cache_target
	@ echo "$@" > $(BUILD)/.target
	@ $(if $(filter $@,default),$(RM) $(BUILD)/.target)
endef

# VARS -------------------------------------------------------------------- {{{1

EXE := $(notdir $(CURDIR))

SRCDIR   := src
BUILD    := build
OBJDIR   := $(BUILD)/obj
BINDIR   := $(BUILD)/bin
DEPSDIR  := $(BUILD)/deps
DUMPDIR  := $(BUILD)/dump

override CFLAGS   +=
override CPPFLAGS +=

override LDFLAGS  +=
override LDLIBS   +=

override SANS += address bounds leak signed-integer-overflow undefined unreachable

LIBS :=

ifneq ($(LIBS),)
	CFLAGS   += $(shell pkg-config --cflags-only-other $(LIBS))
	CPPFLAGS += $(shell pkg-config --cflags-only-I $(LIBS))
	LDFLAGS  += $(shell pkg-config --libs-only-L $(LIBS))
	LDLIBS   += $(shell pkg-config --libs-only-l $(LIBS))
endif

SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRCS))

# BUILDS ------------------------------------------------------------------ {{{1

ifneq ($(wildcard $(BUILD)/.target),)

default: $(shell cat $(BUILD)/.target)

else

default: CFLAGS += -O2 -flto -DNDEBUG
default: LDFLAGS += -s -flto
default: build
	$(cache_target)

endif


dev: CFLAGS += \
	-O3 -flto \
	-march=native -mtune=native
dev: CFLAGS += \
	-Wall -Wextra -pedantic
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
	-fno-omit-frame-pointer \
	-fsanitize=$(subst $(eval) ,$(shell echo ","),$(SANS))
dev: build
	$(cache_target)


debug: CFLAGS += \
	-Og \
	-g3 -ggdb3
debug: CFLAGS += \
	-masm=intel -fverbose-asm \
	-save-temps -dumpbase $(DUMPDIR)/$(*F)
debug: build
	$(cache_target)


build: $(BINDIR)/$(EXE)
	$(cache_target)

# RULES ------------------------------------------------------------------- {{{1

$(BINDIR)/%: $(OBJS)
	@mkdir -p $(BINDIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(OBJDIR)
	@mkdir -p $(DUMPDIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

$(DEPSDIR)/%.d: $(SRCDIR)/%.c
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

compile_commands.json:
	@ $(MAKE) --always-make --dry-run dev \
		| grep -wE -e '$(CC)' \
		| grep -w -e '\-c' -e '\-x' \
		| jq -nR '[inputs|{command:., directory:"'$$PWD'", file: match("(?<=-c )\\S+").string}]' \
		> compile_commands.json
