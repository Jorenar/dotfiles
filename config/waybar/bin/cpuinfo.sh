#!/usr/bin/env sh

out=
gov=
temp=
freq=

while [ "$#" -gt 0 ]; do
    case "$1" in
        -g)
            case "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)" in
                powersave) gov="󰾆" ;;
                performance) gov="󱐋" ;;
            esac
            out="$out $gov"
            ;;
        -f)
            command -v lscpu > /dev/null && \
                freq="$(lscpu -e=MHz | sort -r | sed '2q;d' | cut -d. -f1)" && \
                freq="$freq MHz"
            out="$out $freq"
            ;;
        -t)
            command -v sensors > /dev/null && \
                temp="$(sensors | awk '/Tctl/ {print $2}')" && temp="${temp#+}"
            out="$out $temp"
            ;;
        *) ;;
    esac
    shift
done

out="${out## }"
out="${out%% }"
echo "$out"
