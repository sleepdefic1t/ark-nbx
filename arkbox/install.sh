#!/bin/bash
#=======================================================================
#
#          FILE:  install.sh
# 
#         USAGE:  ./install.sh 
# 
#   DESCRIPTION:  Install file for ArkBox (a fork of EmptyBox (a fork of PirateBox)). 
# 
#       OPTIONS:  ./install.sh
#  REQUIREMENTS:  ---
#          BUGS:  Link from install
#         NOTES:  ---
#        AUTHOR: Cale 'TerrorByte' Black, cablack@rams.colostate.edu
#        AUTHOR: Brannon Dorsey, brannon@brannondorsey.com (updates for EmptyBox)
#        AUTHOR: Sleep Deficit, https://github.com/sleepdefic1t (Ark-Box)
#       COMPANY:  ---
#       CREATED: 02.02.2013 19:50:34 MST
#       UPDATED: 02.22.2015 by Brannon Dorsey
#		ADAPTED: 09.19.2017 sleepdeficit
#      REVISION:  0.3.1
#=======================================================================

#Import ArkBox conf
CURRENT_CONF=arkbox/conf/arkbox.conf
scriptfile="$(readlink -f $0)"
CURRENT_DIR="$(dirname ${scriptfile})"

#Must be root
if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" #1>&2
        exit 0
fi

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
	echo -n "ArkBox already installed. Would you like to overwrite it? (Y/n):"
	read RESPONSE
	if [[ $RESPONSE = "Y" || $RESPONSE = "y" || $RESPONSE = "" ]]; then
		"Removing old /opt/arkbox..."
		rm -rf /opt/arkbox &> /dev/null
	else
		exit 0;
	fi
fi

cp -rv "$CURRENT_DIR"/arkbox /opt &> /dev/null
echo "Finished copying files to /opt/arkbox..."

if ! grep "$NET.$IP_SHORT arkbox.lan$" /etc/hosts > /dev/null; then 
	echo "\"$NET.$IP_SHORT arkbox.lan\" was already found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT arkbox.lan to /etc/hosts"
	echo "$NET.$IP_SHORT arkbox.lan">>/etc/hosts
fi

if ! grep "$NET.$IP_SHORT arkbox$" /etc/hosts > /dev/null ; then 
	echo "\"$NET.$IP_SHORT arkbox\" was already found in /etc/hosts"
else
	echo "Adding $NET.$IP_SHORT arkbox to /etc/hosts"
	echo "$NET.$IP_SHORT arkbox">>/etc/hosts
fi

if [[ -d /etc/init.d/ ]]; then
	ln -sf /opt/arkbox/init.d/arkbox /etc/init.d/arkbox
	echo "To make ArkBox start at boot run: update-rc.d arkbox defaults"
#	systemctl enable arkbox #This enables ArkBox at start up... could be useful for Live
else
	#link between opt and etc/pb
	ln -sf /opt/arkbox/init.d/arkbox.service /etc/systemd/system/arkbox.service
	echo "To make ArkBox start at boot run: systemctl enable arkbox"
fi

#install dependencies
#TODO missing anything in $DEPENDENCIES?
# Modified Script by martedì at http://www.mirkopagliai.it/bash-scripting-check-for-and-install-missing-dependencies/
PKGSTOINSTALL="hostapd lighttpd dnsmasq"
EXTRAPKGSTOINSTALL="php5-cgi macchanger"

