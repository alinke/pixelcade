#!/bin/bash

#
# $1 = The system identifier from ES
# $2 = the method that was calling it
#	gotostart       - first time selection of the system during startup
#	input           - the system selected by the user interface
#       requestedsystem - the startup system selected via configuration settings
#

#
# Configurations
#
PREVIOUSGAMESELECTEDFILE="/storage/roms/pixelcade/.game-select"
PREVIOUSGAMESELECTED="console/$1/default"

#
# Wait for the "splash video" playing from omxplayer before switching to the requested system the first time
#
if [ "$2" == "gotostart" ] || [ "$2" == "requestedsystem" ]; then
	while pgrep "omxplayer" > /dev/null; do sleep 1; done
fi

#
# ignore requested system so the first game selected's marquee  will be displayed
# Compare the requested system to the saved system.
# If this is the first time displaying a marquee, or it's not the same as the last system, display the new marquee.
#
if [ "$2" != "requestedsystem" ]; then
	if [ "$2" == "gotostart" ] || [ "$(cat "$PREVIOUSGAMESELECTEDFILE")" != "$PREVIOUSGAMESELECTED" ]; then
		#
		# Call pixelcade with the request.
		#
		curl --silent "http://localhost:8080/console/stream/$1" >> /dev/null 2>/dev/null &
		echo "$PREVIOUSGAMESELECTED" > "$PREVIOUSGAMESELECTEDFILE"
	fi
fi
