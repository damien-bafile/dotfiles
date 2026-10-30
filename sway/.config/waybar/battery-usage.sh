#!/bin/sh
# Waybar custom module: battery power draw/usage in watts
BAT=/sys/class/power_supply/BAT1
[ -r "$BAT/voltage_now" ] || exit 0

status=$(cat "$BAT/status" 2>/dev/null || echo Unknown)

if [ -r "$BAT/power_now" ]; then
    # power_now is in microwatts
    power_uw=$(cat "$BAT/power_now")
    awk -v p="$power_uw" -v s="$status" 'BEGIN {
        w = p / 1000000.0
        printf "{\"text\":\"%.1fW\",\"tooltip\":\"Battery: %s\\nPower: %.1f W\",\"class\":\"%s\"}\n", w, s, w, tolower(s)
    }'
else
    v=$(cat "$BAT/voltage_now")
    i=$(cat "$BAT/current_now")
    awk -v v="$v" -v i="$i" -v s="$status" 'BEGIN {
        w = v * i / 1000000000000.0
        printf "{\"text\":\"%.1fW\",\"tooltip\":\"Battery: %s\\nPower: %.1f W\",\"class\":\"%s\"}\n", w, s, w, tolower(s)
    }'
fi