# If some dependencies are missing, asks if user wants to install
if [ "$PKGSTOINSTALL" != "" ]; then
	
	echo "ArkBox will install the following dependencies:"
	echo "(They are required for proper functionality)"
	echo "	$PKGSTOINSTALL"
	echo -n "Continue? (Y/n):"
	read PKGSURE

	if [ "$EXTRAPKGSTOINSTALL" != "" ]; then
		echo "ArkBox supports the following addon dependencies:"
		echo "	$EXTRAPKGSTOINSTALL"
		echo -n "Would you like to install them now? (Y/n):"
		read EXTRAPKGSURE
	fi

	# If user want to install missing dependencies
	if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" || $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]] ; then
		# Debian, Ubuntu and derivatives (with apt-get)
		if which apt-get &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				apt-get install $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				apt-get install $EXTRAPKGSTOINSTALL
			fi
		# OpenSuse (with zypper)
		#elif which zypper &> /dev/null; then
		#	zypper in $PKGSTOINSTALL
		# Mandriva (with urpmi)
		elif which urpmi &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				urpmi $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				urpmi $EXTRAPKGSTOINSTALL
			fi
		# Fedora and CentOS (with yum)
		elif which yum &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				yum install $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				yum install $EXTRAPKGSTOINSTALL
			fi
		# ArchLinux (with pacman)
		elif which pacman &> /dev/null; then
			if [[ $PKGSURE = "Y" || $PKGSURE = "y" || $PKGSURE = "" ]]; then 
				pacman -Sy $PKGSTOINSTALL
			fi
			if [[ $EXTRAPKGSURE = "Y" || $EXTRAPKGSURE = "y" || $EXTRAPKGSURE = "" ]]; then
				pacman -Sy $EXTRAPKGSTOINSTALL
			fi
		# Else, if no package manager has been found
		else
			# Set $NOPKGMANAGER
			NOPKGMANAGER=TRUE
			echo "ERROR: No package manager found. Please, manually install:"
			echo "	$PKGSTOINSTALL"
			echo "and (optional):"
			echo "	$EXTRAPKGSTOINSTALL"
		fi
	fi
fi

/opt/arkbox/bin/install_arkbox.sh /opt/arkbox/conf/arkbox.conf part2

echo -n "Would you like to install a crontab to automatically provide the number of connected clients to your www folder? (Y/n):"
read INSTALL_STATION_CNT
if [[ INSTALL_STATION_CNT == "Y" || INSTALL_STATION_CNT == "y" || INSTALL_STATION_CNT == "" ]]; then
	/opt/arkbox/bin/install_arkbox.sh /opt/arkbox/conf/arkbox.conf station_cnt
	[ "$?" == "0" ] echo "Crontab installed. View number of connected station clients at www/station_cnt.txt"
fi

echo ""
echo ""
echo "Configuring autostart"
echo ""
echo "configuring pseudo-time.."
sudo timedatectl set-ntp false
sudo date -s "20170523 1742"
cd /opt/arkbox && sudo ./bin/timesave.sh ./conf/arkbox.conf install
echo ""
echo "enabling arkbox service.."
sudo systemctl enable arkbox
sudo pkill hostapd
sudo pkill dnsmasq
sudo pkill lighttpd
sudo /etc/init.d/arkbox start
sudo service arkbox start
sudo systemctl start arkbox
sudo sed 's:DROOPY_USE_USER="no":DROOPY_USE_USER="yes":' -i  /opt/arkbox/conf/arkbox.conf
sudo update-rc.d -f arkbox defaults
echo ""
echo ""
echo "configuring image & discussion board.."
sudo /opt/arkbox/bin/board-autoconf.sh
echo ""
echo "Autostart configured..."
echo ""
echo ""


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
echo "				Ark-Box Version:   0.1.0"
echo ""
echo ""
echo "	##############################"
echo "	#ArkBox has been installed#"
echo "	##############################"
echo ""
echo ""
echo "	**Wait 1-minute, then: 'sudo reboot'"
echo ""
echo "	**Wait for your RPi to rebooot,**" 
echo ""
echo "	**SSH back into your RPi,**"
echo "	wait another 1-2 minutes, then:"
echo "	'sudo shutdown now'"
echo ""
echo "	*Your ArkBox is now ready!*"
echo "	connect to a power source (ex: micro-usb pwr),"
echo "		and board the Ark via:"
echo "	'ArkBox - Welcome Aboard!' WiFi network."
echo ""
echo "	**** More info in the README! ****"
echo ""
echo ""


exit 0
