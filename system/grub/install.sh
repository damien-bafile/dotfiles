#!/bin/sh
# Install the scaled Catppuccin Mocha GRUB theme. Run with sudo.
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
DEST=/boot/grub/themes/catppuccin-mocha
TTF=/usr/share/fonts/NerdFonts/ttf/FiraCodeNerdFontMono-Regular.ttf

command -v grub-mkfont >/dev/null || xbps-install -S grub-utils

# Copy the theme and generate a 24px font inside it
mkdir -p /boot/grub/themes
rm -rf "$DEST"
cp -r "$HERE/catppuccin-mocha" "$DEST"
grub-mkfont -s 24 -o "$DEST/firacode24.pf2" "$TTF"

# Read the font's name from the PF2 NAME chunk and put it into theme.txt
name=$(python3 -I -c '
import struct, sys
d = open(sys.argv[1], "rb").read()
i = d.index(b"NAME") + 4
n = struct.unpack(">I", d[i:i+4])[0]
print(d[i+4:i+4+n].rstrip(b"\0").decode())
' "$DEST/firacode24.pf2")
echo "Font name: $name"
sed -i "s|@FONT@|$name|g" "$DEST/theme.txt"

# Point GRUB at the theme (backup first, replace any existing GRUB_THEME)
cp /etc/default/grub /etc/default/grub.bak-catppuccin
sed -i '/^GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"$DEST/theme.txt\"" >> /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
echo "Done. Reboot to see the theme."
