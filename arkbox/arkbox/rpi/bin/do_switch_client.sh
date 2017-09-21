#!/bin/sh

# Wrapper script for the steps to enable wifi client

systemctl stop arkbox
if /opt/arkbox/rpi/run_client.sh ; then
    echo "Started Wifi client sucessfully!"
    exit 0
else
    echo "Error while starting wifi client, restarting arkbox"
    systemctl start arkbox
    exit 1
fi
exit 1
