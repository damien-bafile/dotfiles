export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [[ -f "$HOME/.bash_profile_$(uname)" ]]; then
  source "$HOME/.bash_profile_$(uname)"
fi
