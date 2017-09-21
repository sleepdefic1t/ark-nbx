#!/bin/sh

if [[ ! -d /opt/arkbox/share/board ]]; then
    echo "You have to install the imageboard first!"
    echo "Run (as root):"
    echo "\t/opt/arkbox/bin/install_arkbox.sh /opt/arkbox/conf/arkbox.conf imageboard"
else
    echo -n "Imageboard admin password: "
    read -s BOARDPASSWORD
    echo
    sed -i "s|xyzPASSWORDzyx|$BOARDPASSWORD|g" /opt/arkbox/share/board/config.pl

    TEMPRAND=$(< /dev/urandom tr -dc A-Za-z0-9_ | head -c128)
    sed -i "s|xyzSECRETCODEzyx|$TEMPRAND|g" /opt/arkbox/share/board/config.pl

    sed -i "s|#use constant ADMIN_PASS|use constant ADMIN_PASS|" /opt/arkbox/share/board/config.pl
    sed -i "s|#use constant SECRET|use constant SECRET|" /opt/arkbox/share/board/config.pl

    # Remove temporary index page and then try to initialize the board
    test -e /opt/arkbox/share/board/index.htm && rm /opt/arkbox/share/board/index.htm
    #wget -q -s -O -  http://127.0.0.1/board/kareha.pl 2>/dev/null
    wget -qO- http://127.0.0.1/board/kareha.pl &> /dev/null
fi
