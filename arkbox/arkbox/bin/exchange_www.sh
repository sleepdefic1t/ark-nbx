#!/bin/sh
#
# Matthias Strubel , 2013 (c) GPL-3
#   matthias.strubel@aod-rpg.de
# adapted by sleepdeficit ,  2017
#

# Move www folder to given destination

# Load configfile

if [ -z  $1 ] || [ -z $2 ]; then 
  echo "Usage change_www my_config <destination>
      i.e. # exchange_www.sh /opt/arkbox/conf/Arkbox.conf  /mnt/usb/ArkBox/www_alt  "
      exit 1
fi


if [ !  -f $1 ] ; then 
  echo "Config-File $1 not found..." 
  exit 1 
fi

#Load config
. $1 

      echo "----------------------------------------------------"
      echo "####          $2                ####"
      echo "####         switching directories              ####"
      echo "----------------------------------------------------"

      mv  $WWW_FOLDER  $ARKBOX_FOLDER/www_old 
      ln -sf   $2  $WWW_FOLDER
      echo "  Copy over >>fake internet detection-stuff<<"
      cp -v  $ARKBOX_FOLDER/www_old/ncsi.txt $WWW_FOLDER
      cp -rv $ARKBOX_FOLDER/www_old/library  $WWW_FOLDER
      echo "  Copy over >>redirect.html<< for automatic redirect on  wrong entered page<<"
      cp -v  $ARKBOX_FOLDER/www_old/redirect.html $WWW_FOLDER
      echo "  Done. Now, you are on your own! "
