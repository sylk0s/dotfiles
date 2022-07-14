#!/bin/sh

echo "beep"

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymap



if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then	
	xmodmap "$usermodmap"
fi

# start some nice programs

#if [ -d /etc/X11/xinit/xinitrc.d ] ; then
# for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#  [ -x "$f" ] && . "$f"
# done
# unset f
#fi

#export _JAVA_AWT_WM_NONREPARENTING=1
export PATH=$PATH:/home/sylkos/.local/bin/
xsetroot -cursor_name left_ptr

#/home/sylkos/dotfiles/scripts/xmodmap_setup.sh

#xrandr --output DVI-D-0 --rotate right
#xrandr --output DVI-D-0 --pos 0x0 --mode 1920x1200 --output DP-0 --pos 1200x445 --output HDMI-0 --pos 3120x585
#Not sure why its doing this but the last arg *should* be 3120x585
#exec xrandr > screens.txt
exec bspwm
