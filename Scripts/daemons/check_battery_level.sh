#!/bin/bash

low_notified=false 			# Flag to notify low battery
critical_notified=false		# Flag to notify critical battery

LOW=15
CRITICAL=5
HIBERNATE=3

while true; do

	bat_status=$(acpi -b | awk '{print $3}' | sed 's/[,%]//g') # Charging / Discharging / Full
	bat_level=$(acpi -b | awk '{print $4}' | sed 's/[,%]//g') # Integer
  
  #If the battery reaches a level under CRITICAL, then hibernate to save the current session until the next power on
  if [ "$bat_level" -eq "$HIBERNATE" ] && [ "$bat_status" = "Discharging" ]; then
    systemctl hibernate

	# Battery is LOW, so notify it at once
	elif [ "$bat_level" -eq "$LOW" ] && [ "$bat_status" = "Discharging" ] && [ $low_notified = false ]; then 
		dunstify -u critical "󰂃 Low Battery" "Connect to a power source"
		low_notified=true

  # Battery is CRITICAL, so notify it at once
	elif [ "$bat_level" -eq "$CRITICAL" ] && [ "$bat_status" = "Discharging" ] && [ $critical_notified = false ]; then
		dunstify -u critical "󰂃 Critical Battery" "Connect to a power source right now!!!"
		critical_notified=true
  
  # The battery is charging, so it is necessary to reset the flags to avoid unnecessary notifications
	elif [ "$bat_status" = "Charging" ]; then
		low_notified=false
		critical_notified=false
	fi

	sleep 15
done
