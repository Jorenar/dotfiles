# ZSHRC #

# Enable completion
autoload -Uz compinit && compinit

# "Template" for prompt
prompt_="%B%n@%m:%F{8}%~%f%#%b "

# History
HISTSIZE=500

# Source shells environment configs
source $XDG_DOTFILES_DIR/shrc

# Window title
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m:%~\a"}
        ;;
esac

# Vi mode
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

function zle-line-init zle-keymap-select {
    PS1="${${KEYMAP/vicmd/:}/(main|viins)/+}$prompt_"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
