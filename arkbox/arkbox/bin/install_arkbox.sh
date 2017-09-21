#!/bin/sh
## ArkBox installer script
##  created by Matthias Strubel   (c)2011-2014 GPL-3
##

create_content_folder(){

   echo "Creating 'content' folder on USB stick and move over stuff"
   mkdir -p $WWW_CONTENT
   cp -r     $ARKBOX_FOLDER/www_content/*   $WWW_CONTENT

   [ ! -L $ARKBOX_FOLDER/www/content  ] && \
		ln -s $WWW_CONTENT  $WWW_FOLDER/content
   [ ! -e $WWW_FOLDER/favicon.ico ] && \
		ln -s $WWW_CONTENT/favicon.ico $WWW_FOLDER

   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $WWW_CONTENT -R
   chmod  u+rw $WWW_CONTENT
   return 0
}

# Load configfile

if [ -z  $1 ] || [ -z $2 ]; then
  echo "Usage install_arkbox my_config <part>"
  echo "   Parts: "
  echo "       part2          : sets Permissions and links correctly"
  echo "       imageboard     : configures kareha imageboard with Basic configuration"
  echo "                        should be installed in <Arkbox-Folder>/share/board"
  echo "       pyForum        : Simple PythonForum"
  echo "       station_cnt        : Adds Statio counter to your Box - crontab entry"
  echo "       flush_dns_reg      : Installs crontask to flush dnsmasq regulary"
  echo "       hostname  'name'   : Exchanges the Hostname displayed in browser"
  exit 1
fi


if [ !  -f $1 ] ; then
  echo "Config-File $1 not found..."
  exit 1
fi

#Load config
ARKBOX_CONFIG=$1
. $1

if [ $2 = 'pyForum' ] ; then
    cp -v $ARKBOX_FOLDER/src/forest.py  $WWW_FOLDER/cgi-bin
    cp -v $ARKBOX_FOLDER/src/forest.css $WWW_FOLDER/content/css
    mkdir -p $ARKBOX_FOLDER/forumspace
    chmod a+rw -R  $ARKBOX_FOLDER/forumspace 2> /dev/null
    chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $WWW_FOLDER/cgi-bin/forest.py
    chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $WWW_FOLDER/content/forest.css  2> /dev/null
    echo "Copied the files. Recheck your ArkBox now. "
fi



if [ $2 = 'part2' ] ; then
   echo "Starting initialize ArkBox Part2.."
#Create directories
#   mkdir -p $ARKBOX_FOLDER/share/Shared
   mkdir -p $UPLOADFOLDER
   mkdir -p $ARKBOX_FOLDER/share/board
   mkdir -p $ARKBOX_FOLDER/share/tmp
   mkdir -p $ARKBOX_FOLDER/tmp

   #Distribute the Directory Listing files
   $ARKBOX_FOLDER/bin/distribute_files.sh $SHARE_FOLDER/Shared true
   #Set permissions
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $ARKBOX_FOLDER/share -R
   chmod  u+rw $ARKBOX_FOLDER/share
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $ARKBOX_FOLDER/www -R
   chmod u+x $ARKBOX_FOLDER/www/cgi-bin/*
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $ARKBOX_FOLDER/tmp
   chown $LIGHTTPD_USER:$LIGHTTPD_GROUP  $ARKBOX_FOLDER/tmp -R


#Install a small script, that the link on the main page still works
   if  [ !  -f $ARKBOX_FOLDER/share/board/kareha.pl ] ; then
      cp $ARKBOX_FOLDER/src/kareha.pl $ARKBOX_FOLDER/share/board
   fi

   [ ! -L $ARKBOX_FOLDER/www/board  ] && ln -s $ARKBOX_FOLDER/share/board $ARKBOX_FOLDER/www/board
   [ ! -L $ARKBOX_FOLDER/www/Shared ] && ln -s $UPLOADFOLDER  $ARKBOX_FOLDER/www/Shared
   [ ! -L $ARKBOX_FOLDER/www/content  ] && \
       ln -s $WWW_CONTENT  $WWW_FOLDER/content

fi

#Install the image-board
if [ $2 = 'imageboard' ] ; then

    if [ -e  $ARKBOX_FOLDER/share/board/init_done ] ; then
       echo "$ARKBOX_FOLDER/share/board/init_done file Found in Kareha folder. Won't reinstall board."
       exit 0;
    fi


    cd $ARKBOX_FOLDER/tmp
    KAREHA_RELEASE=kareha_3.1.4.zip
    if [ ! -e $ARKBOX_FOLDER/tmp/$KAREHA_RELEASE ] ; then
	echo "  Wgetting kareha-zip file "
    	wget http://wakaba.c3.cx/releases/$KAREHA_RELEASE
	if [ "$?" != "0" ] ; then
       		echo "wget kareha failed.. you can place the current file your to  $ARKBOX_FOLDER/tmp "
	 fi
    fi

    if [ -e  $ARKBOX_FOLDER/tmp/$KAREHA_RELEASE ] ; then
       echo "Kareha Zip found..."
    else
       echo "No Zip found, abort "
       exit 255
    fi

    unzip $KAREHA_RELEASE
    mv kareha/* $ARKBOX_FOLDER/share/board
    rm  -rf $ARKBOX_FOLDER/tmp/kareha*

    cd  $ARKBOX_FOLDER/share/board
    cp -R  mode_image/* ./
    cp  $ARKBOX_FOLDER/src/kareha_img_config.pl $ARKBOX_FOLDER/share/board/config.pl
    cp  $ARKBOX_FOLDER/src/no_forum.html  $ARKBOX_FOLDER/share/board/index.htm
    chown -R $LIGHTTPD_USER:$LIGHTTPD_GROUP  $ARKBOX_FOLDER/share/board
    #Install filetype thumbnails
    mv $ARKBOX_FOLDER/share/board/extras/icons  $ARKBOX_FOLDER/share/board/

    echo "Errors in chown occurs if you are using vfat on the USB stick"
    echo "   . don't Panic!"
    echo "Generating index page"
    cd /tmp
    wget -q http://127.0.0.1/board/kareha.pl
    echo "finished!"
    echo "Now Edit your kareha settings file to change your ADMIN_PASS and SECRET : "
    echo "  # vi $ARKBOX_FOLDER/www/board/config.pl "

    touch  $ARKBOX_FOLDER/share/board/init_done
fi

if [ $2 = "station_cnt" ] ; then
    #we want to append the crontab, not overwrite
    crontab -l   >  $ARKBOX_FOLDER/tmp/crontab 2> /dev/null
    echo "#--- Crontab for ArkBox-Station-Cnt" >>  $ARKBOX_FOLDER/tmp/crontab
    echo " */2 * * * *    $ARKBOX_FOLDER/bin/station_cnt.sh >  $WWW_FOLDER/station_cnt.txt "  >> $ARKBOX_FOLDER/tmp/crontab
    crontab $ARKBOX_FOLDER/tmp/crontab
    [ "$?" != "0" ] && echo "an error occured" && exit 254
    $ARKBOX_FOLDER/bin/station_cnt.sh >  $WWW_FOLDER/station_cnt.txt
    echo "installed, now every 2 minutes your station count is refreshed"
fi

if [ $2 = "flush_dns_reg" ] ; then
    crontab -l   >  $ARKBOX_FOLDER/tmp/crontab 2> /dev/null
    echo "#--- Crontab for dnsmasq flush" >>  $ARKBOX_FOLDER/tmp/crontab
    echo " */2 * * * *    $ARKBOX_FOLDER/bin/flush_dnsmasq.sh >  $ARKBOX_FOLDER/tmp/dnsmasq_flush.log "  >> $ARKBOX_FOLDER/tmp/crontab
    crontab $ARKBOX_FOLDER/tmp/crontab
    [ "$?" != "0" ] && echo "an error occured" && exit 254
    echo "Installed crontab for flushing dnsmasq requlary"
fi

set_hostname() {
	local name=$1 ; shift;

	sed  "s|#####HOST#####|$name|g"  $ARKBOX_FOLDER/src/redirect.html.schema >  $WWW_FOLDER/redirect.html
        sed "s|HOST=\"$HOST\"|HOST=\"$name\"|" -i  $ARKBOX_CONFIG
}

if [ $2 = "hostname" ] ; then
	echo "Switching hostname to $3"
	set_hostname "$3"
	echo "..done"
fi

if [ $2 = "content" ] ; then
	create_content_folder
fi
