#!/bin/sh
# Launch wofi only if it is not already running

if pgrep -x wofi >/dev/null 2>&1; then
    pkill -x wofi
else
    exec wofi --show drun --no-actions --fork
fi