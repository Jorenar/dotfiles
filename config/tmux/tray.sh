#!/usr/bin/env sh

[ -z "$DISPLAY" ] && exit 1
[ -n "$WSL_DISTRO_NAME" ] && exit 1

pipe="$XDG_RUNTIME_DIR"/tmux-tray-icon
[ ! -e "$pipe" ] && mkfifo "$pipe"

while true; do
    printf 'menu:'
    tmux ls -F '#{session_name} #W | #T' -f '#{?session_attached,0,1}' | awk '{
        id = $1; sub($1 FS, "");
        print $0, "!xterm -e \"tmux -S $XDG_RUNTIME_DIR/tmux attach -t " id "\""
    }' | tr '\n' '\t'
    printf '\n'
    sleep 1
done > "$pipe" &

exec yad \
    --notification \
    --text="Detached tmux sessions" \
    --image="$(dirname "$0")/logo.png" \
    --separator='\t' \
    --listen < "$pipe"
