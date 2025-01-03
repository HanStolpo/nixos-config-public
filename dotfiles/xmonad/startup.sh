#!/bin/sh

autorandr -c

# System tray
killall stalonetray
stalonetray --window-type dock --window-strut auto --window-layer top &

killall notify-osd
notify-osd &

# # Network Manager Icon
# if [ -z "$(pgrep nm-applet)" ]; then
# 	nm-applet --sm-disable &
# fi

# Volume Icon
if [ -z "$(pgrep pa-applet)" ]; then
	pa-applet &
fi

# # Lock screen on disabled monitor
# if [ -z "$(pgrep xss-lock)" ]; then
# 	xss-lock -l -- lock &
# fi

# Battery warning
if [ -z "$(pgrep -f i3-battery-popup)" ]; then
	i3-battery-popup -n &
fi

# # Hide idle mouse
# if [ -z "$(pgrep unclutter)" ]; then
# 	unclutter &
# fi

# # Keyboard layout: German, no dead keys
# setxkbmap -layout de -variant nodeadkeys -option ctrl:nocaps

# Display standbye
xset dpms 360 3600 7200

# Keyboard rate
xset r rate 300 60

# No bell
xset -b

# # Wallpaper
# nitrogen --restore

# # Run startup script (which is different on each machine)
# ~/bin/startup.sh &
