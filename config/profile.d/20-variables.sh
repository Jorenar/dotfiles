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


export CHKTEXRC="$XDG_CONFIG_HOME"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export ICEAUTHORITY="$XDG_STATE_HOME/ICEauthority"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export SQLITE_HISTORY="$XDG_STATE_HOME/sqlite_history"
export TEXMFHOME="$HOME/.local/lib/texmf"
export VIMINIT="so $XDG_CONFIG_HOME/vim/vimrc"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export WINEPREFIX="$XDG_DATA_HOME/wine"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/config.py"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/__pycache__"
export PIPX_BIN_DIR="$PIPX_HOME"/bin

export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/completion"
export ENV="$XDG_CONFIG_HOME/sh/shrc"  # sh, ksh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

# default programs {{{1

export BROWSER="firefox"
export EDITOR="vim"
export MANPAGER="vim -M +MANPAGER -"
export PAGER="less"
export TERMINAL="xterm"
export VISUAL="$EDITOR"

# dev {{{1

pathmunge "/usr/lib/ccache/bin"

export C_INCLUDE_PATH
pathmunge C_INCLUDE_PATH "$HOME/.local/lib/include"

for v in ASAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS; do
    export "$v"="abort_on_error=1:halt_on_error=1"
done

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
export GPG_AGENT_INFO # enable GPG agent
export LESS="-FXRS"
export LESSHISTFILE=-
export MOZ_USE_XINPUT2=1 # enable touchscreen in Firefox
export QT_QPA_PLATFORMTHEME=qt5ct
export WINEDEBUG="-all" # suppress Wine debug informations
