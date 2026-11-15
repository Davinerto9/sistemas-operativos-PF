#!/usr/bin/env bash
# Gestiona la interaccion con el usuario y la navegacion del menu.

show_main_menu() {

    clear_screen

    echo -e "${CYAN}============================================${RESET}"
    echo -e "${CYAN}             DATA CENTER MANAGER            ${RESET}"
    echo -e "${CYAN}============================================${RESET}"

    echo "1. Consultar usuarios del sistema"
    echo "2. Consultar discos y filesystems"
    echo "3. Consultar archivos mas grandes"
    echo "4. Consultar memoria RAM y SWAP"
    echo "5. Realizar backup"
    echo "0. Salir"

    echo -e "${CYAN}============================================${RESET}"
}
