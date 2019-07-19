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

# Python startup config file
export PYTHONSTARTUP="$DOTFILES/other/python_config.py"

# GTK
export GTK2_RC_FILES="$DOTFILES/other/gtkrc-2.0"
export GTK_THEME="Numix-Dark"

# XDG --------------------------------------------

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# HISTORY FILES ----------------------------------

export HISTORY_DIR=$XDG_CACHE_HOME/history_files

export HISTFILE=$HISTORY_DIR/bash
export SQLITE_HISTORY=$HISTORY_DIR/sqlite
export LESSHISTFILE=-
