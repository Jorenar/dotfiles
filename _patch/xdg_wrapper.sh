#!/usr/bin/env sh

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

case "$(basename "$0")" in
    bash)
        for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)"); do
            if [ -x "$dir/$(basename $0)" ]; then
                exec "$dir/$(basename $0)" --rcfile "$XDG_CONFIG_HOME/bash/bashrc" "$@"
            fi
        done
        echo "$0: error: Wrapped command does not exist" >&2
        ;;
    csh|tcsh)
        PATH=$(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)" | paste -sd:)
        export REAL_HOME="$HOME"
        HOME="$XDG_CONFIG_HOME/csh"

        for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)"); do
            [ -x "$dir/$(basename $0)" ] && exec "$dir/$(basename $0)" "$@"
        done
        echo "$0: error: Wrapped command does not exist" >&2
        ;;
    dosbox)
        ARGS="-conf $XDG_CONFIG_HOME/dosbox/dosbox.conf"
        ;;
    firefox)
        ARGS="--profile $XDG_DATA_HOME/firefox"
        { while kill -0 $$ 2> /dev/null; do rm -rf $HOME/.mozilla; done; } &
        ;;
    gdb)
        # if SHELL points also to XDG wrapper, then change it to actual executable
        for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $SHELL)"); do
            [ -x "$dir/$(basename $SHELL)" ] && SHELL="$dir/$(basename $SHELL)" && break
        done
        ARGS="-q -x $XDG_CONFIG_HOME/gdb/init"
        ;;
    nvidia-settings)
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        ARGS="--config=$XDG_CONFIG_HOME/nvidia/rc.conf"
        ;;
    sqlite3)
        ARGS="-init $XDG_CONFIG_HOME/sqlite3/sqliterc"
        ;;
    ssh|scp)
        SSH_CONFIG="-F $XDG_CONFIG_HOME/ssh/config"
        SSH_ID="$XDG_DATA_HOME/ssh/id_rsa"
        OPTIONS="-o IdentityFile=$SSH_ID -o UserKnownHostsFile=$XDG_DATA_HOME/ssh/known_hosts"

        ARGS="$SSH_CONFIG $OPTIONS"
        ;;
    steam)
        HOME="$XDG_DATA_HOME/Steam"
        ;;
    weechat)
        chmod -w "$XDG_CONFIG_HOME/weechat"
        ;;
    *) # FAKEHOME
        HOME="${XDG_FAKEHOME_DIR:-$HOME/.local/.fakehome}"
        ;;
esac

progwrap_exec() {
    bs="$(basename "$0" | sed 's/-/_/')"
    execChainEnvVar=execution_chain_$bs

    if [ "$1" = "--P" ]; then
        PREFIX="$2"
        shift 2
    fi

    eval val="\$$execChainEnvVar"

    if [ -z "$val" ]; then
        export "$execChainEnvVar"="$(stat -c "%i" "$(realpath $0)")"
    fi

    for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)"); do
        f="$dir/$(basename $0)"
        if [ -x "$f" ]; then
            i=$(stat -c "%i" "$f")
            if [ "${val#*$i}" = "$val" ]; then
                export "$execChainEnvVar"="$val:$i"
                unset i f
                exec $PREFIX "$dir/$(basename $0)" "$@"
            fi
        fi
    done

    echo "$0: error: Wrapped command does not exist" >&2
}

progwrap_exec $ARGS "$@"


#~ adb
#~ audacity
#~ bash
#~ csh
#~ dosbox
#~ firefox
#~ gdb
#~ gphoto2
#~ nvidia-settings
#~ scp
#~ sqlite3
#~ ssh
#~ steam
#~ tcsh
#~ weechat
