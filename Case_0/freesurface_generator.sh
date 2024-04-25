#!/bin/bash

# Nombre del archivo CSV de salida
output_file="freesurface.csv"
touch "$output_file"

# Obtener la lista de carpetas *.* en la carpeta y ordenarlas numéricamente
folders=$(find ./postProcessing/freeSurface -mindepth 1 -maxdepth 1 -type d -name "*" | sort -n)

# Recorrer cada carpeta
for folder in $folders; do
	# Obtener la lista de archivos *099 dentro de cada carpeta
	files=$(ls "$folder"/*099*)

	# Crear la columna para la carpeta actual
	echo -n "" >>"$output_file"

	# Crear las filas con los valores de la segunda columna "y" para la carpeta actual
	for file in $files; do
		# Extraer los valores de la columna "y" y agregarlos al archivo CSV
		awk 'NR > 2 {print $2}' "$file" | paste -sd "," >>"$output_file"
	done
done
