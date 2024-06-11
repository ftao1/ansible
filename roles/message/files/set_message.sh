#!/bin/bash

# Script to configure the /root/.message file for nodes
# FT v0.1 03/02/20


CONSOLE1=$(grep $(hostname -s) <<\EOF
dl38001 dl380g10-01-console Example 01 LOC-01 U(34-35)
dl38002 dl380g10-02-console Example 02 LOC-02 U(34-35)
dl38003 dl380g10-03-console Example 03 LOC-03 U(34-35)
EOF
)

HOST1=$(hostname -s)
CON1=$(echo "${CONSOLE1}" | cut -d" " -f2)
TYPE1=$(echo "${CONSOLE1}" | cut -d" " -f3)
NODE1=$(echo "${CONSOLE1}" | cut -d" " -f4)
LOC1=$(echo "${CONSOLE1}" | cut -d" " -f5-8)

sed -i "{
/^Hostname/ s#.*#Hostname    : ${HOST1}#
/^Console/ s#.*#Console     : ${CON1}#
/^Function/ s#.*#Function    : Production - ${TYPE1} Node - ${NODE1}#
/^Service     :/ s#.*#Service     : Silver#
/^Service Hrs :/ s#.*#Service Hrs : 8 x 5#
/^Location    :/ s#.*#Location    : ${LOC1}#
}" /root/.message


