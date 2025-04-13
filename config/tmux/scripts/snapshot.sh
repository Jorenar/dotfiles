#!/usr/bin/env sh

case "$1" in
    save) prompt='Save snapshot as:' ;;
    restore) prompt='Restore snapshot:' ;;
esac
tmux command-prompt -p "$prompt" \
    "run '$XDG_CONFIG_HOME/tmux/plugins/tmux-named-snapshot/scripts/$1-snapshot.sh %1'"
