#!/usr/bin/env bash
DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# select the correct bar to launch
#if [ "$(bspc query -M | wc -l)" -eq "3" ]; then
if [ "$AUTORANDR_CURRENT_PROFILE" == "docked" ]; then
  polybar -q docked -c "$DIR"/bar.ini &
else 
  polybar -q mobile -c "$DIR"/bar.ini &
fi

