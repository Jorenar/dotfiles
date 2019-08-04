# ~/.PROFILE #

# DOTFILES dir
export DOTFILES="$HOME/dotfiles"

# XDG
source $DOTFILES/xdg

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

# Set default terminal for i3
export TERMINAL=xterm

# Activate 'lesspipe'
export LESSOPEN

# Enable extensions for pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Enable automatic `startx`
export AUTO_STARTX

# Enable GPG agent
export GPG_AGENT_INFO

# VITASDK
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# GTK3 theme
export GTK_THEME=Numix-Dark
