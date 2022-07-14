context=/home/sylkos/dotfiles/configs/sxhkd/scripts/ctx.dat

function set_variable(){
    # store variable
    variable=$1 #variable to be set
    value=$2    # value to give to the value
    # modify the file storing the value
    sed -i 's/'${variable}'.*/'${variable}'='${value}'/' $context
}

##################

f1=$(bspc query -D -d eDP1:focused --names)
#f2=$(bspc query -D -d DP-0:focused --names)
#f3=$(bspc query -D -d HDMI-0:focused --names)

set_variable m1 $f1
#set_variable m2 $f2
#set_variable m3 $f3

dunstctl set-paused true

bspc desktop --focus ^11
#bspc desktop --focus ^4
#bspc desktop --focus ^9
#bspc desktop --focus ^13
