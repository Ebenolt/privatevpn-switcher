#!/bin/bash


if [[ $EUID -ne 0 ]]; then
        printf "\e[33m /!\ This script must be run with sudo /!\ \e[0m\n"
        exit 1
fi

clear

username=$(who am i | awk '{print $1}')
working_dir=$(pwd)

read -p " -First VPN IP: " vpn1
read -p " -Failover VPN IP: " vpn2

printf "Configuring script: "
sed -i "s/#vpn1#/$vpn1/g" vpn-switcher.sh
sed -i "s/#vpn2#/$vpn2/g" vpn-switcher.sh
printf "\e[32mOK\e[0m\n"

printf "Configuring cron: "
echo "* * * * * $working_dir/vpn-switcher.sh" >> "/var/spool/cron/crontabs/$username"
printf "\e[32mOK\e[0m\n\n"




