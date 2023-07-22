#!/bin/bash
#
SCREEN_REAL="DP-1"
SCREEN_FAKE="HEADLESS-1"

# SWAY ENVIRONMENT
export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -ox sway).sock
export WAYLAND_DISPLAY=wayland-1

#echo "Disabling SLEEP"
#sudo systemctl mask sleep.target suspend.target hibernate.target

echo "[SWITCHING OUTPUTS] ${SCREEN_REAL} -> ${SCREEN_FAKE}"
swaymsg output $SCREEN_FAKE enable
swaymsg output $SCREEN_REAL disable

echo "STARTING VNC ..."
#systemd-inhibit --who="wayvnc" --mode=block --what=idle --why="Remote working"

# Swap right ALT with SUPER
export XKB_DEFAULT_OPTIONS="altwin:swap_alt_win" # "altwin:swap_lalt_lwin"
wayvnc --output=$SCREEN_FAKE --max-fps=15 127.0.0.1 5900

echo "[SWITCHING OUTPUTS] ${SCREEN_FAKE} -> ${SCREEN_REAL}"
swaymsg output $SCREEN_REAL enable
swaymsg output $SCREEN_FAKE disable

#echo "Enabling SLEEP"
#sudo systemctl unmask sleep.target suspend.target hibernate.target
