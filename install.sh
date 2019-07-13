#!/bin/bash

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link
# 3rd argument - deactivation flag "X"
#                (will delete link if exist)

# ------------------------------------------------

if [ -z $XDG_CONFIG_HOME ]; then
    declare XDG_CONFIG_HOME="$HOME/.config"
fi

declare dotfiles_dir="$(dirname $(realpath $0))"
declare force_flag=$1
declare vim_dir=$XDG_CONFIG_HOME/nvim

# ------------------------------------------------

linking() {
    if [[ $3 == "X" ]]; then
        if [[ -L $2 && "$(readlink -f $2)" == "$dotfiles_dir/$1" ]]; then
            rm $2
        fi
    else
        if [[ $force_flag == "-f" ]]; then
            mkdir -p $HOME/dotfiles.old/
            mv "$2" "$HOME/dotfiles.old/"
            echo "Moved file $2 to directory $HOME/dotfiles.old/"
        fi

        if [ ! -e $2 ]; then
            mkdir -p "$(dirname $2)"
            ln -sf $dotfiles_dir/$1 $2
        fi
    fi
}

# ------------------------------------------------

linking  bashrc                 $HOME/.bash_profile
linking  bashrc                 $HOME/.bashrc
linking  inputrc                $HOME/.inputrc
linking  mailcap                $HOME/.mailcap
linking  muttrc                 $HOME/.muttrc
linking  myclirc                $HOME/.myclirc                      "X"
linking  profile                $HOME/.profile
linking  tmux.conf              $HOME/.tmux.conf
linking  xinitrc                $HOME/.xinitrc
linking  Xresources             $HOME/.Xresources

linking  git/gitconfig          $XDG_CONFIG_HOME/.gitconfig
linking  gtk/gtk3_settings.ini  $XDG_CONFIG_HOME/gtk-3.0/settings.ini
linking  gtk/gtkrc-2.0          $HOME/.gtkrc-2.0
linking  i3/                    $HOME/.i3
linking  mpv/                   $XDG_CONFIG_HOME/mpv
linking  vim/init.vim           $HOME/.vimrc

linking  other/feh_keys         $XDG_CONFIG_HOME/feh/keys
linking  other/gpg-agent.conf   $HOME/.gnupg/gpg-agent.conf
linking  other/xdg-user.dirs    $XDG_CONFIG_HOME/xdg-user.dirs
linking  other/zathurarc        $XDG_CONFIG_HOME/zathura/zathurarc

for V in vim/*; do
    linking $V $vim_dir/"$(basename $V)"
done
