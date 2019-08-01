# ~/.PROFILE #

# DOTFILES dir
export DOTFILES="$HOME/dotfiles"

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

# Enable extensions for pass
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

# Enable GPG agent
export GPG_AGENT_INFO

# VITASDK
export VITASDK=/usr/local/vitasdk
export PATH=$VITASDK/bin:$PATH

# Add dotfiles/bin to path
export PATH=$DOTFILES/bin:$PATH

# GTK3 theme
export GTK_THEME="$(grep gtk-theme-name $HOME/.gtkrc-2.0 | cut -d'"' -f 2)"

# XDG --------------------------------------------

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/config.py"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export VIMDOTDIR="$XDG_CONFIG_HOME/vim"
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export WINEPREFIX="$XDG_CONFIG_HOME/wine"

# HISTORY FILES --------------

export HISTORY_DIR=$XDG_CACHE_HOME/history_files

export HISTFILE=$HISTORY_DIR/bash
export SQLITE_HISTORY=$HISTORY_DIR/sqlite
export LESSHISTFILE=-
