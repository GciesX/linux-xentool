#!/bin/bash
ipv4=$(xenstore-read vm-data/ipv4)
if [ $ipv4 ] # check if ipv4 exist
then
        submark=$(xenstore-read vm-data/submark)
        sed -i -r "s@(address )[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}@address $ipv4/$submark@" /etc/network/interfaces # replace ipv4 

        gateway=$(xenstore-read vm-data/gateway)
        sed -i -r "s@(gateway )[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}@gateway $gateway@" /etc/network/interfaces # replace gateway

        systemctl restart networking # restart network
fi

pwd=$(xenstore-read vm-data/xpwd)
if [ $pwd ] # check if xpwd exist
then
        echo -e "$pwd\n$pwd" | passwd drite # change password
        echo -e "$pwd\n$pwd" | passwd root # change password
        xenstore-rm vm-data/xpwd # remove data from xen variable
fi