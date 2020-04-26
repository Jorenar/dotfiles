#!/usr/bin/env sh

tagsdir="$XDG_DATA_HOME/tags"

generate() {
    file=$1
    lang=$2
    shift 2
    ctags -f "$tagsdir/$file" -R --kinds-$lang=+pxl --fields=+iaSmz --extras=+q --language-force=$lang "$@"
}

generate c   C   /usr/include
generate cpp C++ /usr/include/c++
