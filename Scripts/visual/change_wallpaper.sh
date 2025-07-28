#!/bin/bash

loaded_wallpapers=$(hyprctl hyprpaper listloaded) # List loaded wallpapers dirs
current_active=$(hyprctl hyprpaper listactive | awk '{print $3}')

# Convertir la lista de fondos en un array para poder manejar la posición
wallpapers_array=($loaded_wallpapers)

# Iterar sobre cada fondo de la lista de fondos
for i in "${!wallpapers_array[@]}"; do
    image="${wallpapers_array[$i]}"
    
    # Si la imagen actual es igual a la imagen activa
    if [ "$image" = "$current_active" ]; then
        # Determinar la siguiente imagen (cíclicamente)
        next_index=$(( (i + 1) % ${#wallpapers_array[@]} ))
        next_image="${wallpapers_array[$next_index]}"
        
        # Cambiar al siguiente fondo de pantalla
        hyprctl hyprpaper wallpaper ", $next_image"

	# Actualizar la ruta para el fondo de pantalla de Hyprlock
	sed -i "0,/path = .*/s|path = .*|path = $next_image   # This line was changed by ~/Scripts/visual/change_wallpaper.sh|" ~/.config/hypr/hyprlock.conf

        break  # Salir del bucle después de cambiar el fondo
    fi
done




