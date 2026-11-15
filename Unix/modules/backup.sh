#!/usr/bin/env bash
# Realiza copias de seguridad de un directorio hacia una memoria USB
# y genera el catalogo de archivos (nombre y fecha de ultima modificacion).

# TODO: implementar (seguir la misma logica que Powershell/modules/Backup.ps1).
# Requisitos del enunciado:
#   - Copiar un directorio especificado a una memoria USB.
#   - Guardar tambien un catalogo con el nombre de cada archivo y su fecha de ultima modificacion.
# Sugerencias:
#   - Detectar memorias USB montadas:
#       lsblk -rno NAME,TRAN,MOUNTPOINT     (TRAN = usb)
#       o listar /media/$USER/* y /run/media/$USER/*
#   - Mostrar las USB encontradas y pedir al usuario que elija una (0 para cancelar).
#   - Validar el directorio origen con [[ -d "$origen" ]].
#   - Verificar espacio: du -sb "$origen"  vs  df -B1 --output=avail "$usb"
#   - Destino: "$usb/Backups/<nombre>_$(date +%Y%m%d_%H%M%S)/archivos"
#   - Copiar: cp -a "$origen"/. "$destino/archivos"/
#   - Catalogo (catalogo.csv en la carpeta del backup):
#       echo "Nombre;Ultima modificacion;Tamano (bytes);Ruta en el backup" > catalogo.csv
#       find "$origen" -type f -printf '%f;%TY-%Tm-%Td %TH:%TM:%.2TS;%s;%P\n' >> catalogo.csv
#   - Mostrar resumen (archivos copiados, ruta del backup) y registrar con log_msg.
run_backup() {
    print_warning "Funcionalidad en desarrollo..."
}
