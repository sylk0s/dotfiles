# TODO the shebang

if [ "$1" == "sel-clip" ]; then
  # copies selection to clipboard
  grim -g "$(slurp)" - | wl-copy --type image/png
  notify-send "Copied selection to clipboard"

elif [ "$1" == "sel-file" ]; then
  # saves selection to file
  path="$HOME/Pictures/Screenshots/sc-$(date +%s).png"
  grim -g "$(slurp)" "$path"
  notify-send "Copied selection to $path"

elif [ "$1" == "full-clip" ]; then
  # saves a full screenshot to a file
  grim - | wl-copy --type image/png
  notify-send "Copied screen to clipboard"

elif [ "$1" == "full-file" ]; then
  # saves a full screenshot to a file
  path="$HOME/Pictures/Screenshots/sc-$(date +%s).png"
  grim -o "$path"
  notify-send "Copied screen to $path"

else
  echo "Invalid Arg :("
fi
