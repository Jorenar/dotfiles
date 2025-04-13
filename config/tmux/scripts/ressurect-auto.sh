#!/usr/bin/env sh

case "$1" in
    init)
        if [ -z "$2" ]; then
            tmux set-hook -g window-linked "run '$0 init 1'"
        else
            events='
                session-renamed
                window-linked
                window-unlinked
                window-layout-changed
            '
            for ev in $events; do
                tmux set-hook -g "$ev" "run '$0 save'"
            done
        fi
        ;;
    save|restore)
        resurrect_dir="$(tmux show -gv @resurrect-dir)"
        case "$resurrect_dir" in
            '') exit 1 ;;
            */auto) exit ;;
        esac
        trap 'tmux set -g @resurrect-dir "$resurrect_dir"' INT TERM EXIT
        tmux set -g @resurrect-dir "$resurrect_dir/auto"
        "$XDG_CONFIG_HOME"/tmux/plugins/tmux-resurrect/scripts/"$1".sh quiet
        ;;
esac
