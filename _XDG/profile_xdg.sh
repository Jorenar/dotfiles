if [ -n "$BASH" ]; then
    THIS=$BASH_SOURCE
elif [ -n "$ZSH_NAME" ]; then
    THIS=${(%):-%x}
elif [ -n "$TMOUT" ]; then
    THIS=${.sh.file}
elif [ "${0##*/}" = "-dash" -o "${0##*/}" = "dash" ]; then
    x=$(lsof -p $$ -Fn0 | tail -1); THIS=${x#n}
else
    THIS=$0
fi

DIR="$(dirname $(dirname $(realpath $THIS)))"

[ -f "$DIR/profile" ] && . "$DIR/profile"
