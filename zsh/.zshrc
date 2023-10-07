# ZSHRC #

# Source basic shell config
setopt NULL_GLOB
source "$ENV"

# Enable completion (+ separate path for .zcompdump file)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zcompdump"

# Disable "No match found" message
setopt +o nomatch

# combine Emacs with vi mode
bindkey -e
bindkey -e '\e' vi-cmd-mode


# PROMPT ---------------------

# Fix prompt
setopt PROMPT_SUBST

# Display Vi mode
PS1="+$PS1"
function zle-line-init zle-keymap-select {
    PS1="${${KEYMAP/vicmd/:}/(main)/@}${PS1:1}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
