#!/usr/bin/env sh

gitclone() {
    git clone --recurse --depth=1 --single-branch "$1" 2> /dev/null
}

gitclone https://github.com/Jorengarenar/joren.sh.d.git

if [ -z "$(ldconfig -p | grep 'jorenc')" ]; then
    if [ ! -e "$XDG_LIB_DIR/c/libjorenc.so" ]; then
        gitclone https://github.com/Jorengarenar/libJORENc.git
    fi
fi
