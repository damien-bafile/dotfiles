# ===========================================================================
#  ~/.zshrc — self-contained defaults, no plugin manager required
#
#  Sections:
#    1. Options & history      2. Key bindings
#    3. Completion             4. Prompt
#    5. Aliases                6. Functions
#    7. Optional tools (skipped automatically if not installed)
# ===========================================================================

# --- 1. Options & history --------------------------------------------------

HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY        # record timestamps in history
setopt SHARE_HISTORY           # share history between open shells
setopt HIST_IGNORE_ALL_DUPS    # keep only the most recent copy of a command
setopt HIST_IGNORE_SPACE       # commands starting with a space are not saved
setopt HIST_REDUCE_BLANKS      # strip superfluous whitespace
setopt HIST_VERIFY             # show expanded !history before running it

setopt AUTO_CD                 # `foo/` changes into foo/
setopt AUTO_PUSHD              # cd pushes onto the directory stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS    # allow # comments when typing commands
setopt NO_BEEP
setopt NO_FLOW_CONTROL         # free up Ctrl-S / Ctrl-Q
setopt EXTENDED_GLOB           # ^ and # qualifiers in patterns
setopt NUMERIC_GLOB_SORT       # file10 after file9
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END           # move cursor to end after completing a word
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT       # clear right prompt once a command is typed

# Make words stop at / and . so Ctrl-W / Alt-Backspace delete one path part.
WORDCHARS=${WORDCHARS//[\/.]/}

# Keep $PATH free of duplicates, preserving order.
typeset -U path fpath cdpath

# Make opencode (and zig) available in zsh, mirroring ~/.bashrc.
case ":$PATH:" in
    *":$HOME/.opencode/bin:"*) ;;
    *) export PATH="$HOME/.opencode/bin:$PATH" ;;
esac
case ":$PATH:" in
    *":$HOME/opt/zig:"*) ;;
    *) export PATH="$HOME/opt/zig:$PATH" ;;
esac

# Truecolor / terminal capability hints for TUI apps (e.g. opencode).
export COLORTERM=${COLORTERM:-truecolor}
export TERM_PROGRAM=${TERM_PROGRAM:-kitty}
# Ensure a color-capable TERM when the terminal didn't set one.
case "$TERM" in
    xterm*|screen*|tmux*|rxvt*|kitty*|alacritty*) ;;
    *) export TERM=xterm-256color ;;
esac

KEYTIMEOUT=1                   # snappier Esc / mode switches

# --- 2. Key bindings (emacs mode) -----------------------------------------

bindkey -e

# Widgets used for history search on Up/Down.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Up/Down search history for the text already typed.
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# Some terminals (incl. kitty) send application-cursor sequences.
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search

