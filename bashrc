# BASHRC #

# COMPLETION {{{1

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

# Enable extended globbing
shopt -s extglob

# Magic space
bind Space:magic-space

# HISTORY {{{1

# Set history file location
# Look for 'export HISTFILE' in $XDG_DOTFILES_DIR/_XDG

# For setting history length see HISTSIZE and HISTFILESIZE
HISTSIZE=500
HISTFILESIZE=500

# Avoid duplicates
export HISTCONTROL=ignoreboth

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# OTHER {{{1

# Use Vi mode
set -o vi

# Source 'profile' file
if [ $DISPLAY ] && [ -z $TMUX ]; then # prevents "source looping"
    source $XDG_DOTFILES_DIR/profile
fi

# PROMPT
PS1='\[\e[1m\]\u@\h:\[\033[90m\]\w\[\033[0m\]\[\033[1m\]\$\[\e[0m\] '


# vim: ft=bash fdm=marker fen
