# dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Layout

Each top-level directory is a stow "package" mirroring `$HOME`:

```
~/.dotfiles/
├── shell/      → ~/.zshrc, .zshenv, .bashrc, .profile, .bash_profile
├── git/        → ~/.gitconfig, ~/.config/git/ignore
├── nvim/       → ~/.config/nvim/
├── emacs/      → ~/.spacemacs, .spacemacs.env
├── tmux/       → ~/.config/tmux/
├── ghostty/    → ~/.config/ghostty/
├── herdr/      → ~/.config/herdr/
├── ideavim/    → ~/.ideavimrc
├── lazygit/    → ~/.config/lazygit/
├── ruster/     → ~/.config/ruster/
├── zed/        → ~/.config/zed/
├── lsd/        → ~/.config/lsd/
├── bat/        → ~/.config/bat/
├── btop/       → ~/.config/btop/
├── mpd/        → ~/.config/mpd/
├── rmpc/       → ~/.config/rmpc/
├── gh/         → ~/.config/gh/
├── mise/       → ~/.config/mise/
├── opencode/   → ~/.config/opencode/
├── kitty/      → ~/.config/kitty/
├── yazi/       → ~/.config/yazi/   (catppuccin-mocha flavor via `ya pkg`)
├── sway/       → ~/.config/{sway,waybar,wofi,mako}/   (Linux only)
└── theme/      → ~/.config/{gtk-3.0,gtk-4.0,qt5ct,qt6ct,Kvantum}/, qt-env.sh   (Linux only)
```

`sway/` and `theme/` are Linux desktop configs; don't stow them on macOS.

The cursor theme isn't tracked (12 MB of images). On a new Linux machine:

```bash
gh release download v2.0.0 -R catppuccin/cursors -p catppuccin-mocha-light-cursors.zip
unzip catppuccin-mocha-light-cursors.zip -d ~/.local/share/icons
```

`system/` is not a stow package. It holds files that live outside `$HOME`:

- `system/grub/` — Catppuccin Mocha GRUB theme (from catppuccin/grub), scaled
  1.5x with a 24px FiraCode font for the Framework's 2256x1504 panel. Install
  with `sudo sh system/grub/install.sh`; it backs up `/etc/default/grub` to
  `/etc/default/grub.bak-catppuccin` before setting `GRUB_THEME`.
- `system/papirus/` — recolours Papirus-Dark folders to Catppuccin Mocha
  Sapphire (catppuccin/papirus-folders). Run `sudo sh system/papirus/install.sh`,
  and again after a Papirus update resets the colour.
- `system/greetd/` — greetd + tuigreet login on tty2 (replaces ly). Run
  `sudo sh system/greetd/install.sh` from a text console (Ctrl+Alt+F1), since
  stopping the old display manager ends the running session. Its `run` makes
  greetd wait for dbus and elogind; a greetd package update overwrites it, so
  rerun the script after updating.
- `system/networkmanager/` — moves Wi-Fi from the wpa_supplicant + dhcpcd
  services to NetworkManager so nm-applet and `nmtui` work, and adds you to the
  `network` group. Run `sudo sh system/networkmanager/install.sh`, then
  reconnect with `nmtui`.
- `system/console/` — Catppuccin Mocha palette for the Linux console and
  tuigreet (catppuccin/tty kernel options). Run `sudo sh system/console/install.sh`
  and reboot; it keeps your other boot options and backs up `/etc/default/grub`.
- `system/hibernate/` — enables hibernation on the btrfs root: a 32 GB swap file
  in a `/swap` subvolume, `resume=`/`resume_offset=` boot options, dracut's
  resume module, plus `mem_sleep_default=deep` for better suspend battery life.
  Run `sudo sh system/hibernate/install.sh` (optional size arg, e.g. `48g`),
  reboot, then test with `loginctl hibernate`.
- `system/socklog/` — service logs via socklog (`socklog-unix` + `nanoklogd`),
  and adds you to the `socklog` group. Run `sudo sh system/socklog/install.sh`,
  log in again, then read logs with `svlogtail` (e.g. `svlogtail -f daemon`).

`mpd/` keeps its database, log and playlists in `~/.local/state/mpd`. The audio
output is per machine: copy `mpd/.config/mpd/output.conf.example` to
`output.conf` (gitignored) and keep the `pipewire` block on Linux or the `osx`
block on the Mac. On Linux, sway starts mpd as your user (not the system
service) so it can use PipeWire.

`gh/` only tracks `config.yml`. `hosts.yml` holds the GitHub auth token and is
gitignored, so `gh auth login` writes it as a plain local file.

Shell configs are split per-platform:
- `shell/.zshrc` — self-contained core (no plugin manager); machine-specific bits go in an untracked `~/.zshrc.local`
- `shell/.zshrc_Darwin` — macOS-specific paths
- `shell/.zshrc_Linux` — Linux-specific paths (template)
- Same pattern for `.bash_profile`, `.profile`

Ghostty uses a custom `catppuccin-mocha` theme in `themes/` (overrides the built-in).

## Setup on a new machine

```bash
# Clone into ~/.dotfiles
git clone <repo-url> ~/.dotfiles

# Install GNU Stow
brew install stow        # macOS
apt install stow         # Debian/Ubuntu
pacman -S stow           # Arch

# Stow all packages
cd ~/.dotfiles
for pkg in */; do
  pkg="${pkg%/}"
  # system/ holds files for outside $HOME, installed by hand (see above)
  [ "$pkg" = system ] && continue
  # sway and theme are Linux desktop configs
  if [ "$(uname)" = Darwin ] && { [ "$pkg" = sway ] || [ "$pkg" = theme ]; }; then
    continue
  fi
  stow --target=$HOME "$pkg"
done
```

To stow individual packages:
```bash
stow --target=$HOME shell
stow --target=$HOME nvim
```

## Adding a new file

```bash
# 1. Place the file at the right path in its stow package
cp ~/.someconfig ~/.dotfiles/shell/.someconfig

# 2. Remove the original
rm ~/.someconfig

# 3. Stow it
cd ~/.dotfiles && stow --target=$HOME shell
```

## Workflow

1. Edit config files normally (they're symlinks into the repo)
2. `cd ~/.dotfiles && git add -A && git commit -m "..." && git push`
