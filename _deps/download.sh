#!/usr/bin/env sh

gitclone() {
    git clone --recurse --depth=1 --single-branch "$1" 2> /dev/null
}

gitclone https://github.com/Jorengarenar/joren.sh.d.git
gitclone https://github.com/Jorengarenar/libProgWrap.git

if [ -z "$(ldconfig -p | grep 'joren')" ]; then
    if [ ! -e "$XDG_LIB_DIR/c/libjoren.so" ]; then
        gitclone https://github.com/Jorengarenar/libJOREN.git
    fi
fi
