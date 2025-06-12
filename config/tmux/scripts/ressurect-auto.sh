#!/usr/bin/env sh

case "$1" in
    init)
        if [ -z "$2" ]; then
            tmux set-hook -g 'pane-focus-in[100]' "run '$0 init 1'"
        else
            tmux set-hook -u 'pane-focus-in[100]'
            events='
                session-renamed
                pane-focus-out
                window-layout-changed
            '
            for ev in $events; do
                tmux set-hook -g "$ev"'[100]' "run '$0 save'"
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
        find "$resurrect_dir"/auto -name '*.txt' | sort -nr | sed '1,5d' | xargs -I{} rm {}
        "$TMUX_PLUGIN_MANAGER_PATH"/tmux-resurrect/scripts/"$1".sh quiet
        ;;
esac
