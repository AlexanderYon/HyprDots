#!/bin/bash
# sleep 5

while true; do
  current_hour=$(date +%H)

  if [ "$current_hour" -ge 20 ] || [ "$current_hour" -le 7 ]; then
    gammastep -O 4000k
  fi

  if [ "$current_hour" -ge 7 ]; then
    gammastep -O 6500k
  fi

  sleep 60
done
