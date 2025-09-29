# shellcheck shell=sh

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    g=
    [ ! -e "$g" ] && g="/usr/share/git/completion/git-prompt.sh"
    [ ! -e "$g" ] && g="/usr/lib/git-core/git-sh-prompt"

    if [ -e "$g" ]; then
        GIT_PS1_SHOWDIRTYSTATE=yes
        GIT_PS1_SHOWSTASHSTATE=yes
        GIT_PS1_SHOWUNTRACKEDFILES=yes
        GIT_PS1_SHOWCONFLICTSTATE=yes
        . "$g"
    fi
    unset g
fi

_ps1_git () {
    [ "$(git config --bool prompt.fast 2> /dev/null)" != "true" ] && \
        command -v __git_ps1 > /dev/null && \
        __git_ps1 "$@" && return

    set -- "$1" "$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
    # shellcheck disable=SC2059
    [ -n "$2" ] && printf "$1" "$2"
}

_ps1_container () {
    if [ -f /run/.containerenv ]; then
        echo "podman"
    elif [ -f /.dockerenv ] || [ -f /run/.dockerenv ]; then
        echo "docker"
    fi
}

_ps1_os_name () {
    case "$(uname -s)" in
        Linux)
            [ -n "$WSL_DISTRO_NAME" ] && echo "$WSL_DISTRO_NAME" && return
            printf '%s%s' \
                "$(awk -F= '$1=="ID" { gsub(/"/, "", $2); print $2 }' /etc/*release)" \
                "$(d="$(_ps1_container)"; echo "${d:+" | $d"}")"
            ;;
        *) uname -s ;;
    esac
}

_ps1_jobs () {
    # shellcheck disable=SC2059
    [ -n "$(jobs -p)" ] && printf "$1" "$(jobs | wc -l)"
}

_ps1 () {
    printf "\001\033[?12h\002"  # cursor blinking

    printf '\001\033]0;%s@%s:%s\007\002' \
        "$(id -un)"  "$(uname -n)"  "$(echo "$PWD" | sed "s,^$HOME,~,")"

    printf "\001\033[38;5;240m\002"
    printf '[ %s | %s %s| %s@%s | %s%s ]' \
        "$(_ps1_os_name)" \
        "$(ps -p "$$" -o comm='' 2> /dev/null || echo "$0")" \
        "$(_ps1_jobs '{%d} ')" \
        "$(id -un)" \
        "$(uname -n)" \
        "$(echo "$PWD" | sed "s,^$HOME\(\/\|$\),~/,")" \
        "$(_ps1_git ' | %s')"
    printf "\001\033[0m\002"
    printf "\n"

    printf '\001\033[%sm\002%s\001\033[0m\002 ' "${PS1_COLOR:-36}" "${1:-$}"
}

PS1='$(_ps1)'
