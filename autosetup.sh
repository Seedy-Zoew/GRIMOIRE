#!/bin/sh

sudo apt-get upgrade -y; sudo apt-get update -y; sudo apt-get install -y aircrack-ng; sudo apt-get install -y kismet; git clone https://github.com/hobobandy/kestrel && cd plugin-kestrel && sudo make install && cd ..; git clone https://github.com/daiceman825/kismet.git; cd kismet; pip3 install -r requirements.txt; cd ..; sudo apt-get install realtek-rtl88xxau-dkms
