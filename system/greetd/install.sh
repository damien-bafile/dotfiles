#!/bin/sh
# Replace ly with greetd + tuigreet. Run with sudo FROM A TEXT CONSOLE
# (Ctrl+Alt+F1, log in there): stopping ly ends the sway session it started.
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)

xbps-install -S greetd tuigreet

[ -f /etc/greetd/config.toml ] && cp /etc/greetd/config.toml /etc/greetd/config.toml.bak
install -m 644 "$HERE/config.toml" /etc/greetd/config.toml
install -m 755 "$HERE/sway-session" /etc/greetd/sway-session

# Make greetd wait for dbus + elogind (a greetd package update overwrites
# this file; rerun this script afterwards)
install -m 755 "$HERE/run" /etc/sv/greetd/run

# tuigreet --remember needs a cache dir owned by the greeter user
install -d -m 755 -o _greeter -g _greeter /var/cache/tuigreet

# Swap services: ly out, greetd in
rm -f /var/service/ly
ln -sfn /etc/sv/greetd /var/service/greetd

echo "greetd is starting on tty2 (Ctrl+Alt+F2)."
echo "To go back to ly: rm /var/service/greetd && ln -s /etc/sv/ly /var/service/"
