# ZSHRC #

# Enable completion
autoload -Uz compinit && compinit

# "Template" for prompt
prompt_="%B%n@%m:%F{8}%~%f%#%b "

HISTSIZE=500

# Source 'profile' file
if [ $DISPLAY ] && [ -z $TMUX ]; then # prevents "source looping"
    source $XDG_DOTFILES_DIR/profile
fi

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
    PS1="${${KEYMAP/vicmd/(vi)}/(main|viins)/}$prompt_"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
