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

# FZF
source $XDG_CONFIG_HOME/fzf.sh

# Enable extended globbing
shopt -s extglob

# Don't keep duplicates in history
export HISTCONTROL=ignoreboth:erasedups

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Fix PROMPT
PS1='\['"$(sed 's/\x1B\[[0-9;]*[a-zA-Z]/\\001&\\002/g' <<< "$PS1")"
