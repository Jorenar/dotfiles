#!/usr/bin/env sh

case "$-" in
    *i*) ;;
    *)
        while [ -x "$(command -v tmux)" ]; do
            [ -n "$TMUX" ] && break
            [ -z "$DISPLAY" ] && break
            [ -n "$SSH_CLIENT" ] && break

            # shellcheck disable=SC2093
            exec tmux -S "$XDG_RUNTIME_DIR"/tmux $(
                if ps -ef | grep tmux | grep -v -q grep; then
                    echo attach \; new-session
                else
                    echo "-f $XDG_CONFIG_HOME/tmux/tmux.conf"
                fi
            )
        done
        ;;
esac

if [ -x "$(command -v bash)" ]; then
    exec bash --rcfile "$XDG_CONFIG_HOME"/bash/bashrc "$@"
fi

if [ -x "$(command -v zsh)" ]; then
    exec zsh "$@"
fi

if [ -x "$(command -v ksh)" ]; then
    exec ksh "$@"
fi

if [ -x "$(command -v tcsh)" ]; then
    exec tcsh "$@"
fi

if [ -x "$(command -v fish)" ]; then
    exec fish "$@"
fi

exec sh "$@"
