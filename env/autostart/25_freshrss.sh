#!/usr/bin/env sh

if grep -Fxqs "freshrss" "$TMPFLAGS"; then
    return
fi

[ -z "$FRESHRSS_AUTOSTART" ] && return

if [ -x "$(command -v podman)" ]; then
    echo "podman not installed"
    return
fi

name="FreshRSS"
freshrss_dir="$XDG_DATA_HOME/$name"
data_dir="$freshrss_dir/data"
themes_dir="$freshrss_dir/themes"
extensions_dir="$freshrss_dir/extensions"

mkdir -p "$data_dir"
mkdir -p "$themes_dir"
mkdir -p "$extensions_dir"

[ -f "$data_dir/config.php" ] && initialized=1 || initialized=0

podman run -d --restart unless-stopped \
    --log-opt max-size=10m \
    -p 7740:80 \
    -e 'CRON_MIN=1,31' \
    -v "$data_dir":/var/www/FreshRSS/data \
    -v "$extensions_dir":/var/www/FreshRSS/extensions \
    --name "$name" \
    freshrss/freshrss

if [ "$initialized" = 0 ]; then
    passwd=$(pass other/freshrss)
    sleep 5
    podman exec --user www-data "$name" "cli/do-install.php" --default_user "$USER"
    podman exec --user www-data "$name" "cli/create-user.php" \
        --user "$USER" \
        --password "$passwd" --api_password "$passwd" \
        --no_default_feeds
fi

echo "freshrss" >> "$TMPFLAGS"
