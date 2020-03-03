#!/usr/bin/env sh
# vim: fdm=marker fen

# `linking` function won't work if this file isn't sourced from main install script

# chmod wrappers {{{1

shopt -s extglob
chmod +x $DIR/_XDG/wrappers/!(*.disactivated)
shopt -u extglob

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
