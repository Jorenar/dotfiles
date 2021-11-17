# ZSHRC #

# Source basic shell config
source $XDG_CONFIG_HOME/shell/shrc

# Enable completion (+ separate path for .zcompdump file)
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zcompdump"

# Disable "No match found" message
setopt +o nomatch

# Vi mode
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward


# PROMPT ---------------------

# Variable to hold title part of PS1
PS1_WIN_TITLE="$(echo $PS1 | sed $'s/\007.*//')\007"

# Fix prompt
setopt PROMPT_SUBST
PS1=" $(sed -e $'s/.*\007//' -e 's/\x1B\[[0-9;]*[a-zA-Z]/%{&%}/g' <<< $PS1)"
#    ^ for Vi mode indicator

# Window title
case $TERM in
    xterm*|rxvt*|screen*)
        precmd () {print -Pn "$PS1_WIN_TITLE" }
        ;;
esac

# Display Vi mode
function zle-line-init zle-keymap-select {
    PS1="${${KEYMAP/vicmd/:}/(main|viins)/+}${PS1:1}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
