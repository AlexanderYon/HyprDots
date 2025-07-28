



# Network access point
ssid=$(nmcli device show | awk 'NR==6' | awk '{print substr($0, index($0,$2))}')
# Wifi status (enabled/disabled)
wifi_status=$(echo $(nmcli -fields WIFI g | awk 'NR==2'))

if [[ "$wifi_status" = "desactivado" ]]; then
	echo "󱛅 " "Off"
else

	if [[ "$ssid" = "lo" ]]; then
		echo "󰖪 " 
		#echo "{\"text\": \"󰖪 \", \"tooltip\": No Connection}"
	else
		echo "  " "$ssid"
		#echo "{\"text\": \" \", \"tooltip\": \"$ssid\"}"
	fi
fi
