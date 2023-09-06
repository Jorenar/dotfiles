# shellcheck disable=SC1090

[ ! -x "$(command -v fzf)" ] && return

s="" # shell
[ -n "$BASH" ]     && s="bash"
[ -n "$ZSH_NAME" ] && s="zsh"

# Use fzf keybindings
if [ -n "$s" ]; then
    if [ -f "/usr/share/fzf/key-bindings.$s" ]; then
        source "/usr/share/fzf/key-bindings.$s"
    elif [ -f "/usr/share/doc/fzf/examples/key-bindings.$s" ]; then
        source "/usr/share/doc/fzf/examples/key-bindings.$s"
    fi
fi

export FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"
