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
├── ideavim/    → ~/.ideavimrc
├── zed/        → ~/.config/zed/
├── lsd/        → ~/.config/lsd/
├── bat/        → ~/.config/bat/
├── btop/       → ~/.config/btop/
├── mpd/        → ~/.config/mpd/
├── rmpc/       → ~/.config/rmpc/
├── gh/         → ~/.config/gh/
├── mise/       → ~/.config/mise/
├── opencode/   → ~/.config/opencode/
├── claude/     → ~/.claude/
├── fish/       → ~/.config/fish/
└── eutmux/     → ~/.config/eutmux/
```

Shell configs are split per-platform:
- `shell/.zshrc` — shared core (oh-my-zsh, plugins, aliases)
- `shell/.zshrc_Darwin` — macOS-specific paths
- `shell/.zshrc_Linux` — Linux-specific paths (template)
- Same pattern for `.bash_profile`, `.profile`

Ghostty uses its built-in `catppuccin-mocha` theme (no custom theme file needed).

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
  stow --target=$HOME "${pkg%/}"
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
