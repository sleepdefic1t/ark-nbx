#!/bin/bash
#=======================================================================
#
#          FILE:  install.sh
# 
#         USAGE:  sudo ./install.sh 
# 
#   DESCRIPTION:  Install file for ArkBox (a fork of EmptyBox (a fork of PirateBox)). 
# 
#  REQUIREMENTS:  ---
#         NOTES: install.sh should be in same directory as the 'arkbox' folder
#        AUTHOR: Cale 'TerrorByte' Black, cablack@rams.colostate.edu
#        AUTHOR: Brannon Dorsey, brannon@brannondorsey.com (updates for EmptyBox)
#        AUTHOR: sleepdeficit, https://github.com/sleepdefic1t (Ark-Box)
#       COMPANY:  ---
#       CREATED: 02.02.2013 19:50:34 MST
#       UPDATED: 02.22.2015 by Brannon Dorsey
#		ADAPTED: 09.19.2017 sleepdeficit
#      REVISION:  0.8.1
#=======================================================================

echo ""
echo ""
echo "   _____         __            __________               "
echo "  /  _  \_______|  | __        \______   \ _______  ___ "
echo " /  /_\  \_  __ \  |/ /  ______ |    |  _//  _ \  \/  / "
echo "/    |    \  | \/    <  /_____/ |    |   (  <_> >    <  "
echo "\____|__  /__|  |__|_ \         |______  /\____/__/\_ \ "
echo "        \/           \/                \/            \/ "
echo ""
echo "Website: https://ark.io | https://github.com/sleepdefic1t "
echo "		Ark-Box Version: 0.8.1"
echo ""
echo ""

#Import ArkBox conf
CURRENT_CONF=arkbox/conf/arkbox.conf
scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"

#Must be root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" #1>&2
    exit 0
fi

#Checks if ArkBox files are correctly placed relative to the install.sh script
if [[ -f  "$CURRENT_DIR"/$CURRENT_CONF ]]; then
	. $CURRENT_CONF 2> /dev/null
else
	echo "ArkBox config is not in its normal directory."
	echo "Expecting it in \"$CURRENT_DIR/$CURRENT_DIR\"."
	exit 0
fi

#begin setting up arkbox's home dir
if [[ ! -d /opt ]]; then
	mkdir -p /opt
fi

#if arkbox already exists remove it
if [[ -d /opt/arkbox ]]; then
	rm -rf /opt/arkbox &> /dev/null
fi

#Copies arkbox files to working directories
cp -rv "$CURRENT_DIR"/arkbox /opt &> /dev/null
echo "Finished copying files to /opt/arkbox..."

if ! grep "$NET.$IP_SHORT arkbox.lan$" /etc/hosts > /dev/null; then 
	echo "\"$NET.$IP_SHORT arkbox.lan\" found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT arkbox.lan to /etc/hosts"
	echo "$NET.$IP_SHORT arkbox.lan">>/etc/hosts
fi

if ! grep "$NET.$IP_SHORT arkbox$" /etc/hosts > /dev/null ; then 
	echo "\"$NET.$IP_SHORT arkbox\" found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT arkbox to /etc/hosts"
	echo "$NET.$IP_SHORT arkbox">>/etc/hosts
fi

if [[ -d /etc/init.d/ ]]; then
	ln -s /opt/arkbox/init.d/arkbox /etc/init.d/arkbox
	echo "'update-rc.d arkbox defaults' ArkBox will now start at boot"
#	systemctl enable arkbox #This enables ArkBox at start up... could be useful for Live
else
	#link between opt and etc/pb
	ln -s /opt/arkbox/init.d/arkbox.service /etc/systemd/system/arkbox.service
	echo "'systemctl enable arkbox' ArkBox will now start at boot"
fi

#install dependencies
# Modified Script by martedì at http://www.mirkopagliai.it/bash-scripting-check-for-and-install-missing-dependencies/
# Further modified by sleepdeficit. Just do it like Nike.
apt-get install -y hostapd lighttpd dnsmasq
apt-get install -y php5-cgi
apt-get install macchanger

#ArkBox auto-configuration
/opt/arkbox/bin/install_arkbox.sh /opt/arkbox/conf/arkbox.conf part2

#Crontab automatically provides the number of guests connected to your www folder
/opt/arkbox/bin/install_arkbox.sh /opt/arkbox/conf/arkbox.conf station_cnt

#Configures fake-time service
sudo timedatectl set-ntp false
sudo date -s "20170523 1742"
cd /opt/arkbox && sudo ./bin/timesave.sh ./conf/arkbox.conf install
echo ""

#Configures and starts ArkBox.service
sudo systemctl enable arkbox
echo ""
sudo pkill hostapd
sudo pkill dnsmasq
sudo pkill lighttpd
sudo /etc/init.d/arkbox start
sudo service arkbox start
sudo systemctl start arkbox
echo ""

#Configures droopy for ArkBox
sudo sed 's:DROOPY_USE_USER="no":DROOPY_USE_USER="yes":' -i  /opt/arkbox/conf/arkbox.conf
echo ""

#Configures ArkBox
sudo update-rc.d -f arkbox defaults
echo ""

echo ""
echo "	###############################"
echo "	#  ArkBox has been installed  #"
echo "	###############################"
echo ""
echo "** Wait 1-2 minutes, then: 'sudo shutdown now' **" 
echo ""
echo "** Connect ArkBox to a power source (ex: micro-usb pwr) **"
echo ""
echo "** First-boot will take several minutes **"
echo ""
echo "** Default Wifi network is: 'ArkBox - Welcome Aboard!' **"
echo ""
echo ""
echo "**** More info in README! ****"
echo ""

exit 0
