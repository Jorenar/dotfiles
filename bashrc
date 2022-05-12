# BASHRC #

# Source basic shell config
source $XDG_CONFIG_HOME/shell/shrc

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

# Better autocompletion (like in zsh), but use Shift-Tab
bind '"\e[Z":menu-complete'

# Magic space
bind space:magic-space

# C-x C-h to open man page for currently typed command
bind -x '"\C-x\C-h":__man'
__man(){ man $(echo $READLINE_LINE | awk '{print $1}'); }

# Enable extended globbing
shopt -s extglob

export HISTCONTROL=ignoreboth:erasedups

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Fix PROMPT
PS1='\['"$(sed 's/\x1B\[[0-9;]*[a-zA-Z]/\\001&\\002/g' <<< "$PS1")"
