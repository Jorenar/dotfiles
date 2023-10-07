# ZSHRC #

# Source basic shell config
setopt NULL_GLOB
source "${ENV:-$XDG_CONFIG_HOME/sh/shrc}"

# Enable completion (+ separate path for .zcompdump file)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zcompdump"

# Disable "No match found" message
setopt +o nomatch

# combine Emacs with vi mode
bindkey -e
bindkey -e '\e' vi-cmd-mode


# Display Vi mode in prompt
function zle-line-init zle-keymap-select {
    PS1="$(_ps1 | sed "s/^.*\\$/${${KEYMAP/vicmd/:}/(main)/@}&/")"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
