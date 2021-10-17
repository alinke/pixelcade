#!/bin/bash
display_text="$1"
emulator="$2"
rom="$3"

curl -G --data-urlencode "t=$display_text" http://localhost:8080/arcade/stream/$emulator/$rom
