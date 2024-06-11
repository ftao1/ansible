#!/bin/bash

#########################################################################
#                                                                       #
# Description   : Fact gathering script for remote servers              #
# Script        : getinfo.sh                                            #
# Dependencies  : ansible                                               #
# Usage         : bash getinfo.sh                                       #
# Author        : Fai Tao                                               #
# Version       : 0.1                                                   #
# Date          : 25 Mar 2020                                           #
#                                                                       #
# Change history (most recent first)                                    #
#                                                                       #
# Date          Who             Comments                                #
# ----          ---             --------                                #
# 25/03/20      FT              Initial draft                           #
#########################################################################

#set -xv

##### Set variables #####
TIME=$(date +%c)
DATE=$(date +%Y%m%d)
HDIR="/home/ftao/$(hostname).facts.${DATE}.txt"


cat <<EOF > ${HDIR}
---------------------------------------------------------------
HOSTNAME: $(hostname)
---------------------------------------------------------------
IP/MASK: $(ip a | grep inet | awk '/brd/ {print $2}')
---------------------------------------------------------------
GATEWAY: $(route -n | grep "^0.0.0.0" | awk '{print $2}')
---------------------------------------------------------------
NTP:
$(grep "^server ...\." /etc/ntp.conf)
---------------------------------------------------------------
DNS:
$(grep "^nameserver " /etc/resolv.conf)
---------------------------------------------------------------
DISKS:

$(df -h)
---------------------------------------------------------------
SUDOERS:

$(cat /etc/sudoers)
---------------------------------------------------------------
NTP STATUS:

EOF

ntpstat | grep sync > /dev/null 2>&1

if [ $? -ne 0 ]
then
    echo "It appears NTP is not currently running on $(hostname). Please check.
---------------------------------------------------------------" >> ${HDIR}
else
    echo "NTP seems to be running on $(hostname).
---------------------------------------------------------------" >> ${HDIR}
fi

