#!/bin/bash
#Miguel Rosas

# Leer valores desde el archivo parametros.txt
n=$(grep -oP 'n\s*=\s*\K[\d.+-]+' parameters.txt)

# Obtiene la cantidad desde el primer argumento
cantidad=1

# Bucle para crear y mover carpetas, editar y genrar mallado
for ((i = 1; i <= $cantidad; i++)); do
  # Genera el nombre de la carpeta
  nombre_carpeta="Case_$i"

  # Crea la carpeta del caso
  mkdir "$nombre_carpeta"

  # Copia carpetas del caso dentro de las carpetasgeneradas
  cp -r "Case_0/0/" "$nombre_carpeta/"
  cp -r "Case_0/0.orig/" "$nombre_carpeta/"
  cp -r "Case_0/constant/" "$nombre_carpeta/"
  cp -r "Case_0/system/" "$nombre_carpeta/"
  cp "Case_0/extract_freesurface_plane.py" "$nombre_carpeta/"
  cp "Case_0/extract_freesurface.sh" "$nombre_carpeta/"
  cp "Case_0/extractor.py" "$nombre_carpeta/"

  ddir=$(pwd)
  sed -i "s|\$ddir|$ddir|g" "./$nombre_carpeta/extract_freesurface_plane.py"

  # Realiza el intercambio en el archivo
  valor_a="${valores_a[i - 1]}"
  sed -i "s/\$i/$i/g" "$nombre_carpeta/extract_freesurface_plane.py"
  sed -i "s/\$i/$i/g" "$nombre_carpeta/extractor.py"
  sed -i "s/\$nn/$n/g" "$nombre_carpeta/constant/porosityProperties"
  sed -i "s/\$nn/$n/g" "$nombre_carpeta/system/setFieldsDict"

  cd "$nombre_carpeta/"

  blockMesh
  setFields
  decomposePar
  mpirun -np 6 interIsoFoam -parallel >log
  kitty --hold -e bash -c "./extract_freesurface.sh && python3 extractor.py && rm -r ./proce*; exec bash" &
  cd ..
done

echo "Proceso completado."
