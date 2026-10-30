#!/bin/bash
# Get primary IP address - works on both Linux and macOS

ip=$(ip route get 1 2>/dev/null | sed -n 's/.*src \([0-9.]\+\).*/\1/p' \
  || hostname -I 2>/dev/null | awk '{print $1}' \
  || ipconfig getifaddr en0 2>/dev/null \
  || ipconfig getifaddr en1 2>/dev/null)
if [ -z "$ip" ]; then
    echo "no network"
else
    echo "$ip"
fi
