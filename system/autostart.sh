#!/bin/bash
# startup script for a dedicated Pi for Pixelcade, systemd calls this via /etc/systemd/system/pixelcade.service

cd /home/pi/pixelcade && ./pixelweb -b &
sleep 10 && cd /home/pi/pixelcade/system && ./pixelcade-startup.sh
