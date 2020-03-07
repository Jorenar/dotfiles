# PROFILE #
# vim: ft=sh fdm=marker fen

# ENV VARIABLES {{{1

if [ -n "$BASH" ]; then
    _THIS=$BASH_SOURCE
elif [ -n "$ZSH_NAME" ]; then
    _THIS=${(%):-%x}
elif [ -n "$TMOUT" ]; then
    _THIS=${.sh.file}
elif [ "${0##*/}" = "-dash" -o "${0##*/}" = "dash" ]; then
    x=$(lsof -p $$ -Fn0 | tail -1); _THIS=${x#n}
else
    _THIS=$0
fi

export XDG_DOTFILES_DIR="$(dirname $(realpath $_THIS))"; unset _THIS

. $XDG_DOTFILES_DIR/env_variables

# AUTOSTART {{{1
for script in $XDG_DOTFILES_DIR/autostart/*.sh; do
    . "$script"
done

# Source {{{1

# Source local additional env
[ -f $XDG_LOCAL_HOME/supp/profile ] && . $XDG_LOCAL_HOME/supp/profile

# If Bash, then bashrc
if [ -n "$BASH" ]; then
    [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
    [ -f "$XDG_CONFIG_HOME/bash/bashrc" ] && . "$XDG_CONFIG_HOME/bash/bashrc"
fi
