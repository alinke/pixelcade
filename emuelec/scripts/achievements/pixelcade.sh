#!/bin/bash

# echo "Achievement $1 | Name $2 | Description $3" > /emuelec/configs/achievement.txt

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

PIXELCADEBASEURL="http://127.0.0.1:8080/"
URLENCODED_TITLE=$(rawurlencode "$2")
URLENCODED_DESC=$(rawurlencode "$3")
ACHIEVEMENTID=$1

PIXELCADECURRENTMARQUEE=$(curl "http://127.0.0.1:8080/currentgame") #api call that gets the last game selected, returns ex. mame%digdug
CURRENTCONSOLE=$(echo $PIXELCADECURRENTMARQUEE | cut -d "%" -f 1) #ex. mame
CURRENTGAME=$(echo $PIXELCADECURRENTMARQUEE | cut -d "%" -f 2)  #ex. digdug
CURRENTGAME=$(rawurlencode "$CURRENTGAME")
echo $PIXELCADECURRENTMARQUEE
PIXELCADEURL="achievements/stream/$CURRENTCONSOLE/$ACHIEVEMENTID?t=$URLENCODED_TITLE%20:%20$URLENCODED_DESC&currentgame=$CURRENTGAME"
curl "$PIXELCADEBASEURL$PIXELCADEURL"
