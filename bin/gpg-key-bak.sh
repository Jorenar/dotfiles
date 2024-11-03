#!/usr/bin/env bash

# *Slightly* safer way to export GPG keys

gpg --export-secret-keys --export-options backup "$1" | {
    sleep 1
    gpg --armor --symmetric --cipher-algo AES256 --output -
}
