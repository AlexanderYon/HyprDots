#!/usr/bin/env bash

#notify-send "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(echo $(nmcli -fields WIFI g | awk 'NR==2'))

if [[ "$connected" = "activado" ]]; then
	toggle="󰖪  Disable Wi-Fi"

elif [[ "$connected" = "desactivado" ]]; then
	toggle="󰖩  Enable Wi-Fi"

fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | wofi --dmenu -i --selected-row 1 -p "Wi-Fi SSID: ")

# Get name of connection
read -r chosen_id <<<"${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	#saved_connections=$(nmcli -g NAME connection)
	saved_connections=$(echo $(nmcli -g NAME connection | awk 'NR==1'))
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(wofi --dmenu -p "Password: ")
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
