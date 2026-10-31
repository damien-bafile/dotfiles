#!/bin/sh
# Service logs via socklog (Void's syslog). Run with sudo.
# Logs land in /var/log/socklog/<facility>/current; read them with svlogtail.
set -eu

USER_NAME=${SUDO_USER:?run this with sudo}

xbps-install -S socklog-void

# socklog-unix: the syslog socket (/dev/log) services write to
# nanoklogd: forwards kernel messages into socklog as well
ln -sfn /etc/sv/socklog-unix /var/service/socklog-unix
ln -sfn /etc/sv/nanoklogd /var/service/nanoklogd

# Members of the socklog group can read the logs without sudo
# (takes effect after logging in again)
usermod -aG socklog "$USER_NAME"

echo "socklog enabled. After logging in again: svlogtail  (or svlogtail -f daemon)"
