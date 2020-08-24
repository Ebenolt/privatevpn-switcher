#!/bin/bash

current_vpn=$(cat /etc/openvpn/privatvpn.conf | head -1 | awk '{print $2}')

vpn1="#vpn1#"
vpn2="#vpn2#"

currvpn_up=$(ping $current_vpn -c 1 -W 5| tail -2 | head -1 | awk '{print $4}')


if [ "$currvpn_up" != "1" ]
then
	echo "" | tee -a vpn_switch.log
	echo "$(date) $current_vpn not up" | tee -a vpn_switch.log
	if [ "$current_vpn" == "$vpn1" ]
	then
		echo "$(date) Switching to $vpn2" | tee -a vpn_switch.log
		sed -i "s/$current_vpn/$vpn2/g" /etc/openvpn/privatvpn.conf
		sed -i "s/$current_vpn/$vpn2/g" /etc/ufw/user.rules
	else
		echo "$(date) Switching to $vpn1" | tee -a vpn_switch.log
		sed -i "s/$current_vpn/$vpn1/g" /etc/openvpn/privatvpn.conf
		sed -i "s/$current_vpn/$vpn1/g" /etc/ufw/user.rules
	fi
	systemctl restart ufw.service privatevpn.service
fi




