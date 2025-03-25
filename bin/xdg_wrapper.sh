#!/usr/bin/env sh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

exe="$(basename "$0")"

if [ "$exe" = "xdg_wrapper.sh" ]; then
    case "$1" in
        --install)
            dir="$HOME/.local/opt/xdg_wrappers/bin"
            mkdir -p "$dir"
            sed -n -e 's/^#~ //p' "$0" | while IFS= read -r bin; do
                [ -x "$(command -v "$bin")" ] && ln -sf "$0" "$dir/$bin"
            done
            ;;
    esac
    exit
fi

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
    ssh|scp|ssh-copy-id)
        if [ ! -e "$HOME/.ssh/config" ]; then
            if [ -e "$XDG_CONFIG_HOME/ssh/config" ]; then
                set -- "-F" "$XDG_CONFIG_HOME/ssh/config" "$@"
            fi
        fi

        controlpath="$(ssh -G "$@" 2> /dev/null | awk '/^controlpath / { print $2 }')"
        [ -n "$controlpath" ] && mkdir -p "$(dirname "$controlpath")"

        if [ "$exe" = "ssh-copy-id" ]; then
            if echo "$*" | grep -vq -- ' -i '; then
                id="$(ssh -G "$@" 2> /dev/null | awk '/^identityfile / { print $2 }')"
                id="$(eval echo "$id")"
                [ -f "$id" ] && set -- "-i" "$id" "$@"
            fi

            if [ ! -d "$HOME/.ssh" ]; then
                alias exec=
                mkdir -p "$HOME/.ssh" \
                    && trap 'rmdir "$HOME/.ssh"' EXIT INT TERM
            fi
        fi

        ;;
    steam)
        HOME="$XDG_DATA_HOME/Steam"
        ;;
    telnet)
        HOME="$XDG_CONFIG_HOME/telnet"
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
#~ ssh-copy-id
#~ steam
#~ telnet
#~ zoom
