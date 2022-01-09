#!/bin/bash

#
# $1 = quit mode, "reboot" or "shutdown"
#
PIXELCADEBASEURL="http://127.0.0.1:8080/"
PIXELCADEURL="text?t=Bye" # use this one if you want a generic system/console marquee if the game marquee doesn't exist, don't forget the %20 for spaces!
curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
