#!/bin/sh
# Keep tmux's built-in right-click menus open after the mouse button is
# released (display-menu -O). Without it, a touchpad tap releases straight
# away and the menu closes before an item can be picked.
tmux list-keys -T root \
  | grep -E 'MouseDown3' \
  | sed -e 's/display-menu -O /display-menu /g' -e 's/display-menu /display-menu -O /g' \
  | tmux source-file -
