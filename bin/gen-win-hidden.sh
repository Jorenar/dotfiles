#!/usr/bin/env sh

{
    cmd.exe /c dir /A:H /B
    ls -d1 * 2>&1 | awk -F\' '/cannot access/ {print $2}'
} | sed 's/\r//g' | sort -u > .hidden 2> /dev/null

cmd.exe /c attrib +H .hidden
