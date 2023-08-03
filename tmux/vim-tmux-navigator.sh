#!/usr/bin/env sh

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"

tmux bind-key -n 'C-w' switch-client -T prefix_C-w

i=33
while [ $i -lt 127 ]; do
    char="$(printf \\$((i/64*100 + i%64/8*10 + i%8)))"
    tmux bind-key -T prefix_C-w    $char  send-keys C-w $char
    tmux bind-key -T prefix_C-w  C-$char  send-keys C-w C-$char
    i=$((i + 1))
done

tmux bind-key -T prefix_C-w   'h' if-shell "$is_vim"  'send-keys C-w h'  'select-pane -L'
tmux bind-key -T prefix_C-w   'j' if-shell "$is_vim"  'send-keys C-w j'  'select-pane -D'
tmux bind-key -T prefix_C-w   'k' if-shell "$is_vim"  'send-keys C-w k'  'select-pane -U'
tmux bind-key -T prefix_C-w   'l' if-shell "$is_vim"  'send-keys C-w l'  'select-pane -R'

tmux bind-key -T prefix_C-w 'C-h' if-shell "$is_vim"  'send-keys C-w h'  'select-pane -L'
tmux bind-key -T prefix_C-w 'C-j' if-shell "$is_vim"  'send-keys C-w j'  'select-pane -D'
tmux bind-key -T prefix_C-w 'C-k' if-shell "$is_vim"  'send-keys C-w k'  'select-pane -U'
tmux bind-key -T prefix_C-w 'C-l' if-shell "$is_vim"  'send-keys C-w l'  'select-pane -R'
