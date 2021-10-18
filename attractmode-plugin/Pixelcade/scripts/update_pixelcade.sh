#!/bin/bash
display_text="$1"
emulator="$2"
rom="$3"
emulator=$(sed 's/ /%20/g' <<< "$emulator")
rom=$(sed 's/ /%20/g' <<< "$rom")
if [ "$emulator" = "@" ] ; then
  curl -G --data-urlencode "t=$display_text" "http://localhost:8080/console/stream/$rom"
else
  curl -G --data-urlencode "t=$display_text" "http://localhost:8080/arcade/stream/$emulator/$rom"
fi
