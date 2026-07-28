export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="apple"

plugins=(git tmux brew conda nvm rust sdk zsh-navigation-tools zsh-interactive-cd zoxide)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emacsclient -t -a ""'
else
  export EDITOR='emacsclient -c -a ""'
fi
export VISUAL="$EDITOR"
export ALTERNATE_EDITOR=""

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='lsd --tree'
alias fm='yazi'
alias cat='bat'

export PATH="$HOME/.local/bin:$PATH"

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=true
ZSH_TMUX_AUTOQUIT=true

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  ZSH_TMUX_AUTOSTART=false
else
  ZSH_TMUX_AUTOSTART=true
fi

if [[ -f "$HOME/.zshrc_$(uname)" ]]; then
  source "$HOME/.zshrc_$(uname)"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/daimyo/.lmstudio/bin"
# End of LM Studio CLI section

