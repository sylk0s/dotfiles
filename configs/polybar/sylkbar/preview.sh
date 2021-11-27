#!/usr/bin/env bash

DIR="$HOME/.config/polybar/sylkbar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the preview bar
polybar -q top -c "$DIR"/preview.ini &
#polybar -q time -c "$DIR"/preview.ini &
#polybar -q keyboard -c "$DIR"/preview.ini &
#polybar -q audio -c "$DIR"/preview.ini &
#polybar -q memory -c "$DIR"/preview.ini &
#polybar -q file -c "$DIR"/preview.ini &
#polybar -q net -c "$DIR"/preview.ini &
#polybar -q cpu -c "$DIR"/preview.ini &
polybar -q left -c "$DIR"/preview.ini &
polybar -q right -c "$DIR"/preview.ini &
