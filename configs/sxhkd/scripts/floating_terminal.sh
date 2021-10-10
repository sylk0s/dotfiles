#/bin/bash
windowwidth=800
windowheight=600

bspc rule -a \* -o state=floating rectangle="${windowwidth}x${windowheight}+0+0" center=true && kitty
