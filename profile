# PROFILE #

# --- XDG ---

[ "$0" = "bash" -o "$0" = "-bash" ] && export XDG_DOTFILES_DIR="$(dirname $(realpath ${BASH_SOURCE[0]}))"
[ "$0" = "zsh"  -o "$0" = "-zsh"  ] && export XDG_DOTFILES_DIR="$(dirname $(realpath ${(%):-%N}))"

source $XDG_DOTFILES_DIR/_XDG

# Japanese input
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

# Default editor
export EDITOR=vim

# Default browser
export BROWSER=firefox

# Default terminal
export TERMINAL=xterm

# man
export MANPAGER="vim -M +MANPAGER - +'set colorcolumn= nonumber laststatus=0'"
export MANWIDTH=80

# Set Qt to use GTK theme
export QT_QPA_PLATFORMTHEME="gtk2"

# GTK3 theme
export GTK_THEME="$(grep gtk-theme-name $GTK2_RC_FILES | cut -d'"' -f 2)"

# Enable automatic `startx`
export AUTO_STARTX

# Enable GPG agent
export GPG_AGENT_INFO

# VITASDK
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Source shells environment configs
source $XDG_DOTFILES_DIR/shrc

if [ ! -f /tmp/executed_autostart ]; then
    $XDG_DOTFILES_DIR/autostart.sh
    touch /tmp/executed_autostart
fi

# vim: ft=sh
