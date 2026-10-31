#!/bin/sh
# Wofi power menu for Sway/void-linux
# Toggle: open if closed, close if open

if pgrep -f 'wofi.*Power menu' >/dev/null 2>&1; then
    pkill -f 'wofi.*Power menu'
else
    # Entries are img:<icon>:text:<label> (Papirus-Dark icons)
    icons=/usr/share/icons/Papirus-Dark/24x24
    printf '%s\n' \
        "img:$icons/apps/system-shutdown.svg:text:Shutdown" \
        "img:$icons/apps/system-reboot.svg:text:Reboot" \
        "img:$icons/apps/system-suspend.svg:text:Suspend" \
        "img:$icons/apps/system-hibernate.svg:text:Hibernate" \
        "img:$icons/apps/system-lock-screen.svg:text:Lock" \
        "img:$icons/apps/system-log-out.svg:text:Logout" \
        "img:$icons/actions/window-close.svg:text:Cancel" | wofi --dmenu --prompt "Power menu" --width 260 --height 320 | {
            read -r choice
            # wofi may print the whole img:...:text: line; keep only the label
            choice=${choice##*:text:}
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