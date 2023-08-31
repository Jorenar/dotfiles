#!/usr/bin/env sh

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"

tmux bind-key -n 'C-w'  if-shell "$is_vim"  'send-keys C-w'  'switch-client -T prefix_C-w'

i=33
while [ $i -lt 127 ]; do
    # shellcheck disable=SC2017,SC2059
    char="$(printf \\$((i/64*100 + i%64/8*10 + i%8)))"
    tmux bind-key -T prefix_C-w    "$char"  send-keys C-w "$char"
    tmux bind-key -T prefix_C-w  C-"$char"  send-keys C-w C-"$char"
    i=$((i + 1))
done

tmux bind-key -T prefix_C-w    'h'  'select-pane -L'
tmux bind-key -T prefix_C-w    'j'  'select-pane -D'
tmux bind-key -T prefix_C-w    'k'  'select-pane -U'
tmux bind-key -T prefix_C-w    'l'  'select-pane -R'

tmux bind-key -T prefix_C-w  'C-h'  'select-pane -L'
tmux bind-key -T prefix_C-w  'C-j'  'select-pane -D'
tmux bind-key -T prefix_C-w  'C-k'  'select-pane -U'
tmux bind-key -T prefix_C-w  'C-l'  'select-pane -R'
