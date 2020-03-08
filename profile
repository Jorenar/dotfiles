# PROFILE #
# vim: ft=sh

# ENV VARIABLES
. $XDG_CONFIG_HOME/shell/variables

# If Bash, then source bashrc
if [ -n "$BASH_VERSION" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    [ -f "$XDG_CONFIG_HOME/bash/bashrc" ] && . "$XDG_CONFIG_HOME/bash/bashrc"
fi

# AUTOSTART
for script in $XDG_CONFIG_HOME/env/autostart/*.sh; do
    . "$script"
done
