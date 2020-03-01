#!/usr/bin/env sh

# `linking` function won't work if this file isn't sourced from main install script

# Check if user has sudo privileges {{{1
prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || grep -q '^sudo:' <<< "$prompt_sudo"; then
    is_sudo=true
else
    is_sudo=false
fi

# profile file {{{1
installing=false
if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        read -p 'Do you wish to install root patches for XDG support for 'profile' file? [y/N] ' -n 1 -r; echo
        if [ $REPLY = "y" -o $REPLY = "Y" ]; then
            installing=true
        fi
    fi
else
    installing=done
fi

if [ $installing == "true" ]; then
    sudo ln -sf $DIR/_XDG/patch/profile_xdg.sh /etc/profile.d/profile_xdg.sh
elif [ $installing != done ]; then
    linking  profile  $HOME/.profile
fi

# Bash {{{1
installing=false
if which bash &> /dev/null; then
    A='[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"'
    if ! grep -Fxq "$A" /etc/bash.bashrc; then
        if [ $is_sudo = true ]; then
            read -p 'Do you wish to install root patches for XDG support for Bash? [y/N] ' -n 1 -r; echo
            if [ $REPLY = "y" -o $REPLY = "Y" ]; then
                installing=true
            fi
        fi
    else
        installing=done
    fi
fi

if [ $installing = true ]; then
    sudo sh -c "printf '\n# Source bashrc from XDG location\n$A' >> /etc/bash.bashrc"
elif [ $installing != done ]; then
    linking  bashrc  $HOME/.bashrc
fi

# {{{1
# vim: fdm=marker fen
