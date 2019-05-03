if [[ "$1" == tv ]]; then
	xrandr --output DP-2 --mode 1920x1080 --rotate right --pos 0x0 --output HDMI-0 --pos 1080x400 --primary --mode 2560x1440 --output DP-0 --mode 2560x1440 --pos 3640x400 --output HDMI-1 --mode 3840x2160 --pos 2560x1920 
else
	xrandr --output DP-2 --mode 1920x1080 --rotate right --pos 0x0 --output HDMI-0 --pos 1080x400 --primary --mode 2560x1440 --output DP-0 --mode 2560x1440 --pos 3640x400
fi

