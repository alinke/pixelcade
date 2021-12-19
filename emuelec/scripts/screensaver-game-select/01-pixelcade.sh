#!/bin/bash

#
# Call the game-select pixelcade script to centralize the logic
#
bash /emuelec/scripts/game-select/01-pixelcade.sh "$@" > /dev/null 1> /dev/null
