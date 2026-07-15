#!/bin/bash
# RAM/Memory status with dynamic catppuccin colors
# Green = low usage (good), Yellow = warning, Red = high usage (bad)

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${CURRENT_DIR}/../plugins/tmux-cpu-mem-monitor"

# Get RAM percentage and convert to integer
mem_float=$("${PLUGIN_DIR}/venv/bin/python" "${PLUGIN_DIR}/src/mem.py" | sed 's/%//')
mem=$(printf "%.0f" "$mem_float")

# Output with icon and percentage in the same color
if [ "$mem" -le 60 ]; then
    # Low usage = Green (good)
    echo "#[fg=#a6e3a1,bg=#1e1e2e]  $mem%"
elif [ "$mem" -le 85 ]; then
    # Medium usage = Yellow/Orange (warning)
    echo "#[fg=#f9e2af,bg=#1e1e2e]  $mem%"
else
    # High usage = Red (bad)
    echo "#[fg=#f38ba8,bg=#1e1e2e]  $mem%"
fi
