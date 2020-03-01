if [ "$0" == "bash" -o "$0" == "-bash" ]
then
    THIS="${BASH_SOURCE[0]}"
elif [ "$0" == "zsh"  -o "$0" == "-zsh" ]
then
    THIS=${(%):-%N}
fi

DIR="$(dirname $(dirname $(dirname $(realpath $THIS))))"

[ -f "$DIR/profile" ] && . "$DIR/profile"
