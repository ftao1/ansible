!/bin/bash

# Script bond.sh to set up bond0 and bond1 on target machines in nodes.
# FT v0.2 16/04/20
# Assumptions: This uses the onboard NICs eno1 and eno2 for bond0


cd /etc/sysconfig/network-scripts/
IPS=$(egrep "IPADDR|NETMASK|GATEWAY" ifcfg-eno1)

echo 'NAME="bond0"
DEVICE="bond0"
ONBOOT=yes
NETBOOT=no
IPV6INIT=no
BOOTPROTO=none
NOZEROCONF=yes
'"${IPS}"'
BONDING_OPTS="mode=1 miimon=100"' > ifcfg-bond0

sed -i.bak "{
/IPADDR/d
/NETMASK/d
/GATEWAY/d
}" ifcfg-eno1

sed -i.bak "{
/PROXY_METHOD/d
/BROWSER_ONLY/d
/DEFROUTE/d
/IPV4_FAILURE_FATAL/d
/IPV6_AUTOCONF/d
/IPV6_DEFROUTE/d
/IPV6_FAILURE_FATAL/d
/IPV6_ADDR_GEN_MODE/d
/ONBOOT/ s/no/yes/
/IPV6INIT/ s/yes/no/
/BOOTPROTO/ s/dhcp/none/
}" ifcfg-eno2

echo "SLAVE=yes
MASTER=bond0" | tee -a ifcfg-eno1 ifcfg-eno2

cp ifcfg-bond0 ifcfg-bond1

IPS2=$(grep $(hostname -s) <<\EOF | awk '{print $2}'
serve1 192.168.0.178
serve2 192.168.0.179
serve3 192.168.0.180
serve4 192.168.0.181
serve5 192.168.0.182
serve6 192.168.0.183
EOF
)

sed -i.bak "{
s/bond0/bond1/
/GATEWAY/d
/IPADDR/ s/.*/IPADDR=\"${IPS2}\"/
}" ifcfg-bond1


sed -i.bak "{
/PROXY_METHOD/d
/BROWSER_ONLY/d
/DEFROUTE/d
/IPV4_FAILURE_FATAL/d
/IPV6_AUTOCONF/d
/IPV6_DEFROUTE/d
/IPV6_FAILURE_FATAL/d
/IPV6_ADDR_GEN_MODE/d
/ONBOOT/ s/no/yes/
/IPV6INIT/ s/yes/no/
/BOOTPROTO/ s/dhcp/none/
}" ifcfg-ens3f0 ifcfg-ens3f1

echo "SLAVE=yes
MASTER=bond1" | tee -a ifcfg-ens3f0 ifcfg-ens3f1

/usr/sbin/service network restart
