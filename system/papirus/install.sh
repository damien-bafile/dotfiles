#!/bin/sh
# Recolour Papirus folders to Catppuccin Mocha Sapphire. Run with sudo.
# Papirus package updates can reset the colour; just run this again.
set -eu

COLOR=${1:-cat-mocha-sapphire}
REV=f83671d17ea67e335b34f8028a7e6d78bca735d7  # catppuccin/papirus-folders

command -v papirus-folders >/dev/null || xbps-install -S papirus-folders

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git clone -q https://github.com/catppuccin/papirus-folders "$tmp/repo"
git -C "$tmp/repo" checkout -q "$REV"

# Add the Catppuccin folder icons (SVGs only) to the base Papirus theme
cp -r "$tmp/repo/src/." /usr/share/icons/Papirus/

papirus-folders -C "$COLOR" --theme Papirus-Dark
echo "Folders set to $COLOR."
