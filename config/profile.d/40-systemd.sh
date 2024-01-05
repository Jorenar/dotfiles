# Generate environmental variables
mkdir -p "$XDG_CONFIG_HOME"/environment.d && env \
    | grep \
        -e '^GNUPGHOME' \
        -e '^GOBIN' \
        -e '^IMAPFILTER_HOME' \
        -e '^PASSWORD_STORE_DIR' \
        -e '^PATH=' \
        -e '^PYTHON' \
        -e '^TMPDIR=' \
        -e '^XAUTHORITY=' \
        -e '^XDG_.*_DIR' \
        -e '^XDG_.*_HOME' \
    > "$XDG_CONFIG_HOME"/environment.d/00-env.conf
