#!/usr/bin/env sh
# vim: fdl=1

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

arg0="${0##*/}"

if [ "$arg0" = "xdg_wrapper.sh" ]; then
    case "$1" in
        --install)
            dir="$HOME/.local/opt/xdg_wrappers/bin"
            mkdir -p "$dir"
            sed -n -e 's/^#~ //p' "$0" | while IFS= read -r bin; do
                command -v "$bin" > /dev/null && ln -sf "$0" "$dir/$bin"
            done
            ;;
    esac
    exit
fi

# Remove directory with wrapper from PATH (to prevent cyclical execution)
PATH="$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname "$0")" | paste -sd:)"

case "$arg0" in
    dosbox)
        set -- "-conf" "$XDG_CONFIG_HOME/dosbox/dosbox.conf" "$@"
        ;;
    firefox)
        set -- "--profile" "$XDG_DATA_HOME/firefox" "$@"
        { while kill -0 $$; do sleep 1; rm -rf "$HOME"/.mozilla; done } 2>/dev/null &
        ;;
    i2pd)
        set -- \
            '--conf' "$XDG_CONFIG_HOME"/i2pd/i2pd.conf \
            '--datadir' "$XDG_DATA_HOME"/i2pd \
            '--logfile' "$XDG_STATE_HOME"/i2pd.log \
            '--pidfile' "$XDG_RUNTIME_DIR"/i2pd.pid \
            "$@"
        ;;
    ssh|scp|ssh-copy-id)
        if [ ! -e "$HOME/.ssh/config" ]; then
            if [ -e "$XDG_CONFIG_HOME/ssh/config" ]; then
                set -- "-F" "$XDG_CONFIG_HOME/ssh/config" "$@"
            fi
        fi

        ssh_G="$(:
            opts="$("$arg0" 2>&1 | grep -E -o -e '\[-\S+]' -e '\[-\S \S+]' \
                | tr -d '[]|-' | sed 's/ .\+/:/' | tr -d '\n')"

            conf=
            while getopts "$opts" opt 2> /dev/null; do
                case "$opt" in (F) conf="$OPTARG" ;; esac
            done
            shift $((OPTIND - 1))

            [ -n "$conf" ] && set -- "-F" "$conf" "$@"
            ssh -G "$@" 2> /dev/null
        )"

        controlpath="$(echo "$ssh_G" | awk '/^controlpath / { print $2 }')"
        [ -n "$controlpath" ] && mkdir -p "$(dirname "$controlpath")"

        if [ "$arg0" = "ssh-copy-id" ]; then
            if echo "$*" | grep -vq -- ' -i '; then
                id="$(echo "$ssh_G" | awk '/^identityfile / { print $2 }')"
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
        HOME="$XDG_DATA_HOME/Steam/HOME"
        mkdir -p "$HOME"/.local
        l () { [ ! -e "$2" ] && ln -s "$1" "$2"; }
        l "$XDG_CACHE_HOME"  "$HOME"/.cache
        l "$XDG_CONFIG_HOME" "$HOME"/.config
        l "$XDG_DATA_HOME"   "$HOME"/.local/share
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

exec "$arg0" "$@"


#~ dosbox
#~ firefox
#~ i2pd
#~ scp
#~ ssh
#~ ssh-copy-id
#~ steam
#~ telnet
#~ zoom
