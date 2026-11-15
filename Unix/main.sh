#!/usr/bin/env bash
# Punto de entrada. Importa los modulos y ejecuta el menu principal.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/utils/helpers.sh"
source "$SCRIPT_DIR/utils/logger.sh"
source "$SCRIPT_DIR/utils/menu.sh"

source "$SCRIPT_DIR/modules/users.sh"
source "$SCRIPT_DIR/modules/disks.sh"
source "$SCRIPT_DIR/modules/largefiles.sh"
source "$SCRIPT_DIR/modules/memory.sh"
source "$SCRIPT_DIR/modules/backup.sh"

log_msg INFO "Inicio de Data Center Manager"

while true; do

    show_main_menu

    read -rp $'\nSeleccione una opcion: ' option

    case "$option" in
        1)
            clear_screen
            get_system_users
            ;;
        2)
            clear_screen
            get_system_disks
            ;;
        3)
            clear_screen
            read -rp "Ingrese la ruta del disco o filesystem (Ejemplo: /home): " path
            get_largest_files "$path"
            ;;
        4)
            clear_screen
            get_system_memory
            ;;
        5)
            clear_screen
            run_backup
            ;;
        0)
            echo -e "\n${GREEN}Cerrando Data Center Manager...${RESET}"
            log_msg INFO "Cierre de Data Center Manager"
            break
            ;;
        *)
            echo -e "\n${RED}Opcion no valida.${RESET}"
            ;;
    esac

    pause

done
