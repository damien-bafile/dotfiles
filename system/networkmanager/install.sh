#!/bin/sh
# Switch Wi-Fi from wpa_supplicant + dhcpcd services to NetworkManager, so
# nm-applet (tray) and nmtui can manage networks. Run with sudo.
# Wi-Fi drops while switching; reconnect with `nmtui` afterwards.
set -eu

USER_NAME=${SUDO_USER:?run this with sudo}

xbps-install -S NetworkManager network-manager-applet

# Void's NetworkManager polkit rule lets the "network" group manage it
# without a password prompt (takes effect after logging in again)
usermod -aG network "$USER_NAME"

# NetworkManager runs wpa_supplicant and DHCP itself; the standalone
# services would fight it
rm -f /var/service/dhcpcd /var/service/wpa_supplicant
ln -sfn /etc/sv/NetworkManager /var/service/NetworkManager

echo "NetworkManager enabled. Connect with: nmtui  (or the tray icon)"
echo "Undo: rm /var/service/NetworkManager; ln -s /etc/sv/dhcpcd /etc/sv/wpa_supplicant /var/service/"
