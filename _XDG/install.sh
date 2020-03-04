#!/usr/bin/env sh
# vim: fdm=marker fen

# Warning! {{{1
if [ -z "$DIR" ]; then
    echo 'This file must be used as source file in $XDG_DOTFILES/install.sh'
    exit
fi

# WRAPPERS {{{1

chmod +x $DIR/_XDG/wrappers/*

# Link wrappers
for exe in $DIR/_XDG/wrappers/*; do
    [ -e $exe ] && which $(basename $exe) &> /dev/null && linking  _XDG/wrappers/$(basename $exe)  $_XDG_WRAPPERS/$(basename $exe)
done

linking  _XDG_/wrappers/ssh  $_XDG_WRAPPERS/scp

# Generate FAKEHOME wrappers
while IFS= read -r exe; do
    exe="$(echo $exe | cut -f1 -d'#')"
    [ -n "$exe" ] && which $exe &> /dev/null && linking  _XDG/wrappers/_xdg_fakehome.sh  $_XDG_WRAPPERS/$exe
done < "$DIR/_XDG/fakehome.list"


# Linking desktop entries {{{1

linking _XDG/desktop_entries/firefox.desktop $XDG_DATA_HOME/applications/firefox.desktop

# }}}
# Sudo patches {{{1
# Check if user has sudo privileges {{{2
prompt_sudo=$(sudo -nv 2>&1)
if [ $? -eq 0 ] || echo "$prompt_sudo" | grep -q '^sudo:'; then
    is_sudo=true
else
    is_sudo=false
fi

# profile file {{{2
status=no
if [ ! -f /etc/profile.d/profile_xdg.sh ]; then
    if [ $is_sudo = true ]; then
        read -p 'Do you wish to install root patches for XDG support for 'profile' file? [y/N] ' -r REPLY
        if [ -n "$REPLY" ] && [ $REPLY = "y" -o $REPLY = "Y" ]; then
            status=installing
        fi
    fi
else
    status=installed
fi

if [ "$status" = "installing" ]; then
    sudo ln -sf $DIR/_XDG/profile_xdg.sh /etc/profile.d/profile_xdg.sh
elif [ $status != installed ]; then
    linking  profile  $HOME/.profile
fi

# Bash {{{2
status=no
if which bash &> /dev/null; then
    A='[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"'
    if ! grep -Fxq "$A" /etc/bash.bashrc; then
        if [ $is_sudo = true ]; then
            read -p 'Do you wish to install root patches for XDG support for Bash? [y/N] ' -r REPLY
            if [ -n "$REPLY" ] && [ $REPLY = "y" -o $REPLY = "Y" ]; then
                status=installing
            fi
        fi
    else
        status=installed
    fi
fi

if [ "$status" = "installing" ]; then
    sudo sh -c "printf '\n# Source bashrc from XDG location\n$A' >> /etc/bash.bashrc"
elif [ "$status" != "installed" ]; then
    linking  bashrc  $HOME/.bashrc
fi
