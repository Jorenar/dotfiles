# ZSHRC #

# Source shells environment configs
source $XDG_CONFIG_HOME/shell/shrc

# Enable completion
autoload -Uz compinit && compinit

# Vi mode
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward


# PROMPT

setopt PROMPT_SUBST

# "Template" for prompt
prompt_="%B%n@%m:%F{8}%~%f%#%b "

# Window title
case $TERM in
    xterm*|rxvt*|screen*)
        precmd () {print -Pn "\e]0;%n@%m:%~\a"}
        ;;
esac

# Display Vi mode
function zle-line-init zle-keymap-select {
    PS1="${${KEYMAP/vicmd/:}/(main|viins)/+}$prompt_" # there prompt is set
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
