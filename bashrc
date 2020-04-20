# BASHRC #

# Source basic shell config
source $XDG_CONFIG_HOME/shell/shrc

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Better autocompletion (like in zsh), but use Shift-Tab
bind '"\e[Z":menu-complete'

# Magic space
bind space:magic-space

# Enable extended globbing
shopt -s extglob

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Fix PROMPT
PS1='\['"$(sed 's/\x1B\[[0-9;]*[a-zA-Z]/\\001&\\002/g' <<< "$PS1")"
