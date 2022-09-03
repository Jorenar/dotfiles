if [ ! -x "$(command -v fzf)" ]; then
    return
fi

s="" # shell
[ -n "$BASH" ]     && s="bash"
[ -n "$ZSH_NAME" ] && s="zsh"

# Use fzf keybindings
if [ -n "$s" ] && [ -f "/usr/share/fzf/key-bindings.$s" ]; then
    source "/usr/share/fzf/key-bindings.$s"
fi

export FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"