#!/bin/bash
ipv4=$(xenstore-read vm-data/ipv4)
if [ $ipv4 ] # check if ipv4 exist
then
        submark=$(xenstore-read vm-data/submark)
        nmcli connection modify eth0 IPv4.address $ipv4/$submark # set ipv4

        gateway=$(xenstore-read vm-data/gateway)
        nmcli connection modify eth0 IPv4.gateway $gateway # set gateway

        nmcli connection modify eth0 IPv4.dns 1.1.1.1 # set dns

        nmcli connection modify eth0 IPv4.method manual # set interface to static

        nmcli connection down eth0 && nmcli connection up eth0 # turn interface down & up
fi

pwd=$(xenstore-read vm-data/xpwd)
if [ $pwd ] # check if xpwd exist
then
        echo -e "$pwd\n$pwd" | passwd drite # change password
        echo -e "$pwd\n$pwd" | passwd root # change password
        xenstore-rm vm-data/xpwd # remove data from xen variable
fi