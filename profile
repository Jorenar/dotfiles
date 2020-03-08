# PROFILE #

# ENV VARIABLES
. $XDG_CONFIG_HOME/shell/variables

# AUTOSTART
for script in $XDG_CONFIG_HOME/env/autostart/*.sh; do
    . "$script"
done

# If Bash, then source bashrc
if [ -n "$BASH" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    [ -f "$XDG_CONFIG_HOME/bash/bashrc" ] && . "$XDG_CONFIG_HOME/bash/bashrc"
fi
