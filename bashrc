# BASHRC #

# ALIASES {{{1

alias ap1='sudo create_ap wlo1 wlo1 x I_love_BASH' # semi open WiFi network
alias cal='cal -m'
alias du='du -h'
alias gpu-switch='optimus-manager --switch auto && i3-msg exit'
alias grep='grep --color'
alias i3-logout="i3-msg exit"
alias less='less -R'
alias ll='ls -alhF | less -R'
alias ls='ls -F'
alias mkdir='mkdir -p'
alias mnt='udisksctl mount -b'
alias off='shutdown -h now'
alias op='xdg-open'
alias pacman-autoremove='pacman -Rns $(pacman -Qtdq)'
alias pass='EDITOR="vim -u NONE" pass'
alias qmv='command qmv -v -f "do"'
alias su='sudo su'
alias sudo='sudo '
alias suspend='systemctl suspend'
alias umnt='udisksctl unmount -b'
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
alias vi='vim -p'
alias wicd='wicd-curses'
alias wine-lnk='env WINEPREFIX="$HOME/.wine" wine C:\\windows\\command\\start.exe /Unix'

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
# Look for 'export HISTFILE' in $DOTFILES/xdg

# For setting history length see HISTSIZE and HISTFILESIZE
HISTSIZE=1000
HISTFILESIZE=2000

# Avoid duplicates
export HISTCONTROL=ignoredups:erasedups

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# WINDOW {{{1

# Check the window size after each command and update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set window title to "command | user@host:dir"
case "$TERM" in
    xterm*|rxvt*|screen*)
        PS1="\[\e]0;\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# WRAPPERS {{{1

feh() {
    if [[ -d $1 ]] || [[ -d $2 ]]; then
        nohup feh $R "$@" > /dev/null 2>&1
    else
        nohup feh --start-at "$@" > /dev/null 2>&1
    fi
}

find() {
    command find $@ 2> /dev/null
}

mpv() {
    if [[ -z "$1" ]]; then
        command mpv ./
    elif [[ "$1" == "-l" ]]; then
        if [ -z "$2" ]; then
            command mpv --loop-playlist ./
        else
            shift 1
            command mpv --loop-playlist "$@"
        fi
    else
        command mpv "$@"
    fi
}

# OTHER {{{1

# Use Vi mode
set -o vi

# Exports
source $HOME/.profile

# PROMPT
PS1='\[\e[1m\]\u@\h:\[\033[90m\]\w\[\033[0m\]\[\033[1m\]\$\[\e[0m\] '

# vim: fdm=marker foldenable:
