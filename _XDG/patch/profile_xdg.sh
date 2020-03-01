[ "$0" == "bash" -o "$0" == "-bash" ] && [ -d "$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))" ] && . "$(dirname $(dirname $(realpath ${BASH_SOURCE[0]})))/profile"
[ "$0" == "zsh"  -o "$0" == "-zsh" ]  && [ -d "$(dirname $(dirname $(realpath ${(%):-%N})))" ] && . "$(dirname $(dirname $(realpath ${(%):-%N})))/profile"
