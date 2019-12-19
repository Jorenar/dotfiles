# ~/.PROFILE #

# --- XDG ---
source $HOME/.local/dotfiles/_XDG

# Japanese input
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

# Default editor
export EDITOR=vim

# Default manpager
export MANPAGER="vim -M +MANPAGER -"

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
