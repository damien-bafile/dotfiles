#!/bin/sh
# Laptop power management with TLP (defaults: battery-saving settings on
# battery, performance on AC, switched automatically), plus tlp-pd so the
# waybar power-profiles-daemon module can switch TLP profiles.
# Run with sudo.
set -eu

xbps-install -S tlp tlp-pd

ln -sfn /etc/sv/tlp /var/service/tlp
ln -sfn /etc/sv/tlp-pd /var/service/tlp-pd

# Give runit a moment to start TLP, then show its summary
sleep 2
tlp-stat -s
