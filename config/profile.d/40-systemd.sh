command -v systemctl > /dev/null || return

systemctl --user import-environment $(env | cut -d= -f1 | grep -w \
    -e 'BROWSER' \
    -e 'DOCKER_.*' \
    -e 'EDITOR' \
    -e 'GNUPGHOME' \
    -e 'GOBIN' \
    -e 'GOMODCACHE' \
    -e 'GOPATH' \
    -e 'IMAPFILTER_HOME' \
    -e 'NO_AT_BRIDGE' \
    -e 'PASSWORD_STORE_DIR' \
    -e 'PATH' \
    -e 'PYTHON.*' \
    -e 'TERMINAL' \
    -e 'TMPDIR' \
    -e 'VISUAL' \
    -e 'XAUTHORITY' \
    -e 'XDG_.*_DIR' \
    -e 'XDG_.*_HOME' \
)

[ ! -d "$XDG_CONFIG_HOME"/environment.d ] && \
    systemctl --user start unln-dotconfig

# vim: fdm=indent
