#!/usr/bin/env sh

declare DIR="$(dirname $(realpath $0))/wrappers"

chmodX() {
    command chmod +x $DIR/$1
}

chmodX audacity
chmodX dosbox
chmodX firefox
chmodX itch
chmodX ssh
chmodX ssh-copy-id
chmodX steam
