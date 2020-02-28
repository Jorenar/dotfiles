#!/usr/bin/env bash

# ------------------------------------------------

# 1st argument - file in dotfiles dir
# 2nd argument - location of link

# ------------------------------------------------

declare dotfiles_dir="$(dirname $(realpath $0))"

source $dotfiles_dir/_XDG

declare force_flag=$1

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

    if [ ! -z "$3" ]; then
        chmod "$3" "$2"
    fi
}

# ------------------------------------------------

prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || grep -q '^sudo:' <<< "$prompt_sudo"; then
    is_sudo=true
else
    is_sudo=false
fi

if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        read -p 'Do you wish to install root patches for XDG support for 'profile' file? [y/N]' -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo ln -sf $dotfiles_dir/patch/profile_xdg.sh /etc/profile.d/profile_xdg.sh
        else
            linking  profile  $HOME/.profile
        fi
    else
        linking  profile  $HOME/.profile
    fi
fi

if which bash &> /dev/null; then
    A='[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"'
    if ! grep -Fxq "$A" /etc/bash.bashrc || [ ! -f /etc/profile.d/profile_xdg.sh ]; then
        if [ $is_sudo = true ]; then
            read -p 'Do you wish to install root patches for XDG support for Bash? [y/N]' -n 1 -r; echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                sudo sh -c "printf '\n# Source bashrc from XDG location\n$A' >> /etc/bash.bashrc"
            else
                linking  bash/bashrc  $HOME/.bashrc
            fi
        else
            linking  bash/bashrc  $HOME/.bashrc
        fi
    fi
fi


linking  ssh_config        $HOME/.ssh/config

linking  htoprc            $XDG_CONFIG_HOME/htop/htoprc        -w
linking  mimeapps.list     $XDG_CONFIG_HOME/mimeapps.list
linking  user-dirs.dirs    $XDG_CONFIG_HOME/user-dirs.dirs
linking  zathurarc         $XDG_CONFIG_HOME/zathura/zathurarc

linking  feh/              $XDG_CONFIG_HOME/feh
linking  git/              $XDG_CONFIG_HOME/git
linking  i3/               $XDG_CONFIG_HOME/i3
linking  mpv/              $XDG_CONFIG_HOME/mpv

linking  bashrc            $BASH_HOME/bashrc
linking  gpg-agent.conf    $GNUPGHOME/gpg-agent.conf
linking  gtkrc-2.0         $GTK2_RC_FILES  # works properly, because _XDG is sourced
linking  inputrc           $INPUTRC
linking  npmrc             $NPM_CONFIG_USERCONFIG
linking  python_config.py  $PYTHONSTARTUP
linking  vim/              $VIMDOTDIR
linking  xinitrc           $XINITRC
linking  zshrc             $ZDOTDIR/.zshrc

linking  fonts/            $XDG_DATA_HOME/fonts
linking  themes/           $XDG_DATA_HOME/themes

for cfg in aerc/*; do
    linking "$cfg" $XDG_CONFIG_HOME/aerc/"$(basename $cfg)"
done

for firefox_profile in $HOME/.mozilla/firefox/*.default-release; do
    linking userContent.css "$firefox_profile/chrome/userContent.css"
done

chmod +x autostart.sh

# ------------------------------------------------

# linking  mailcap           $HOME/.mailcap
# linking  muttrc            $XDG_CONFIG_HOME/mutt/muttrc
# linking  myclirc           $HOME/.myclirc
# linking  newsboat/config   $XDG_CONFIG_HOME/newsboat/config
# linking  tmux.conf         $XDG_CONFIG_HOME/tmux/tmux.conf

# ------------------------------------------------
# vim: fen
