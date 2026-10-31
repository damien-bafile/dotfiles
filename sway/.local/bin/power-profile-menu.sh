#!/bin/sh
# Wofi menu to switch the power profile (TLP via tlp-pd, which provides the
# power-profiles D-Bus API). Toggle: open if closed, close if open.

BUS=org.freedesktop.UPower.PowerProfiles
OBJ=/org/freedesktop/UPower/PowerProfiles

if pgrep -f 'wofi.*Power profile' >/dev/null 2>&1; then
    pkill -f 'wofi.*Power profile'
    exit 0
fi

current=$(busctl --system get-property "$BUS" "$OBJ" "$BUS" ActiveProfile 2>/dev/null | cut -d'"' -f2)

entry() {  # icon, profile, label
    mark=""
    [ "$2" = "$current" ] && mark="  ●"
    printf '%s  %s%s\n' "$1" "$3" "$mark"
}

choice=$({
    entry "" performance "Performance"
    entry "" balanced "Balanced"
    entry "" power-saver "Power saver"
} | wofi --dmenu --prompt "Power profile" --width 280 --height 200)

case "$choice" in
    *Performance*) profile=performance ;;
    *Balanced*)    profile=balanced ;;
    *"Power saver"*) profile=power-saver ;;
    *) exit 0 ;;
esac

if busctl --system set-property "$BUS" "$OBJ" "$BUS" ActiveProfile s "$profile"; then
    notify-send -a power -i preferences-system-power "Power profile" "$profile"
else
    notify-send -a power -u critical "Power profile" "Could not switch to $profile (is tlp-pd running?)"
fi
