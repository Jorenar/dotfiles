# shellcheck shell=sh
# shellcheck disable=SC2034

set -a  # enable allexport

# basics {{{1

LANG="${LANG:-C.UTF-8}"
TMPDIR="${TMPDIR:-/tmp}"

# Virtual terminal number (if not set already by PAM)
XDG_VTNR="${XDG_VTNR:-$(tty | sed 's/[^0-9]*//g')}"

# Windows Subsystem for Linux
if [ -n "$WSL_DISTRO_NAME" ] && [ -z "$USERPROFILE" ]; then
    USERPROFILE="$(
        cd /mnt/c/Windows/System32 || exit
        ./cmd.exe /c 'echo %USERPROFILE%' 2> /dev/null | \
            sed -e 's,\r,,g' -e 's,\\,/,g' -e 's,^C:,/mnt/c,'
    )"
    pathmunge WSLENV "TMUX"
fi

# XDG dirs {{{1

XDG_CACHE_HOME="$HOME/.local/cache"
XDG_CONFIG_HOME="$HOME/.local/config"
XDG_STATE_HOME="$HOME/.local/state"
XDG_DATA_HOME="$HOME/.local/share"

. "$XDG_CONFIG_HOME"/user-dirs.dirs 2> /dev/null

CARGO_HOME="$HOME"/.local/opt/pkg/cargo
CHKTEXRC="$XDG_CONFIG_HOME/chktex"
CLIPHIST_DB_PATH="$XDG_STATE_HOME"/cliphist.db
CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
ELECTRUMDIR="$XDG_DATA_HOME"/electrum
ENV="$XDG_CONFIG_HOME/sh/shrc"  # sh, ksh
GDBHISTFILE="$XDG_STATE_HOME"/gdb_history
GNUPGHOME="$XDG_DATA_HOME/gnupg"
GOMODCACHE="$XDG_CACHE_HOME"/go/mod
GOPATH="$HOME"/.local/opt/pkg/go
GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
GRIPHOME="$XDG_CONFIG_HOME/grip"
ICEAUTHORITY="$XDG_STATE_HOME/ICEauthority"
IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history
NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
PYTHON_HISTORY="$XDG_STATE_HOME"/python_history
PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME"/__pycache__
PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/config.py
RANDFILE="$XDG_CACHE_HOME/rnd"
SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
TEXMFHOME="$HOME/.local/lib/texmf"
VD_DIR="$XDG_DATA_HOME"/visidata
W3M_DIR="$XDG_DATA_HOME/w3m"
WINEPREFIX="$XDG_DATA_HOME/wine"
XAPPLRESDIR="$XDG_CONFIG_HOME/X11/"
XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
ZDOTDIR="$XDG_CONFIG_HOME/zsh"

PIPX_HOME="$HOME"/.local/opt/pkg/pipx
PIPX_BIN_DIR="$PIPX_HOME"/bin
PIPX_MAN_DIR="$PIPX_HOME"/man

BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash-completion/bash_completion"
pathmunge BASH_COMPLETION_USER_DIR "$XDG_DATA_HOME/bash-completion"
pathmunge BASH_COMPLETION_USER_DIR "$XDG_CONFIG_HOME/bash-completion"
pathmunge BASH_COMPLETION_USER_DIR "$XDG_CONFIG_HOME/bash/bash-completion"

# PATH {{{1

if [ -n "$WSL_DISTRO_NAME" ]; then
    pathmunge "/mnt/c/Windows/System32"
    pathmunge "/mnt/c/Windows/System32/Wbem"
    pathmunge "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
    [ -n "$USERPROFILE" ] && \
        pathmunge "$USERPROFILE/AppData/Local/Microsoft/WindowsApps"
fi

pathmunge "/usr/lib/ccache"
pathmunge "/usr/lib/ccache/bin"

for opt in "$HOME"/.local/opt/*/bin; do
    [ -d "$opt" ] && pathmunge "$opt"
done

for opt in "$HOME"/.local/opt/*/*/bin; do
    [ -d "$opt"/../../bin ] && continue
    [ -d "$opt" ] && pathmunge "$opt"
done

pathmunge "$HOME"/.local/bin

# default programs {{{1

PAGER="less"

if command -v vim > /dev/null; then
    EDITOR="vim"
    VISUAL="$EDITOR"
    MANPAGER="vim +'sil! %s/‐/-/g' +MANPAGER -"
fi

if command -v xterm > /dev/null; then
    TERMINAL="xterm"
fi

if command -v firefox > /dev/null; then
    BROWSER="firefox"
fi

# dev {{{1

pathmunge C_INCLUDE_PATH "$HOME/.local/lib/include"

for v in ASAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS; do
    pathmunge "$v" "abort_on_error=1"
    pathmunge "$v" "halt_on_error=1"
done
pathmunge ASAN_OPTIONS detect_stack_use_after_return=1

pathmunge PYTHONPATH "$HOME/.local/lib/python/site-packages/"

# options {{{1

DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"
KM_LAUNCHER="fuzzel -d"
KM_SELECTIONS="clipboard"
LESS="-FXRS"
LESSHISTFILE=-
MOZ_USE_XINPUT2=1 # enable touchscreen in Firefox
NO_AT_BRIDGE=1 # don't launch at-spi2-registryd
QT_QPA_PLATFORMTHEME=qt5ct
VNC_VIA_CMD='ssh -f -L "$L":"$H":"$R" "$G" sleep 20'
WINEDEBUG="-all" # suppress Wine debug informations

# shell history, the same set in shrc
HISTSIZE=
HISTFILE="$XDG_STATE_HOME/$(basename -- "${0#-*}")_history"

pathmunge SH_HIST_SAV "$XDG_CONFIG_HOME/sh/history.sav"

# }}}1

set +a  # disable allexport
