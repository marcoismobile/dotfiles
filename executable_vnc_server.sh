#!/bin/bash
#
# SWAY ENVIRONMENT
export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -ox sway).sock
export WAYLAND_DISPLAY=wayland-1

HEADLESS=$(swaymsg -t get_outputs | grep name | grep HEADLESS | cut -d'"' -f 4)

echo "[SWITCHING OUTPUTS] -> ENABLE ${HEADLESS}"
swaymsg output "*" disable
swaymsg output $HEADLESS enable

echo "STARTING VNC ..."
# Start VNC (Swap Left ALT with SUPER)
XKB_DEFAULT_OPTIONS="altwin:swap_lalt_lwin" wayvnc --output=$HEADLESS 127.0.0.1 5900

echo "[SWITCHING OUTPUTS] -> DISABLE ${HEADLESS}"
swaymsg output "*" enable
swaymsg output $HEADLESS disable
