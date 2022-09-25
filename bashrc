# BASHRC #

# Source basic shell config
source "$XDG_CONFIG_HOME/shell/shrc"

# Enable programmable completion features
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

# Search history with Vim
bind -m vi-command -x '"\C-r": __HistR'
__HistR() {
    tmp="$(mktemp -u)"

    history -w /dev/stdout | sed '1!x;H;1h;$!d;g' | vim --clean --not-a-term +"
      set nowrap
      set hlsearch incsearch ignorecase
      set noswapfile noswf viminfo=

      nnoremap <CR> :.wq $tmp<CR>
      nnoremap q :cquit!<CR>
    " -R -
    echo -ne '\033[1A'

    [ -e "$tmp" ] || return $?
    output="$(cat "$tmp")"
    command rm "$tmp"

    READLINE_LINE=${output#*$'\t'}

    if [ -z "$READLINE_POINT" ]; then
        echo "$READLINE_LINE"
    else
        READLINE_POINT=0x7fffffff
    fi

    unset tmp output
}

# Enable extended globbing
shopt -s extglob

# Don't keep duplicates in history
export HISTCONTROL=ignoreboth:erasedups

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Fix PROMPT
PS1='\['"$(sed 's/\x1B\[[0-9;]*[a-zA-Z]/\\001&\\002/g' <<< "$PS1")"
