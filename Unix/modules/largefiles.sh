#!/usr/bin/env bash
# Busca los diez archivos mas grandes dentro de un disco o filesystem especificado.

# TODO: implementar.
# Requisitos del enunciado:
#   - Recibe la ruta del disco o filesystem como parametro ($1).
#   - Muestra nombre, tamano (bytes) y trayectoria completa de los 10 archivos mas grandes.
# Sugerencias:
#   - Validar que la ruta exista y sea un directorio:  [[ -d "$1" ]]
#   - find "$1" -xdev -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -n 10
#     (-xdev evita salirse del filesystem elegido)
#   - Para el nombre del archivo: basename "$ruta"
#   - Usar print_title / print_error (utils/helpers.sh) y log_msg (utils/logger.sh)
get_largest_files() {
    print_warning "Funcionalidad en desarrollo..."
}