# Home / End / Delete (both xterm and terminfo variants)
bindkey '^[[H'  beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[OH'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OF'  end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z'  reverse-menu-complete

# Ctrl/Alt + Left/Right move by word (xterm, rxvt and macOS-style variants)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5D'   backward-word
bindkey '^[[5C'   forward-word
bindkey '^[Od'    backward-word
bindkey '^[Oc'    forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[^[[D'  backward-word
bindkey '^[^[[C'  forward-word
bindkey '^[b'     backward-word
bindkey '^[f'     forward-word

# --- 3. Completion ---------------------------------------------------------

zmodload -i zsh/complist

_ZSH_CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $_ZSH_CACHE ]] || mkdir -p $_ZSH_CACHE

autoload -Uz compinit
compinit -d "$_ZSH_CACHE/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$_ZSH_CACHE/zcompcache"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches: %d%f'
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'
# Don't offer ./ ../ when completing `cd` into a subdirectory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Rehash binaries when a command isn't found.
zstyle ':completion:*' rehash true
# Colour completion listings the same way ls colours files.
(( ${+LS_COLORS} )) && zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Show process IDs and users in kill completions.
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,%cpu,time,comm'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --- 4. Prompt -------------------------------------------------------------

autoload -Uz vcs_info add-zsh-hook
zmodload zsh/datetime

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats       ' %F{#cdd6f4}on%f %F{#74c7ec}%b%f%F{red}%u%F{green}%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{#cdd6f4}on%f %F{#74c7ec}%b%f%F{red}%u%F{green}%c%f %F{red}(%a)%f'

__precmd() {
    vcs_info
    # Optional virtualenv indicator (computed here to keep PROMPT simple).
    __venv=${VIRTUAL_ENV:+"%F{yellow}(${VIRTUAL_ENV:t})%f "}
    # Show how long the last command took, if it was slow.
    local elapsed=''
    if [[ -n $__cmd_started ]]; then
        elapsed=$(( EPOCHREALTIME - __cmd_started ))
        unset __cmd_started
    fi
    if [[ -n $elapsed ]] && (( elapsed >= 1 )); then
        RPROMPT="%F{#74c7ec}${elapsed%.*}s%f"
    else
        RPROMPT='%F{#74c7ec}%D{%H:%M}%f'
    fi
}
__preexec() { __cmd_started=$EPOCHREALTIME }
add-zsh-hook precmd __precmd
add-zsh-hook preexec __preexec

PROMPT='${__venv}%F{green}%n%f%F{#cdd6f4}@%f%F{green}%m%f %F{#74c7ec}%~%f${vcs_info_msg_0_}
%(?.%F{#74c7ec}%B❯%f%b.%F{red}%B❯%f%b) '

# --- 5. Aliases ------------------------------------------------------------

if (( $+commands[lsd] )); then
    alias ls='lsd'
    alias l='lsd -lah'
    alias la='l'
    alias ll='l'
    alias lt='lsd --tree --depth 2'
else
    alias ls='ls --color=auto -F'
    alias l='ls -lahF'
    alias la='l'
    alias ll='l'
    alias lt='ls -lhFtr'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias ports='ss -tulpn'
alias path='print -l $path'
alias reload='exec zsh'          # re-read this file in a fresh shell
alias history='fc -il 1'

# git shortcuts
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# --- 6. Functions ----------------------------------------------------------

# zmv '*.jpeg' '*.jpg' — safe bulk rename (uses EXTENDED_GLOB).
autoload -Uz zmv
alias zmv='noglob zmv -W'

# mkcd DIR — create a directory and enter it.
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# extract FILE... — unpack any common archive type.
extract() {
    local f
    for f in "$@"; do
        if [[ ! -f $f ]]; then
            print -u2 "extract: no such file: $f"
            continue
        fi
        case $f in
            *.tar.bz2|*.tbz2) tar xjf "$f"  ;;
            *.tar.gz|*.tgz)   tar xzf "$f"  ;;
            *.tar.xz|*.txz)   tar xJf "$f"  ;;
            *.tar.zst|*.tzst) tar --zstd -xf "$f" ;;
            *.tar)            tar xf  "$f"  ;;
            *.zip)            unzip   "$f"  ;;
            *.rar)            unrar x "$f"  ;;
            *.7z)             7z x    "$f"  ;;
            *.gz)             gunzip  "$f"  ;;
            *.bz2)            bunzip2 "$f"  ;;
            *.xz)             unxz    "$f"  ;;
            *.zst)            unzstd  "$f"  ;;
            *) print -u2 "extract: unknown archive type: $f" ;;
        esac
    done
}

# up [N] — move up N directory levels (default 1).
up() {
    local n=${1:-1} i
    for (( i = 0; i < n; i++ )); do
        cd .. || return 1
    done
}

# --- 7. Optional tools -----------------------------------------------------
# Each of these is a no-op unless the tool is installed.

if (( $+commands[fzf] )); then
    for _f in /usr/share/fzf/shell/key-bindings.zsh \
              /usr/share/fzf/key-bindings.zsh \
              /usr/share/doc/fzf/examples/key-bindings.zsh \
              ${HOMEBREW_PREFIX:-/nonexistent}/opt/fzf/shell/key-bindings.zsh; do
        [[ -r $_f ]] && { source $_f; break; }
    done
    unset _f
fi

(( $+commands[zoxide] ))    && eval "$(zoxide init zsh)"
(( $+commands[direnv] ))    && eval "$(direnv hook zsh)"
(( $+commands[mise] ))      && eval "$(mise activate zsh)"

if (( $+commands[bat] || $+commands[batcat] )); then
    export BAT_THEME=${BAT_THEME:-ansi}
    alias cat='bat --style=plain --paging=never'
fi
(( $+commands[fd] ))        && alias fd='fd --color=auto'
(( $+commands[rg] ))        && alias rg='rg --smart-case'

# Plugins must load after compinit. Installed via e.g. `xbps-install
# zsh-syntax-highlighting zsh-autosuggestions`.
# Catppuccin Mocha colours for both; the highlighting theme must be set first.
[[ -r ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ]] \
    && source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
for _f in /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
          /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
          ${HOMEBREW_PREFIX:-/nonexistent}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
          ${HOMEBREW_PREFIX:-/nonexistent}/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
    [[ -r $_f ]] && source $_f
done
unset _f

# starship, if present, replaces the prompt defined above — keep it last.
(( $+commands[starship] )) && eval "$(starship init zsh)"

# --- 8. Local overrides ----------------------------------------------------
# Put machine-specific settings in ~/.zshrc.local (not tracked anywhere).
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
export PATH="$HOME/.local/bin:$PATH"

# Qt5/Qt6 dark theme
[ -f "$HOME/.config/qt-env.sh" ] && . "$HOME/.config/qt-env.sh"
