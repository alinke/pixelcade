#!/bin/sh

#
# $1 = The fully qualified name of the rom file (ex. /storage/roms/mame/digdug.zip)
# $2 = The name of the game associated to the rom file (ex. digdug)
# $3 = Game Title , note this is only on 4.4 and above, 4.3 does not have the game title an will be blank in which case we will scroll the rom name
# /storage/roms/mame/digdug.zip digdug
#

rawurlencode() {  #this is needed for rom names with spaces
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

# BASE URL for RESTful calls to Pixelcade
PIXELCADEBASEURL="http://127.0.0.1:8080/"
SYSTEM=$(basename $(dirname "$1")) #get just the console / system name like mame, nes, etc.
GAMENAME="$2"
if [ "$3" != "" ]; then
		GAMETITLE="$3"  #then game title is populated
else
		GAMETITLE="$2"  #then game title is not there so we'll use the rom name
fi

#we'll first scroll "Now Playing Game Title" and then show the marquee
	if [ "$SYSTEM" != "" ] && [ "$GAMENAME" != "" ]; then
	  #clear the Pixelcade Queue, see http://pixelcade.org/api for info on the Queue feature
		PIXELCADEURL="console/stream/black"
		curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
		#now let's scroll the now playing text
		URLENCODED_GAMENAME=$(rawurlencode "$GAMENAME")
	  URLENCODED_TITLE=$(rawurlencode "$GAMETITLE") #TO DO would be nice to get the game title here as opposed to the rom name, this would require a mod to ES
		PIXELCADEURL="text?t=Now%20Playing%20"$URLENCODED_TITLE"&loop=1&event=GameStart" # use this one if you want a generic system/console marquee if the game marquee doesn't exist, don't forget the %20 for spaces!
		curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
    #now let's display the game marquee
		sleep 1 #for some reason, didn't always work without this
    PIXELCADEURL="arcade/stream/"$SYSTEM"/"$URLENCODED_GAMENAME"?loop=99999&event=GameStart" # use this one if you want a generic system/console marquee if the game marquee doesn't exist
	  #PIXELCADEURL="arcade/stream/"$SYSTEM"/"$URLENCODED_FILENAME"?t="$URLENCODED_TITLE"" # use this one if you want scrolling text if the game marquee doesn't exist
	  curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
	else
		PIXELCADEURL="text?t=Error%20the%20system%20name%20or%20the%20game%20name%20is%20blank" # use this one if you want a generic system/console marquee if the game marquee doesn't exist, don't forget the %20 for spaces!
		curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
	fi
