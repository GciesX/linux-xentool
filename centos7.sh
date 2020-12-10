#!/bin/bash
ipv4=$(xenstore-read vm-data/ipv4)
if [ $ipv4 ] # check if ipv4 exist
then
        sed -i -r 's@(IPADDR=)(\"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\")@IPADDR='\"$ipv4\"'@' /etc/sysconfig/network-scripts/ifcfg-eth0 # replace ipv4

        submark=$(xenstore-read vm-data/submark)
        sed -i -r 's@(PREFIX=)(\"[0-9]{1,2}\")@PREFIX='\"$submark\"'@' /etc/sysconfig/network-scripts/ifcfg-eth0 # replace submark

        gateway=$(xenstore-read vm-data/gateway)
        sed -i -r 's@(GATEWAY=)(\"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\")@GATEWAY='\"$gateway\"'@' /etc/sysconfig/network-scripts/ifcfg-eth0 # replace gateway

        systemctl restart network # restart network
fi

pwd=$(xenstore-read vm-data/xpwd)
if [ $pwd ] # check if xpwd exist
then
        echo -e "$pwd\n$pwd" | passwd drite # change password
        echo -e "$pwd\n$pwd" | passwd root # change password
        xenstore-rm vm-data/xpwd # remove data from xen variable
fi