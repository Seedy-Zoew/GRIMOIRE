#!/bin/sh

set -e

sudo apt-get update

sudo apt-get upgrade -y

sudo apt-get install -y aircrack-ng gpsd cgps kismet realtek-rtl88xxau-dkms

git clone https://github.com/daiceman825/kismet.git
cd kismet

pip3 install -r requirements.txt

cd ..

sudo cat kismetconf >> /etc/kismet/kismet.conf
sudo cat gpsdconf >> /etc/default/gpsd

rm gpsdconf kismetconf

sudo sed -i "s/keep_location_cloud_history=false/keep_location_cloud_history=true/" /etc/kismet/kismet_memory.conf
sudo sed -i "s/channel_hop=true/channel_hop=true\nchannels=1,6,11\nchannels=1,3,6,9,11/" /etc/kismet/kismet.conf
sudo sed -i "s/randomized_hopping=true/randomized_hopping=false/" /etc/kismet/kismet.conf

sudo systemctl start gpsd

echo "Installation and configuration completed successfully."
