#!/bin/sh


print_volume() {
    mute=$(pactl get-sink-mute @DEFAULT_SINK@) || exit 1
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ |
        awk 'NR == 1 {
        for (i = 1; i <= NF; i++)
        if ($i ~ /%$/) {
        print $i
        exit
        }
        }')

    volume=${volume%\%}

    if echo "$mute" | grep -q 'yes'; then
        icon="󰝟"
    else
        if [ "$volume" -le 0 ]; then
            icon="󰖁"
        elif [ "$volume" -lt 30 ]; then
            icon="󰕿"
        elif [ "$volume" -lt 70 ]; then
            icon="󰖀"
        else
            icon="󰕾"
        fi
    fi 

    printf '%%{T3}%s%%{T-}  %03d%%\n' "$icon" "$volume"
}

print_volume

pactl subscribe | while IFS= read -r event; do
    case "$event" in
        *"on sink "*|*"on server "*)
            print_volume
            ;;
    esac
done
