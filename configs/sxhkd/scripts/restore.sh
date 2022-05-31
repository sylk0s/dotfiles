context=/home/sylkos/dotfiles/configs/sxhkd/scripts/ctx.dat

function update_variables(){
    # update the variable context
    source $context
}

dunstctl set-paused false

update_variables

bspc desktop --focus ^$m1
bspc desktop --focus ^$m2
bspc desktop --focus ^$m3
