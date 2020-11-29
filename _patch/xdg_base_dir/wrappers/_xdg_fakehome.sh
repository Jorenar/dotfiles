#!/usr/bin/env sh

HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/fakehome}"

. "$JOREN_SHELL_LIB/wrapper_exec.sh"
wrapper_exec "$@"
