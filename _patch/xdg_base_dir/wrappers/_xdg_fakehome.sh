#!/usr/bin/env sh

HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/fakehome}"

. $XDG_LIB_DIR/shell/wrapper_exec.sh
wrapper_exec "$@"
