#!/usr/bin/env sh

[ -z "$COMMAFEED_URL$COMMAFEED_KEY" ] && exit 1

curl -s "$COMMAFEED_URL/rest/category/unreadCount?apiKey=$COMMAFEED_KEY" | \
    tr ',' '\n' | \
    awk -F':' '/unreadCount/ {sum+=$2}END{print sum}'
