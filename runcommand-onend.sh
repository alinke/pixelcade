#!/bin/sh

#v2.1.4
# *************** Defaults you can change in this section if needed *********************
# Change this only if you have the pixelcade directory in a different location
PIXELPATH="/home/pi/pixelcade/"
#*******************************************************************************************
# Only change this if you Pi is on a different port that this one
PIPATH="/dev/ttyACM0"
#*******************************************************************************************

GAMEIMAGE=ARCADEDEFAULT #set this as the default and then will change it based on what game / platform is launched
USERMESSAGE=""
MAMEGAMETITLE=""

pixelexists="ls $PIPATH"

if $pixelexists | grep -q '/dev/ttyACM0'; then  #let's only go here if we detect PIXEL via a ls /dev/ttyACM0 command
   #echo "*** PIXEL LED Marquee ***"

   cd $PIXELPATH
   # $1 is passed to us from RetroPi and tells us the arcade platform, $3 is the rom path
   PLATFORM=$1
   ROMPATH=$3

   echo "**** PIXEL LED MARQUEE LOG ****" >&2
   #Note the log (all lines with >&2) is written here on your Pi /root/dev/shm/runcommand.log
   echo "Selected Platform: ${PLATFORM}" >&2
   echo "Selected Game Full Path: ${ROMPATH}" >&2

   #now we're done, let's call the code to write the LED marquee image
   # but let's first check if the current gif is the same as the newly selected one and if yes, we'll skip the write to save time
       if [[ -f "pixel-logo.txt" ]]; then  #some ascii art for logo is in this file
         cat "pixel-logo.txt"
         echo " "
       else
          echo "*** PIXEL LED Marquee ***"
       fi
       echo $USERMESSAGE
       echo >&2
       #Use verbose mode first and then silent mode once everything is working
       #verbose mode
       #java -jar "${PIXELPATH}pixelcade.jar" -m stream -c "$PLATFORM" -g dummy
       # silent mode
       java -jar "${PIXELPATH}pixelcade.jar" -m stream -c "$PLATFORM" -g dummy -s

else echo "PIXEL LED Marquee Not Detected" >&2
fi
