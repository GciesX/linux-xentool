#!/bin/bash
ipv4=$(xenstore-read vm-data/ipv4)
if [ $ipv4 ] # check if ipv4 exist
then
        submark=$(xenstore-read vm-data/submark)
        sed -i -r "s@(- )[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}@- $ipv4/$submark@" /etc/netplan/00-installer-config.yaml # replace ipv4

        gateway=$(xenstore-read vm-data/gateway)
        sed -i -r "s@(gateway4: )[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}@gateway4: $gateway@" /etc/netplan/00-installer-config.yaml # replace gateway

        netplan apply #apply network config
fi

pwd=$(xenstore-read vm-data/xpwd)
if [ $pwd ] # check if xpwd exist 
then
        echo -e "$pwd\n$pwd" | passwd drite # change password
        xenstore-rm vm-data/xpwd # remove data from xen variable
fi