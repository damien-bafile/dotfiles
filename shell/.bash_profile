export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [[ -f "$HOME/.bash_profile_$(uname)" ]]; then
  source "$HOME/.bash_profile_$(uname)"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/daimyo/.lmstudio/bin"
# End of LM Studio CLI section

