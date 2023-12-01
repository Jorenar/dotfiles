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

# relocating dirs and files {{{1

export HISTORY_DIR="$XDG_STATE_HOME/history"

#  ~history {{{2
export LESSHISTFILE=-
export MYCLI_HISTFILE="$HISTORY_DIR/mycli"
export MYSQL_HISTFILE="$HISTORY_DIR/mysql"
export NODE_REPL_HISTORY="$HISTORY_DIR/node_repl_history"
export SQLITE_HISTORY="$HISTORY_DIR/sqlite"

#  ~misc {{{2

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CHKTEXRC="$XDG_CONFIG_HOME"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export GIT_TEMPLATE_DIR="$XDG_CONFIG_HOME/git/template"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export ICEAUTHORITY="$XDG_STATE_HOME/ICEauthority"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export MYSQL_HOME="$XDG_CONFIG_HOME/mysql"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export R_ENVIRON_USER="$XDG_CONFIG_HOME/r/Renviron"
export RANDFILE="$XDG_CACHE_HOME/rnd"
export TEXMFHOME="$HOME/.local/lib/texmf"
export VIMINIT="so $XDG_CONFIG_HOME/vim/vimrc"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export WINEPREFIX="$XDG_DATA_HOME/wine"

#  Arduino {{{2
export ARDUINO_DIRECTORIES_DATA="$XDG_DATA_HOME/arduino"
export ARDUINO_DIRECTORIES_DOWNLOADS="$XDG_CACHE_HOME/arduino"
export ARDUINO_DIRECTORIES_USER="$HOME/.local/lib/arduino" # just treat it as directory for libraries

#  Ccache {{{2
export CCACHE_CONFIGPATH="$XDG_CONFIG_HOME/ccache/config"
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"

#  Emscripten {{{2
export EM_CACHE="$XDG_CACHE_HOME/emscripten"
export EM_CONFIG="$XDG_CONFIG_HOME/emscripten"

#  Golang {{{2
export GOBIN="$HOME/.local/bin"
export GOPATH="$XDG_DATA_HOME/go"

#  mailcap {{{2
export MAILCAP="$XDG_CONFIG_HOME/mailcap" # elinks, w3m
export MAILCAPS="$MAILCAP"   # Mutt, pine

#  Python {{{2
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/config.py"
export PYTHONUSERBASE="$HOME/.local"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/__pycache__"
export IPYTHONDIR="$XDG_DATA_HOME/ipython"

#  Ruby {{{2
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

#  Shells {{{2
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME/bash/completion"
export ENV="$XDG_CONFIG_HOME/sh/shrc"  # sh, ksh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

#  X11 {{{2
export XAUTHORITY="${XAUTHORITY:-"$XDG_RUNTIME_DIR/Xauthority"}"
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

export VITASDK="/usr/local/vitasdk"
pathmunge "$VITASDK/bin"

export DEVKITPRO="/opt/devkitpro"
export DEVKITARM="$DEVKITPRO/devkitARM"
export DEVKITPPC="$DEVKITPRO/devkitPPC"

pathmunge "/usr/lib/ccache/bin"

export C_INCLUDE_PATH
pathmunge C_INCLUDE_PATH "$HOME/.local/lib/include"
for v in ASAN_OPTIONS UBSAN_OPTIONS TSAN_OPTIONS; do
    export "$v"="abort_on_error=1:halt_on_error=1"
done

for r in "$XDG_DATA_HOME"/gem/ruby/*/bin; do
    [ -d "$r" ] && pathmunge "$r"
done

for p in "$PYTHONUSERBASE"/lib/python3*/site-packages; do
    [ -d "$p" ] && pathmunge PYTHONPATH "$p"
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

export MOZ_USE_XINPUT2=1 # enable touchscreen in Firefox
export WINEDEBUG="-all" # suppress Wine debug informations
export LESS="-FXRS"
export FZF_CTRL_T_OPTS="--preview '(cat {} || tree {}) 2> /dev/null | head -200'"

# ~ {{{1

# Japanese input
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"
export GTK_IM_MODULE="fcitx"

# Enable GPG agent
export GPG_AGENT_INFO
