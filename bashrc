# BASHRC #
# vim: fdm=marker fen

# Source shells environment configs
source $XDG_CONFIG_HOME/shell/shrc

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Enable extended globbing
shopt -s extglob

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Fix PROMPT
PS1="\[\e[0m\]$PS1"
