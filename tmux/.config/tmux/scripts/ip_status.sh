#!/bin/bash
# Get primary IP address - works on both Linux and macOS

ip=$(ip route get 1 2>/dev/null | sed -n 's/.*src \([0-9.]\+\).*/\1/p' \
  || hostname -I 2>/dev/null | awk '{print $1}' \
  || ipconfig getifaddr en0 2>/dev/null \
  || ipconfig getifaddr en1 2>/dev/null)
if [ -z "$ip" ]; then
    echo "#[fg=#f38ba8,bg=#1e1e2e]no network"
else
    echo "#[fg=#a6e3a1,bg=#1e1e2e]$ip"
fi
