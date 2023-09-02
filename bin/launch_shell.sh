#!/usr/bin/env sh

if [ "$#" -eq 0 ]; then
    while [ -x "$(command -v tmux)" ]; do
        [ -n "$TMUX" ] && break
        [ -z "$DISPLAY" ] && break
        [ -n "$SSH_CLIENT" ] && break

        # shellcheck disable=SC2155
        export SHELL="$(command -v "$0")"

        # shellcheck disable=SC2093
        exec tmux -S "$XDG_RUNTIME_DIR"/tmux $(
            if ps -ef | grep -v grep | grep -q tmux; then
                echo attach \; new-session
            else
                echo "-f $XDG_CONFIG_HOME/tmux/tmux.conf"
            fi
        )
    done
fi

e () {
    sh="$(command -v "$1")" && shift
    if [ -x "$sh" ]; then
        [ -n "$DISPLAY" ] && export SHELL="$sh"
        exec "$sh" "$@"
    fi
}

e bash --rcfile "$XDG_CONFIG_HOME"/bash/bashrc "$@"
e zsh "$@"
e ksh "$@"
e tcsh "$@"
e fish "$@"

exec sh "$@"
