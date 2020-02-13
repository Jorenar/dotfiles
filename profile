# ~/.PROFILE #

# --- XDG ---
export XDG_DOTFILES_DIR="$(dirname $(readlink -f $HOME/.profile))"
source $XDG_DOTFILES_DIR/_XDG

# Japanese input
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

# Default editor
export EDITOR=vim

# man
export MANPAGER="vim -M +MANPAGER - +'set colorcolumn= nonumber laststatus=0'"
export MANWIDTH=80

# Set Qt to use GTK theme
export QT_QPA_PLATFORMTHEME="gtk2"

# GTK3 theme
export GTK_THEME="$(grep gtk-theme-name $GTK2_RC_FILES | cut -d'"' -f 2)"

# Set default terminal for i3
export TERMINAL=xterm

# Enable automatic `startx`
export AUTO_STARTX

# Enable GPG agent
export GPG_AGENT_INFO

# VITASDK
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH
