#!/usr/bin/env bash
# Consulta la memoria RAM libre y el espacio de swap en uso.

# TODO: implementar.
# Requisitos del enunciado:
#   - Memoria libre en bytes y porcentaje.
#   - Swap en uso en bytes y porcentaje.
# Sugerencias:
#   - free -b  (valores en bytes). Fila "Mem:" -> $2 total, $4 libre (o $7 disponible)
#                                  Fila "Swap:" -> $2 total, $3 usado
#   - Calcular porcentajes con awk:  awk '/^Mem:/ {printf "%.2f", $4*100/$2}'
#   - Si no hay swap configurada (total 0), evitar la division por cero.
get_system_memory() {
    print_warning "Funcionalidad en desarrollo..."
}
