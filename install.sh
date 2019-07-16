#!/bin/bash

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link

# ------------------------------------------------

if [ -z $XDG_CONFIG_HOME ]; then
    declare XDG_CONFIG_HOME="$HOME/.config"
fi

declare dotfiles_dir="$(dirname $(realpath $0))"
declare force_flag=$1
declare vim_dir=$XDG_CONFIG_HOME/nvim

# ------------------------------------------------

linking() {
    if [[ $force_flag == "-f" ]]; then
        mkdir -p $HOME/dotfiles.old/
        mv "$2" "$HOME/dotfiles.old/"
        echo "Moved file $2 to directory $HOME/dotfiles.old/"
    fi

    if [ ! -e $2 ]; then
        mkdir -p "$(dirname $2)"
        ln -sf $dotfiles_dir/$1 $2
    fi
}

# ------------------------------------------------

linking  bashrc                 $HOME/.bash_profile
linking  bashrc                 $HOME/.bashrc
linking  fonts                  $HOME/.fonts
linking  inputrc                $HOME/.inputrc
linking  mailcap                $HOME/.mailcap
linking  profile                $HOME/.profile
linking  themes                 $HOME/.themes
linking  tmux.conf              $HOME/.tmux.conf
linking  xinitrc                $HOME/.xinitrc
linking  Xresources             $HOME/.Xresources
linking  gtk/gtkrc-2.0          $HOME/.gtkrc-2.0

linking  feh_keys               $XDG_CONFIG_HOME/feh/keys
linking  git/gitconfig          $XDG_CONFIG_HOME/git/config
linking  gtk/gtk3_settings.ini  $XDG_CONFIG_HOME/gtk-3.0/settings.ini
linking  muttrc                 $XDG_CONFIG_HOME/mutt/muttrc
linking  xdg-user.dirs          $XDG_CONFIG_HOME/xdg-user.dirs
linking  zathurarc              $XDG_CONFIG_HOME/zathura/zathurarc

linking  i3/                    $XDG_CONFIG_HOME/i3
linking  mpv/                   $XDG_CONFIG_HOME/mpv

linking  other/gpg-agent.conf   $HOME/.gnupg/gpg-agent.conf

for V in vim/*; do
    linking $V $vim_dir/"$(basename $V)"
done

# ------------------------------------------------

# linking  myclirc                $HOME/.myclirc
