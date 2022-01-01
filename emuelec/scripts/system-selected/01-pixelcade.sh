#!/bin/bash

#
# $1 = The system/console identifier from ES (ex. mame, nes, snes...)

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
SYSTEM=$1

  if [ "$SYSTEM" != "" ]; then
    URLENCODED_GAMENAME=$(rawurlencode "$GAMENAME")
    URLENCODED_TITLE=$(rawurlencode "$3")
    PIXELCADEURL="console/stream/"$SYSTEM"/?event=FEScroll" # use this one if you want a generic system/console marquee if the game marquee doesn't exist
    curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &
  else
    PIXELCADEURL="text?t=Error%20the%20system%20name%20or%20the%20game%20name%20is%20blank" # use this one if you want a generic system/console marquee if the game marquee doesn't exist, don't forget the %20 for spaces!
    curl "$PIXELCADEBASEURL$PIXELCADEURL" >> /dev/null 2>/dev/null &	  
  fi
