#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please run it with sudo or as root user."
  exit 1
fi

set -e

#Initial Update commands
apt-get update && echo "Update successful." || { echo "Update failed. Exiting script."; exit 1; }

apt-get upgrade -y && echo "Upgrade successful." || { echo "Upgrade failed. Exiting script."; exit 1; }

apt-get dist-upgrade -y && echo "Upgrade successful." || { echo "Upgrade failed. Exiting script."; exit 1; }

#Additionals
apt-get install -y aircrack-ng gpsd kismet realtek-rtl88xxau-dkms dkms && echo "Installation of packages successful." || { echo "Package installation failed. Exiting script."; exit 1; }

#realtek stuff
git clone https://github.com/aircrack-ng/rtl8812au && echo "Cloning rtl8812au repository successful." || { echo "Cloning rtl8812au repository failed. Exiting script."; exit 1; }
cd rtl8812au || { echo "Failed to enter rtl8812au directory. Exiting script."; exit 1; }

apt install linux-headers-$(uname -r) && echo "Installation of linux-headers successful." || { echo "Installation of linux-headers failed. Exiting script."; exit 1; }
ls /lib/modules/$(uname -r)/build && echo "Kernel headers check successful." || { echo "Kernel headers check failed. Exiting script."; exit 1; }
cd .. || { echo "Failed to return to previous directory. Exiting script."; exit 1; }

#kismet trilateration script
git clone https://github.com/daiceman825/kismet.git && echo "Cloning kismet repository successful." || { echo "Cloning kismet repository failed. Exiting script."; exit 1; }
cd kismet || { echo "Failed to enter kismet directory. Exiting script."; exit 1; }

pip3 install -r requirements.txt && echo "Python dependencies installation successful." || { echo "Python dependencies installation failed. Exiting script."; exit 1; }

cd .. || { echo "Failed to return to previous directory. Exiting script."; exit 1; }

#enabling background stuff
systemctl start gpsd && echo "Started gpsd service successfully." || { echo "Starting gpsd service failed. Exiting script."; exit 1; }

#kismet, and gpsd reconfiguration
read -p "Do you want to change from the default configuration? (y/n): " response
if [[ $response == [yY]* ]]; then
  echo "Proceeding with configuration change..."
  cat kismetconf >> /etc/kismet/kismet.conf && echo "Updated kismet.conf successfully." || { echo "Updating kismet.conf failed. Exiting script."; exit 1; }
  cat gpsdconf >> /etc/default/gpsd && echo "Updated gpsd configuration successfully." || { echo "Updating gpsd configuration failed. Exiting script."; exit 1; }

  rm gpsdconf kismetconf && echo "Removed temporary configuration files successfully." || { echo "Removing temporary configuration files failed. Exiting script."; exit 1; }

  sed -i "s/keep_location_cloud_history=false/keep_location_cloud_history=true/" /etc/kismet/kismet_memory.conf && echo "Updated kismet_memory.conf successfully." || { echo "Updating kismet_memory.conf failed. Exiting script."; exit 1; }
  sed -i "s/channel_hop=true/channel_hop=true\nchannels=1,6,11\nchannels=1,3,6,9,11/" /etc/kismet/kismet.conf && echo "Updated kismet.conf channels successfully." || { echo "Updating kismet.conf channels failed. Exiting script."; exit 1; }
  sed -i "s/randomized_hopping=true/randomized_hopping=false/" /etc/kismet/kismet.conf && echo "Updated randomized hopping in kismet.conf successfully." || { echo "Updating randomized hopping in kismet.conf failed. Exiting script."; exit 1; }


  echo "Installation and configuration completed successfully."

  echo "Configuration change was successful."

else
  echo "Using default configuration. Exiting script."
  exit 0
fi

prompt_reboot() {
  echo "The script has completed successfully."
  read -t 15 -p "The system will reboot in 15 seconds. Press 'y' to reboot now or any other key to cancel: " reboot_response
  if [[ $reboot_response == [yY]* ]]; then
    echo "Rebooting now..."
    reboot
  else
    echo "Reboot canceled."
  fi
}

prompt_reboot
