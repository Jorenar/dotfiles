# Source 'profile' file from (possible) XDG locations

# Hierarchy:
#   1. ~/.profile
#   2. $XDG_CONFIG_HOME/
#       1. profile
#       2. env/profile
#   3. ~/.config/
#       1. profile
#       2. env/profile
#   4. ~/.local/
#       1. config/
#           1. profile
#           2. env/profile
#       2. etc/
#           1. profile
#           2. env/profile

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
elif [ -n "$XDG_CONFIG_HOME" ]; then
    if [ -f "$XDG_CONFIG_HOME/profile" ]; then
        . "$XDG_CONFIG_HOME/profile"
    elif [ -f "$XDG_CONFIG_HOME/env/profile" ]; then
        . "$XDG_CONFIG_HOME/env/profile"
    fi
else
    if [ -f "$HOME/.config/profile" ]; then
        . "$HOME/.config/profile"
    elif [ -f "$HOME/.config/env/profile" ]; then
        . "$HOME/.config/env/profile"

    elif [ -f "$HOME/.local/config/profile" ]; then
        . "$HOME/.local/config/profile"
    elif [ -f "$HOME/.local/config/env/profile" ]; then
        . "$HOME/.local/config/env/profile"

    elif [ -f "$HOME/.local/etc/profile" ]; then
        . $HOME/.local/etc/profile"
    elif [ -f "$HOME/.local/etc/env/profile" ]; then
        . $HOME/.local/etc/env/profile"
    fi
fi
