# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.

# dotfiles (stow-managed at ~/.dotfiles)
- Config files are symlinks into `~/.dotfiles/` via GNU Stow
- When you create/modify a config in the home dir, the real file is in `~/.dotfiles/<package>/`
- If adding a new config file to a stow package: place it at the right path in `~/.dotfiles/<package>/`, remove the original, then run `cd ~/.dotfiles && stow --target=$HOME <package>`
- After any dotfiles change, ask the user: "Commit and push to GitHub?" and if yes:
  1. `cd ~/.dotfiles && git add -A && git commit -m "..." && git push`
