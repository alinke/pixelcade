#!/bin/sh

#
# $1 = The fully qualified name of the rom file
# $2 = The name of the game associated to the rom file
#

#
# Write these commands to a separate bash script and execute as a new process so it doesn't tie up game starting
#
# 1. Saves the current selected game
# 2. Displays the "Now Loading..." animated gif on the pixelcade
# 3. Waits 11 seconds
# 4. Sets the current selected game's logo (or the system logo using existing logic in game-select script
# 5. Writes the previous selected game back
#
# This should prevent flickering after the game is exited.
#
rm -f /storage/roms/pixelcade/.game-start.sh > /dev/null 2>/dev/null
rm -f /storage/roms/pixelcade/.game-end.sh > /dev/null 2>/dev/null

SYSTEM=$(basename $(dirname "$1"))
if [ "$SYSTEM" != "retropiemenu" ]; then #ignore the options menu
	PREVIOUSGAMESELECTEDFILE="/storage/roms/pixelcade/.game-select"
	PREVIOUSGAMESELECTED=$(cat "$PREVIOUSGAMESELECTEDFILE" 2>/dev/null)
	#echo "curl --silent "http://localhost:8080/console/stream/nowloading"  > /dev/null 2>/dev/null" > /storage/roms/pixelcade/.game-start.sh
	#echo "sleep 11s" >> /storage/roms/pixelcade/.game-start.sh
	echo "rm -f \""$PREVIOUSGAMESELECTEDFILE"\" >/dev/null 2>/dev/null" >> /storage/roms/pixelcade/.game-start.sh
	#echo  "/storage/.emulationstation/scripts/game-select/01-pixelcade.sh  \"$(basename $(dirname "$1"))\" \"$(basename "$1")\" \"$2\"" >> /storage/roms/pixelcade/.game-start.sh
  echo  "/storage/.emulationstation/scripts/game-select/01-pixelcade.sh  \"$(basename $(dirname "$1"))\" \"$2\" \"$2\"" >> /storage/roms/pixelcade/.game-start.sh
	echo "echo \""$PREVIOUSGAMESELECTED"\" > \""$PREVIOUSGAMESELECTEDFILE"\"" >> /storage/roms/pixelcade/.game-start.sh

	#echo "curl --silent "http://localhost:8080/text?t=Game%20Over"  > /dev/null 2>/dev/null" > /storage/roms/pixelcade/.game-end.sh
	#echo "sleep 2s" >> /storage/roms/pixelcade/.game-end.sh
	echo "rm -f \""$PREVIOUSGAMESELECTEDFILE"\" >/dev/null 2>/dev/null" >> /storage/roms/pixelcade/.game-end.sh
	echo  "/storage/.emulationstation/scripts/game-select/01-pixelcade.sh  \"$(basename $(dirname "$1"))\" \"$2\" \"$2\"" >> /storage/roms/pixelcade/.game-end.sh
	echo "echo \""$PREVIOUSGAMESELECTED"\" > \""$PREVIOUSGAMESELECTEDFILE"\"" >> /storage/roms/pixelcade/.game-end.sh

	chmod +x /storage/roms/pixelcade/.game-start.sh
	chmod +x /storage/roms/pixelcade/.game-end.sh
	/storage/roms/pixelcade/.game-start.sh > /dev/null 2>/dev/null &
else
	rm -f /storage/roms/pixelcade/.game-start.sh > /dev/null 2>/dev/null
	rm -f /storage/roms/pixelcade/.game-end.sh > /dev/null 2>/dev/null
fi
