#!/usr/bin/env sh

tpm_path="${TMUX_PLUGIN_MANAGER_PATH:-$XDG_CONFIG_HOME/tmux/plugins}"/tpm

if [ ! -e "$tpm_path" ]; then
    tpm_url="$(tmux show -gqv @tpm_plugins | grep '/tpm')"
    case "$tpm_url" in
        http*) ;;
        *) tpm_url="https://github.com/$tpm_url"
    esac
    git clone --depth 1 "$tpm_url" "$tpm_path" || exit 1
fi

cd "$tpm_path"/bin || exit 1
./clean_plugins
./install_plugins
./update_plugins all
