#!/bin/sh

sudo apt-get upgrade; sudo apt update; sudo apt install -y aircrack-ng; sudo apt-get install gpsd; sudo apt-get install cgps;  sudo apt install kismet; sudo apt-get install kismet-plugins; git clone https://github.com/hobobandy/kestrel; cd kestrel/plugin-kestrel; sudo make install; cd ../..; git clone https://github.com/daiceman825/kismet.git; cd kismet; pip3 install -r requirements.txt; cd ..; sudo apt-get install realtek-rtl88xxau-dkms
