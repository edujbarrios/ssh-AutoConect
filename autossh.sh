#!/bin/bash

# Array para almacenar la información de los servidores
declare -A servers

# Contador para el número de servidores
count=0

# Función para conectarse a un servidor
function connect_server {
  # Pide al usuario que elija un servidor
  echo "Seleccione un servidor para conectarse:"
  select server in "${!servers[@]}"; do
    # Verifica si la opción elegida es válida
    if [[ -n $server ]]; then
      # Separa la información del servidor en variables individuales
      server_info=(${servers[$server]})
      server_name=${server_info[0]}
      server_ip=${server_info[1]}
      server_password=${server_info[2]}
      
      # Conectarse al servidor usando sshpass
      sshpass -p "$server_password" ssh "$username@$server_ip"
      break
    else
      echo "Opción inválida, por favor intente de nuevo"
    fi
  done
}

# Menú principal
while true; do
  echo "Menú Principal"
  echo "1. Agregar servidor"
  echo "2. Conectar a un servidor"
  echo "3. Salir"
  read -p "Seleccione una opción: " option

  case $option in
    1)
      # Pide la información del servidor al usuario
      read -p "Nombre del servidor: " server_name
      read -p "Dirección IP del servidor: " server_ip
      read -sp "Contraseña del servidor: " server_password
      echo

      # Aumenta el contador de servidores y agrega la información al array
      count=$((count + 1))
      servers[$count]="$server_name $server_ip $server_password"
      ;;
    2)
      # Verifica si se han agregado servidores
      if [[ $count -eq 0 ]]; then
        echo "No se han agregado servidores, por favor agregue uno primero"
      else
        connect_server
      fi
      ;;
    3)
      # Salir del script
      break
      ;;
    *)
      echo "Opción inválida, por favor intente de nuevo"
      ;;
  esac
done
