#!/bin/bash

# Verificar si Waybar está corriendo
if pgrep -x "waybar" > /dev/null
then
    # Si está corriendo, lo matamos
    pkill -x "waybar"
else
    # Si no está corriendo, lo lanzamos
    waybar &
fi

