#!/usr/bin/env bash
# Contiene funciones auxiliares reutilizables.

# Colores para la terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Limpia la pantalla (sin fallar si no hay terminal)
clear_screen() {
    clear 2>/dev/null || true
}

# Espera a que el usuario presione ENTER
pause() {
    read -rp $'\nPresione ENTER para continuar'
}

# Imprime un titulo de seccion
print_title() {
    echo -e "\n${CYAN}========== $1 ==========${RESET}\n"
}

print_error() {
    echo -e "\n${RED}$1${RESET}"
}

print_warning() {
    echo -e "\n${YELLOW}$1${RESET}"
}

print_success() {
    echo -e "\n${GREEN}$1${RESET}"
}

# Verifica si un comando existe en el sistema
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Convierte bytes a un formato legible (KiB, MiB, GiB...)
format_bytes() {
    if command_exists numfmt; then
        numfmt --to=iec-i --suffix=B --format="%.2f" "$1" 2>/dev/null || echo "$1 bytes"
    else
        echo "$1 bytes"
    fi
}
