#!sh

if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
    if [ -e /usr/share/git/completion/git-prompt.sh ]; then
        GIT_PS1_SHOWDIRTYSTATE=yes
        GIT_PS1_SHOWSTASHSTATE=yes
        GIT_PS1_SHOWUNTRACKEDFILES=yes
        GIT_PS1_SHOWCONFLICTSTATE=yes
        . /usr/share/git/completion/git-prompt.sh
    fi
fi

if ! type __git_ps1 > /dev/null 2>&1; then
    __git_ps1 () {
        b="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        # shellcheck disable=SC2059
        [ -n "$b" ] && printf "$1" "$b"
    }
fi

_ps1_os_name () {
    case "$(uname -s)" in
        Linux)
            [ -n "$WSL_DISTRO_NAME" ] && echo "$WSL_DISTRO_NAME" && return
            awk -F= '$1=="ID" { gsub(/"/, "", $2); print $2 }' /etc/*release
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
