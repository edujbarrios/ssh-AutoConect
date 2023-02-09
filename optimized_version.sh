#!/bin/bash

declare -A servers

function add_server {
  read -p "Introduce el nombre del servidor: " name
  read -p "Introduce la IP del servidor: " ip
  read -p "Introduce la contraseña del servidor: " password
  servers[$name]=$ip:$password
  echo "Servidor añadido con éxito!"
}

function connect_server {
  if [ ${#servers[@]} -eq 0 ]; then
    echo "No hay servidores guardados. Por favor agregue uno primero."
    return
  fi

  echo "Servidores guardados:"
  for i in "${!servers[@]}"; do
    echo "$i"
  done

  read -p "Selecciona el nombre del servidor al que deseas conectarte: " server_name
  read -p "Introduce el nombre de usuario: " username

  server_info=(${servers[$server_name]})
  ip=${server_info[0]}
  password=${server_info[1]}

  sshpass -p "$password" ssh "$username@$ip"
}

function main_menu {
  echo "Menú principal"
  echo "1. Añadir servidor"
  echo "2. Conectar a un servidor"
  echo "3. Salir"

  read -p "Selecciona una opción: " option

  case $option in
    1) add_server;;
    2) connect_server;;
    3) exit 0;;
    *) echo "Opción inválida, por favor selecciona 1, 2 o 3.";;
  esac
}

while true; do
  main_menu
done
