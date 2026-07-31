#!/bin/bash
# Show battery info only if a battery is present

BATTERY_DIR="$HOME/.config/tmux/plugins/tmux-battery"

pct=$("${BATTERY_DIR}/scripts/battery_percentage.sh" 2>/dev/null | tr -d '%' | tr -d ' ')
if [ -z "$pct" ] || [ "$pct" = "0" ]; then
    exit 0
fi

status=$("${BATTERY_DIR}/scripts/battery_icon_status.sh" 2>/dev/null)
icon=$("${BATTERY_DIR}/scripts/battery_icon.sh" 2>/dev/null)
color_fg=$("${BATTERY_DIR}/scripts/battery_color.sh" fg 2>/dev/null)

echo "#[bg=#1e1e2e] ${color_fg}#[bg=#1e1e2e]${icon} #[bg=#1e1e2e]#(${BATTERY_DIR}/scripts/battery_percentage.sh)"
