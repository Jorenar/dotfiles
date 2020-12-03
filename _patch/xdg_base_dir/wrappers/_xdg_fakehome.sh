#!/usr/bin/env sh

HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/fakehome}"

. "$XDG_LIB_DIR/shell/progwrap.sh"
progwrap_exec "$@"
