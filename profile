# PROFILE #
# vim: ft=sh fdm=marker fen

# ENV VARIABLES {{{1
. $XDG_DOTFILES_DIR/shell/variables

# AUTOSTART {{{1
for script in $XDG_CONFIG_HOME/env/autostart/*.sh; do
    . "$script"
done

# Source {{{1

# Source local additional env
[ -f $XDG_LOCAL_HOME/supp/profile ] && . $XDG_LOCAL_HOME/supp/profile

# If Bash, then bashrc
if [ -n "$BASH" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    [ -f "$XDG_CONFIG_HOME/bash/bashrc" ] && . "$XDG_CONFIG_HOME/bash/bashrc"
fi
