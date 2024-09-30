#!/usr/bin/env sh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

exe="$(basename "$0")"

# Remove directory with wrapper from PATH (to prevent cyclical execution)
PATH="$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname "$0")" | paste -sd:)"

case "$exe" in
    dosbox)
        set -- "-conf" "$XDG_CONFIG_HOME/dosbox/dosbox.conf" "$@"
        ;;
    firefox)
        set -- "--profile" "$XDG_DATA_HOME/firefox" "$@"
        { while kill -0 $$ 2> /dev/null; do rm -rf "$HOME"/.mozilla; done; } &
        ;;
    nvidia-settings)
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        set -- "--config=$XDG_CONFIG_HOME/nvidia/rc.conf" "$@"
        ;;
    ssh|scp)
        if [ ! -e "$HOME/.ssh/config" ]; then
            if [ -e "$XDG_CONFIG_HOME/ssh/config" ]; then
                set -- "-F" "$XDG_CONFIG_HOME/ssh/config" "$@"
            fi
        fi
        controlpath="$(ssh -G "$@" | awk '/^controlpath / { print $2 }')"
        [ -n "$controlpath" ] && mkdir -p "$(dirname "$controlpath")"
        ;;
    steam)
        HOME="$XDG_DATA_HOME/Steam"
        ;;
    telnet)
        HOME="$XDG_CONFIG_HOME"
        ;;
    xsane)
        HOME="$XDG_DATA_HOME"
        ;;
    zoom)
        HOME="$XDG_DATA_HOME"
        XDG_CONFIG_HOME="$HOME/.zoom"
        mkdir -p "$XDG_CONFIG_HOME"
        ;;
esac

exec "$exe" "$@"


#~ dosbox
#~ firefox
#~ nvidia-settings
#~ scp
#~ ssh
#~ steam
#~ telnet
#~ xsane
#~ zoom
