#!/bin/bash
# startup script for a dedicated Pi for Pixelcade
cat << "EOF"
       _          _               _
 _ __ (_)_  _____| | ___ __ _  __| | ___
| '_ \| \ \/ / _ \ |/ __/ _` |/ _` |/ _ \
| |_) | |>  <  __/ | (_| (_| | (_| |  __/
| .__/|_/_/\_\___|_|\___\__,_|\__,_|\___|
|_|
EOF

# check if we are wifi connected
STATE="error";

while [  $STATE == "error" ]; do
    #do a ping and check that its not a default message or change to grep for something else
    STATE=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && echo ok || echo error)
    echo "checking network connection..."

    if [[ -f "$HOME/pixelcade/deletemeafterwificonnect.txt" ]]; then  #still exists so we are not wifi complete so show a different message
        curl  "http://localhost:8080/text?t=Using%20your%20phone%20or%20computer,%20connect%20to%20the%20%22Pixelcade%20Setup%22%20WiFi%20and%20then%20navigate%20to%20http%20:%20//%2010%20.%200%20.%200%20.%201%20%20from%20your%20device%20web%20browser%20.%20%20Then%20select%20your%20normal%20WiFi%20network%20and%20password%20.&size=32&loop=10&color=cyan&font=Tall%20Films%20Fine&yoffset=-2"
    else
        curl  "http://localhost:8080/text?t=wifi%20not%20connected%20troubleshooting%20guide%20at%20pixelcade.org/pi-install&size=14&l=1&color=red"
    fi
    #sleep for 2 seconds and try again
    sleep 2
 done

#ok we are connected so let's scroll the IP address
pi_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
# we connected so let's delete that file
sudo rm $HOME/pixelcade/deletemeafterwificonnect.txt #delete that file so next time the error message will be different
curl  "http://localhost:8080/text?t=Address:%20http://pixelcade.local:8080%20or%20http://$pi_ip:8080&c=green&size=24"


exit
