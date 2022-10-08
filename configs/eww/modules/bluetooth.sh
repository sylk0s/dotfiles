#/bin/bash
windowwidth=500
windowheight=600
bspc rule -a \* -o state=floating rectangle="${windowwidth}x${windowheight}+1405+35" center=false && blueberry
