#!/bin/bash
case $1 in
    nvidia)
        exec nvidia-xrun gnome-session
        ;;
    *)
        if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && [[ -z $XDG_SESSION_TYPE ]]; then
        	XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
        fi
    ;;
esac
