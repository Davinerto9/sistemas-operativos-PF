#!/usr/bin/env bash
# Consulta los usuarios del sistema y su ultimo inicio de sesion.

# UID a partir del cual el sistema crea usuarios normales (normalmente 1000)
get_uid_min() {
    local uid_min
    uid_min=$(awk '/^UID_MIN/ {print $2}' /etc/login.defs 2>/dev/null)
    echo "${uid_min:-1000}"
}

# Convierte una fecha en texto al formato dd/mm/aaaa HH:MM:SS
format_login_date() {
    local formatted
    formatted=$(date -d "$1" '+%d/%m/%Y %H:%M:%S' 2>/dev/null)
    echo "${formatted:-$1}"
}

# Devuelve la fecha del ultimo login de un usuario.
# Se intenta con lastlog, lastlog2 (distros nuevas) y last (registro wtmp).
get_last_login() {
    local user="$1"
    local cmd line

    for cmd in lastlog lastlog2; do
        if command_exists "$cmd"; then
            line=$(LC_ALL=C "$cmd" -u "$user" 2>/dev/null </dev/null | tail -n +2)

            if [[ -n "$line" && "$line" != *"Never logged in"* ]]; then
                # Formato: usuario puerto origen  Dia Mes DD HH:MM:SS zona AAAA
                format_login_date "$(echo "$line" | awk '{print $(NF-4), $(NF-3), $NF, $(NF-2), $(NF-1)}')"
                return
            fi
        fi
    done

    if command_exists last; then
        line=$(LC_ALL=C last -F -R -n 1 "$user" 2>/dev/null </dev/null | head -n 1)

        if [[ "$(echo "$line" | awk '{print $1}')" == "$user" ]]; then
            # Formato: usuario terminal Dia Mes DD HH:MM:SS AAAA ...
            format_login_date "$(echo "$line" | awk '{print $4, $5, $7, $6}')"
            return
        fi
    fi

    echo "Nunca ha iniciado sesion"
}

get_system_users() {

    local uid_min count=0
    local user uid shell

    uid_min=$(get_uid_min)

    print_title "USUARIOS DEL SISTEMA"

    printf "%-24s %-8s %-25s %s\n" "Usuario" "UID" "Ultimo login" "Shell"
    printf "%-24s %-8s %-25s %s\n" "-------" "---" "------------" "-----"

    # Se muestran root y los usuarios creados (UID >= UID_MIN), sin incluir "nobody"
    while IFS=: read -r user _ uid _ _ _ shell; do

        if [[ "$uid" -eq 0 ]] || [[ "$uid" -ge "$uid_min" && "$uid" -ne 65534 ]]; then
            printf "%-24s %-8s %-25s %s\n" "$user" "$uid" "$(get_last_login "$user")" "$shell"
            count=$((count + 1))
        fi

    done < <(getent passwd 2>/dev/null || cat /etc/passwd)

    echo -e "\n${GREEN}Total de usuarios: $count${RESET}"
}
