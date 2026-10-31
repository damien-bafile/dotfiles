#!/bin/sh
# Enable hibernation on a btrfs root: swap file + resume options + initramfs.
# Also sets deep suspend (mem_sleep_default=deep) for better battery life.
# Run with sudo, then reboot. Optional arg: swap size (default 32g).
set -eu

SIZE=${1:-32g}
SWAPFILE=/swap/swapfile
ROOT_UUID=$(findmnt -no UUID /)

# 1. Swap file in its own subvolume (btrfs swap files need no-COW, which
#    mkswapfile sets up)
[ -d /swap ] || btrfs subvolume create /swap
[ -e "$SWAPFILE" ] || btrfs filesystem mkswapfile --size "$SIZE" "$SWAPFILE"
grep -q "^$SWAPFILE " /proc/swaps || swapon "$SWAPFILE"

cp /etc/fstab /etc/fstab.bak-hibernate
grep -q "^$SWAPFILE[[:space:]]" /etc/fstab || \
  echo "$SWAPFILE none swap defaults 0 0" >> /etc/fstab

# 2. Kernel options: resume from the swap file's location on the root fs
OFFSET=$(btrfs inspect-internal map-swapfile -r "$SWAPFILE")
cp /etc/default/grub /etc/default/grub.bak-hibernate
current=$(sed -n 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"$/\1/p' /etc/default/grub)
cleaned=$(printf '%s\n' $current | grep -vE '^(resume|resume_offset|mem_sleep_default)=' | tr '\n' ' ' | sed 's/ $//')
new="${cleaned:+$cleaned }resume=UUID=$ROOT_UUID resume_offset=$OFFSET mem_sleep_default=deep"
sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"$new\"|" /etc/default/grub
grep '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub

# 3. Initramfs with dracut's resume module, rebuilt the Void way (the kernel
#    package hook runs dracut and updates grub.cfg)
echo 'add_dracutmodules+=" resume "' > /etc/dracut.conf.d/resume.conf
KPKG=linux$(uname -r | cut -d. -f1,2)
xbps-reconfigure -f "$KPKG"
grub-mkconfig -o /boot/grub/grub.cfg

echo "Done. Reboot, then test with: loginctl hibernate"
