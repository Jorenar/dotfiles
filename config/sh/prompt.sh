#!sh

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

if ! type __git_ps1 > /dev/null 2>&1; then
    __git_ps1 () {
        b="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        # shellcheck disable=SC2059
        [ -n "$b" ] && printf "$1" "$b"
    }
fi

_ps1_container () {
    ret=
    if [ -f /run/.containerenv ]; then
        ret="podman"
    elif [ -f /.dockerenv ] || [ -f /run/.dockerenv ]; then
        ret="docker"
    fi
    [ -n "$ret" ] && echo " | $ret"
}

_ps1_os_name () {
    case "$(uname -s)" in
        Linux)
            [ -n "$WSL_DISTRO_NAME" ] && echo "$WSL_DISTRO_NAME" && return
            printf '%s%s' \
                "$(awk -F= '$1=="ID" { gsub(/"/, "", $2); print $2 }' /etc/*release)" \
                "$(_ps1_container)"
            ;;
        *) uname -s ;;
    esac
}

_ps1_jobs () {
    # shellcheck disable=SC2059
    [ -n "$(jobs -p)" ] && printf "$1" "$(jobs | wc -l)"
}

_ps1 () {
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
        "$(__git_ps1 ' | %s')"
    printf "\001\033[0m\002"
    printf "\n"

    printf '\001\033[36m\002%s\001\033[0m\002 ' "${1:-$}"
}

PS1='$(_ps1)'
