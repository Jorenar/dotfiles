# basics {{{1

export HOSTNAME="${HOSTNAME:-$(uname -n)}"
export TMPDIR="${TMPDIR:-/tmp}"

# Virtual terminal number (if not set already by PAM)
export XDG_VTNR="${XDG_VTNR:-$(tty | sed 's/[^0-9]*//g')}"

# XDG dirs {{{1

export XDG_CACHE_HOME="$HOME/.local/cache"
export XDG_CONFIG_HOME="$HOME/.local/config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"

if [ -f "$XDG_CONFIG_HOME"/user-dirs.dirs ]; then
    eval "$(sed 's/^[^#].*/export &/g;t;d' "$XDG_CONFIG_HOME"/user-dirs.dirs)"
fi


export CHKTEXRC="$XDG_CONFIG_HOME/chktex"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export ICEAUTHORITY="$XDG_STATE_HOME/ICEauthority"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export TEXMFHOME="$HOME/.local/lib/texmf"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export WINEPREFIX="$XDG_DATA_HOME/wine"

if [ -x "$(command -v vim)" ]; then
    [ "$(vim --clean -es +'exec "!echo" has("patch-9.1.0327")' +q)" = 0 ] && \
        export VIMINIT="so $XDG_CONFIG_HOME/vim/vimrc"
fi

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/config.py"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/__pycache__"

export PIPX_HOME="$HOME"/.local/opt/pipx
export PIPX_BIN_DIR="$PIPX_HOME"/bin
export PIPX_MAN_DIR="$PIPX_HOME"/man

export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export XENVIRONMENT="$XDG_CONFIG_HOME/X11/Xresources"

export ENV="$XDG_CONFIG_HOME/sh/shrc"  # sh, ksh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export BASH_COMPLETION_USER_DIR
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/bash-completion/bash_completion"

pathmunge BASH_COMPLETION_USER_DIR "$XDG_DATA_HOME/bash-completion"
pathmunge BASH_COMPLETION_USER_DIR "$XDG_CONFIG_HOME/bash-completion"
pathmunge BASH_COMPLETION_USER_DIR "$XDG_CONFIG_HOME/bash/bash-completion"

# default programs {{{1

export BROWSER="firefox"
export EDITOR="vim"
export MANPAGER="vim +'sil! %s/‐/-/g' +MANPAGER -"
export PAGER="less"
export TERMINAL="xterm"
export VISUAL="$EDITOR"

# dev {{{1

pathmunge "/usr/lib/ccache"
pathmunge "/usr/lib/ccache/bin"

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

# PATH {{{1

pathmunge "$HOME/.local/bin"

for opt in "$HOME"/.local/opt/*/bin "$HOME"/.local/opt/*/*/bin; do
    [ -d "$opt" ] && pathmunge "$opt"
done

if [ -n "$WSL_DISTRO_NAME" ]; then
    pathmunge "/mnt/c/Windows/System32"
    pathmunge "/mnt/c/Windows/System32/Wbem"
    pathmunge "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
fi

# options {{{1

export FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"
export LESS="-FXRS"
export LESSHISTFILE=-
export MOZ_USE_XINPUT2=1 # enable touchscreen in Firefox
export QT_QPA_PLATFORMTHEME=qt5ct
export VNC_VIA_CMD='ssh -f -L "$L":"$H":"$R" "$G" sleep 20'
export WINEDEBUG="-all" # suppress Wine debug informations

export WSLENV
pathmunge WSLENV "TMUX"

# shell history, the same set in shrc
export HISTSIZE=
export HISTFILE="$XDG_STATE_HOME/$(basename -- "${0#-*}")_history"

export SH_HIST_SAV
pathmunge "$XDG_CONFIG_HOME/sh/history.sav"
