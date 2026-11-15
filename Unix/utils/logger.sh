#!/usr/bin/env bash
# Registra las operaciones y los errores del programa.

# Archivo de log: Unix/logs/datacenter.log
LOG_DIR="${SCRIPT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}/logs"
LOG_FILE="$LOG_DIR/datacenter.log"

# Uso: log_msg NIVEL "mensaje"   (NIVEL: INFO, WARN o ERROR)
log_msg() {
    local level="$1"
    shift

    mkdir -p "$LOG_DIR" 2>/dev/null &&
        printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >> "$LOG_FILE" 2>/dev/null

    # Si el log falla no se interrumpe la ejecucion del programa
    return 0
}
