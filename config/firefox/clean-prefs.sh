#!/usr/bin/env sh

grep \
    -e 'browser.tabs.inTitlebar' \
    -e 'extensions.databaseSchema' \
    -e 'extensions.webextensions.uuids' \
    -e 'identity.fxaccounts.account.device.name' \
    -e 'services.sync.declinedEngines' \
    -e 'services.sync.username' \
    prefs.js > prefs.tmp && mv prefs.tmp prefs.js
