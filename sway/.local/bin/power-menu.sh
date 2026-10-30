#!/bin/sh
# Wofi power menu for Sway/void-linux
# Toggle: open if closed, close if open

if pgrep -f 'wofi.*Power menu' >/dev/null 2>&1; then
    pkill -f 'wofi.*Power menu'
else
    printf '%s\n' \
        "Shutdown" \
        "Reboot" \
        "Suspend" \
        "Hibernate" \
        "Lock" \
        "Logout" \
        "Cancel" | wofi --dmenu --prompt "Power menu" --width 260 --height 320 | {
            read -r choice
            case "$choice" in
                Shutdown) loginctl poweroff --no-ask-password ;;
                Reboot) loginctl reboot --no-ask-password ;;
                Suspend) loginctl suspend --no-ask-password ;;
                Hibernate) loginctl hibernate --no-ask-password ;;
                Lock) swaylock -f ;;
                Logout) swaymsg exit ;;
                *) exit 0 ;;
            esac
        }
fi