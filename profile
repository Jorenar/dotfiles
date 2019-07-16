# ~/.PROFILE #

# DOTFILES dir
export DOTFILES="$HOME/dotfiles"

# Japanese input
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

# Default editor
export EDITOR=nvim

# Default manpager
export MANPAGER="nvim +Man!"

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

# Python startup config file
export PYTHONSTARTUP="$DOTFILES/other/python_config.py"

# XDG --------------------------------------------

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"

# HISTORY FILES ----------------------------------

export HISTORY_DIR=$HOME/.history_files

export HISTFILE=$HISTORY_DIR/bash
export SQLITE_HISTORY=$HISTORY_DIR/sqlite
export LESSHISTFILE=-
