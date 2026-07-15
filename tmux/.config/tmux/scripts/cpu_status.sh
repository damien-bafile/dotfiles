#!/bin/bash
# CPU status with dynamic catppuccin colors
# Green = low usage (good), Yellow = warning, Red = high usage (bad)

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${CURRENT_DIR}/../plugins/tmux-cpu-mem-monitor"

# Get CPU percentage and convert to integer
cpu_float=$("${PLUGIN_DIR}/venv/bin/python" "${PLUGIN_DIR}/src/cpu.py" | sed 's/%//')
cpu=$(printf "%.0f" "$cpu_float")

# Output with icon and percentage in the same color
if [ "$cpu" -le 50 ]; then
    # Low usage = Green (good)
    echo "#[fg=#a6e3a1,bg=#1e1e2e]  $cpu%"
elif [ "$cpu" -le 80 ]; then
    # Medium usage = Yellow/Orange (warning)
    echo "#[fg=#f9e2af,bg=#1e1e2e]  $cpu%"
else
    # High usage = Red (bad)
    echo "#[fg=#f38ba8,bg=#1e1e2e]  $cpu%"
fi
