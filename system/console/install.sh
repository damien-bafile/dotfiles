#!/bin/sh
# Catppuccin Mocha palette for the Linux console (catppuccin/tty): sets the
# 16 console colours through kernel options, so tuigreet and the text
# consoles use Mocha. Run with sudo; takes effect after a reboot.
set -eu

PALETTE='vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200'

cp /etc/default/grub /etc/default/grub.bak-console

# Drop any existing vt.default_* options, then append the Mocha ones
current=$(sed -n 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"$/\1/p' /etc/default/grub)
cleaned=$(printf '%s\n' $current | grep -v '^vt\.default_' | tr '\n' ' ' | sed 's/ $//')
new="${cleaned:+$cleaned }$PALETTE"
sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$new\"|" /etc/default/grub

grep '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
echo "Done. Reboot to see the Mocha console colours."
