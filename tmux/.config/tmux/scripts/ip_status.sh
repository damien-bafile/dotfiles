#!/bin/bash
# Get primary IP address

ip=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$ip" ]; then
    echo "#[fg=#f38ba8,bg=#1e1e2e]no network"
else
    echo "#[fg=#a6e3a1,bg=#1e1e2e]$ip"
fi
