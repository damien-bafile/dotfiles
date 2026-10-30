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
