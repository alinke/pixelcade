#!/bin/sh

#v2.1.4
# *************** Defaults you can change in this section if needed *********************
# Change this only if you have the pixelcade directory in a different location
PIXELPATH="/home/pi/pixelcade/"
#*******************************************************************************************
# Only change this if you Pi is on a different port that this one
PIPATH="/dev/ttyACM0"
#*******************************************************************************************
MAMECSV="mame.csv"  # .csv file that maps rom name to game name
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
   # Let's extract just the filename so we can use for the mame.csv rom to title mapping
   GAMEFILENAME=$(basename -- "$ROMPATH")
   GAMEFILENAME="${GAMEFILENAME%.*}"

   echo "**** PIXEL LED MARQUEE LOG ****" >&2
   #Note the log (all lines with >&2) is written here on your Pi /root/dev/shm/runcommand.log
   echo "Selected Platform: ${PLATFORM}" >&2
   echo "Selected Game Full Path: ${ROMPATH}" >&2


   if [[ $PLATFORM == "mame-libretro" ]] || [[ $PLATFORM == "mame-mame4all" ]] || [[ $PLATFORM == "arcade" ]] || [[ $PLATFORM == "mame-advmame" ]] ;then

       if [[ -f "$MAMECSV" ]]; then
         #while IFS=, read -r romname title year manufacturer rpi2	rpi3	bios	notes
        while IFS=, read -r romname title
         do
             if [[ $romname = $GAMEFILENAME ]];then
               USERMESSAGE="Writing LED Marquee for $title..."
               #MAMEGAMETITLE=$title
               #echo "Writing LED Marquee for $title..."
             fi
         done < $MAMECSV
       else
           echo "file $MAMECSV does not exist"
       fi
  fi

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
       # use verbose mode initially and then switch to silent mode once everything is working
       #java -jar "${PIXELPATH}pixelcade.jar" -m stream -c "$PLATFORM" -g "${ROMPATH}" -t "${MAMEGAMETITLE}"
       #silent mode
    
       java -jar "${PIXELPATH}pixelcade.jar" -m stream -c "$PLATFORM" -g "${ROMPATH}" -s -gt #this will work for non MAME too if the mapping is in mame.csv


       # if you don't want the scrolling text for games that don't have an image
       #java -jar "${PIXELPATH}pixelcade.jar" -m stream -c "$PLATFORM" -g "${ROMPATH}"

else echo "PIXEL LED Marquee Not Detected" >&2
fi
