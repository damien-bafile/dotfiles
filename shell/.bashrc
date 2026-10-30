# .bashrc

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

command -v genv >/dev/null 2>&1 && eval "$(genv shell --init)"

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# opencode
case ":$PATH:" in
    *":$HOME/.opencode/bin:"*) ;;
    *) export PATH="$HOME/.opencode/bin:$PATH" ;;
esac

# Truecolor / terminal capability hints for TUI apps (e.g. opencode).
export COLORTERM=${COLORTERM:-truecolor}
export TERM_PROGRAM=${TERM_PROGRAM:-kitty}
case "$TERM" in
    xterm*|screen*|tmux*|rxvt*|kitty*|alacritty*) ;;
    *) export TERM=xterm-256color ;;
esac

# zig
case ":$PATH:" in
    *":$HOME/opt/zig:"*) ;;
    *) export PATH="$HOME/opt/zig:$PATH" ;;
esac
