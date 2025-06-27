# basics {{{1

export TMPDIR="${TMPDIR:-/tmp}"

# Virtual terminal number (if not set already by PAM)
export XDG_VTNR="${XDG_VTNR:-$(tty | sed 's/[^0-9]*//g')}"

# Windows Subsystem for Linux
if [ -n "$WSL_DISTRO_NAME" ] && [ -z "$USERPROFILE" ]; then
    export USERPROFILE="$(
        cd /mnt/c/Windows/System32 || exit
        ./cmd.exe /c 'echo %USERPROFILE%' 2> /dev/null | \
            sed -e 's,\r,,g' -e 's,\\,/,g' -e 's,^C:,/mnt/c,'
    )"

    export WSLENV
    pathmunge WSLENV "TMUX"
fi

# XDG dirs {{{1

export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_CONFIG_HOME="$HOME/.local/config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"

[ -f "$XDG_CONFIG_HOME"/user-dirs.dirs ] && \
    { set -a; . "$XDG_CONFIG_HOME"/user-dirs.dirs; set +a; }

export CARGO_HOME="$HOME"/.local/opt/pkg/cargo
export CHKTEXRC="$XDG_CONFIG_HOME/chktex"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export ELECTRUMDIR="$XDG_DATA_HOME"/electrum
export GDBHISTFILE="$XDG_STATE_HOME"/gdb_history
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export ICEAUTHORITY="$XDG_STATE_HOME/ICEauthority"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export TEXMFHOME="$HOME/.local/lib/texmf"
export VD_DIR="$XDG_DATA_HOME"/visidata
export W3M_DIR="$XDG_DATA_HOME/w3m"
export WINEPREFIX="$XDG_DATA_HOME/wine"

export PYTHON_HISTORY="$XDG_STATE_HOME"/python_history
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME"/__pycache__
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/config.py

export PIPX_HOME="$HOME"/.local/opt/pkg/pipx
export PIPX_BIN_DIR="$PIPX_HOME"/bin
export PIPX_MAN_DIR="$PIPX_HOME"/man

export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export GOPATH="$HOME"/.local/opt/pkg/go

export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XAPPLRESDIR="$XDG_CONFIG_HOME/X11/"

export ENV="$XDG_CONFIG_HOME/sh/shrc"  # sh, ksh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export BASH_COMPLETION_USER_DIR
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash-completion/bash_completion"

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

export BROWSER="firefox"
export EDITOR="vim"
export MANPAGER="vim +'sil! %s/‐/-/g' +MANPAGER -"
export PAGER="less"
export TERMINAL="xterm"
export VISUAL="$EDITOR"

# dev {{{1

export C_INCLUDE_PATH
pathmunge C_INCLUDE_PATH "$HOME/.local/lib/include"

for v in ASAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS; do
    export "${v?}"
    pathmunge "$v" "abort_on_error=1"
    pathmunge "$v" "halt_on_error=1"
done

pathmunge ASAN_OPTIONS detect_stack_use_after_return=1


export PYTHONPATH
pathmunge PYTHONPATH "$HOME/.local/lib/python/site-packages/"

# options {{{1

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
export FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"
export KM_LAUNCHER="fuzzel -d"
export KM_SELECTIONS="clipboard"
export LESS="-FXRS"
export LESSHISTFILE=-
export MOZ_USE_XINPUT2=1 # enable touchscreen in Firefox
export NO_AT_BRIDGE=1 # don't launch at-spi2-registryd
export QT_QPA_PLATFORMTHEME=qt5ct
export VNC_VIA_CMD='ssh -f -L "$L":"$H":"$R" "$G" sleep 20'
export WINEDEBUG="-all" # suppress Wine debug informations

# shell history, the same set in shrc
export HISTSIZE=
export HISTFILE="$XDG_STATE_HOME/$(basename -- "${0#-*}")_history"

export SH_HIST_SAV
pathmunge SH_HIST_SAV "$XDG_CONFIG_HOME/sh/history.sav"
