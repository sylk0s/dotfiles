bspc subscribe monitor | while read -r line; do
  case $line in
      monitor_add*|monitor_geometry*)
        if [ "$(bspc query -M | wc -l)" -eq "3" ]; then
          bspc monitor DP-3-1 -d 1 2 3
          bspc monitor DP-3-2 -d 4 5 6 7
          bspc monitor eDP-1 -d 8 9 10 11
	  $HOME/dotfiles/configs/polybar/start.sh &
        else
          bspc monitor eDP-1 -d 1 2 3 4 5 6 7 8 9 10 11
	  $HOME/dotfiles/configs/poylbar/start.sh &
        fi
        ;;
      *)
      ;;
  esac
done &
