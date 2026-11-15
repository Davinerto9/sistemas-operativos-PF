#!/usr/bin/env bash
# Obtiene los discos y filesystems conectados, su tamano y espacio libre.

get_system_disks() {

    local output

    # -B1 muestra los valores en bytes. Se excluyen filesystems virtuales en memoria.
    output=$(df -B1 --output=source,fstype,size,avail,target \
        -x tmpfs -x devtmpfs -x squashfs -x efivarfs 2>/dev/null)

    if [[ -z "$output" ]]; then
        print_warning "No se encontraron discos o filesystems."
        return
    fi

    print_title "DISCOS Y FILESYSTEMS"

    echo "$output" | awk '
        NR == 1 {
            printf "%-25s %-10s %20s %22s  %s\n", "Filesystem", "Tipo", "Tamano (bytes)", "Espacio libre (bytes)", "Montado en"
            printf "%-25s %-10s %20s %22s  %s\n", "----------", "----", "--------------", "---------------------", "----------"
            next
        }
        {
            # El punto de montaje puede contener espacios
            target = $5
            for (i = 6; i <= NF; i++) target = target " " $i

            printf "%-25s %-10s %20s %22s  %s\n", $1, $2, $3, $4, target
            total++
        }
        END {
            printf "\nTotal de filesystems encontrados: %d\n", total
        }'
}
