#!/bin/sh
#  by Matthias Strubel ,  2012
#
#   Sends a SIGHUB to dnsmasq to reread its hosts files
#     Needed for mesh feature. Will enable easy dns-service for this.

PIDFILE_DNSMASQ=/var/run/arkbox_dnsmasq.pid

kill -1 `cat $PIDFILE_DNSMASQ`
