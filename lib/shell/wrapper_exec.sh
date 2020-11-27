wrapper_exec() {
    bs="$(basename "$0" | sed 's/-/_/')"
    execChainEnvVar=execution_chain_$bs

    if [ "$1" = "--P" ]; then
        PREFIX="$2"
        shift 2
    fi

    for dir in $(echo "$PATH" | tr ":" "\n" | grep -Fxv "$(dirname $0)"); do
        f="$dir/$(basename $0)"
        if [ -x "$f" ]; then
            i=$(stat -c "%i" "$f")
            if [ "${!execChainEnvVar#*$i}" = "${!execChainEnvVar}" ]; then
                export "$execChainEnvVar"="${!execChainEnvVar}:$i"
                unset i f
                exec $PREFIX "$dir/$(basename $0)" "$@"
            fi
        fi
    done

    echo "$0: error: Wrapped command does not exist" >&2
}
