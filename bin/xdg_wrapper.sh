#!/usr/bin/env sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

EXE="$(basename "$0")"

case "$EXE" in
    dosbox)
        ARGS="-conf $XDG_CONFIG_HOME/dosbox/dosbox.conf"
        ;;
    firefox)
        ARGS="--profile $XDG_DATA_HOME/firefox"
        { while kill -0 $$ 2> /dev/null; do rm -rf "$HOME"/.mozilla; done; } &
        ;;
    nvidia-settings)
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        ARGS="--config=$XDG_CONFIG_HOME/nvidia/rc.conf"
        ;;
    sqlite3)
        ARGS="-init $XDG_CONFIG_HOME/sqlite3/sqliterc"
        ;;
    ssh|scp)
        ARGS="-F $XDG_CONFIG_HOME/ssh/config"
        ;;
    steam)
        HOME="$XDG_DATA_HOME/Steam"
        ;;
    telnet)
        HOME="$XDG_CONFIG_HOME"
        ;;
esac

# Remove directory with wrapper from PATH (to prevent cyclical execution)
PATH="$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname "$0")" | paste -sd:)"

# shellcheck disable=SC2086
exec "$EXE" $ARGS "$@"


#~ dosbox
#~ firefox
#~ nvidia-settings
#~ scp
#~ sqlite3
#~ ssh
#~ steam
#~ telnet