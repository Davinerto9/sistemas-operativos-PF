# Realiza copias de seguridad de un directorio hacia una memoria USB
# y genera el catalogo de archivos (nombre y fecha de ultima modificacion).

# Devuelve las unidades conectadas por USB que tienen letra asignada.
# Incluye memorias USB (Removable) y discos externos, que Windows reporta como "Fixed".
function Get-UsbDrives {

    $drives = @()

    # 1. Volumenes de los discos conectados por bus USB (memorias y discos externos)
    $usbDisks = @(Get-Disk -ErrorAction SilentlyContinue | Where-Object { $_.BusType -eq "USB" })

    foreach ($disk in $usbDisks) {
        $drives += @(Get-Partition -DiskNumber $disk.Number -ErrorAction SilentlyContinue |
            Where-Object { "$($_.DriveLetter)" -match "^[A-Za-z]$" } |
            Get-Volume -ErrorAction SilentlyContinue)
    }

    # 2. Unidades marcadas como extraibles (por si el disco no reporta BusType USB)
    $drives += @(Get-Volume -ErrorAction SilentlyContinue |
        Where-Object { $_.DriveType -eq "Removable" })

    # 3. Alternativa con CIM por si los comandos anteriores no reportan nada
    if ($drives.Count -eq 0) {
        $drives = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 2" -ErrorAction SilentlyContinue |
            ForEach-Object {
                [PSCustomObject]@{
                    DriveLetter     = $_.DeviceID.TrimEnd(":")
                    FileSystemLabel = $_.VolumeName
                    Size            = $_.Size
                    SizeRemaining   = $_.FreeSpace
                }
            })
    }

    # Solo unidades con letra y con medio insertado, sin repetir
    $drives |
        Where-Object { "$($_.DriveLetter)" -match "^[A-Za-z]$" -and $_.Size -gt 0 } |
        Sort-Object -Property DriveLetter -Unique
}

function Invoke-Backup {

    try {
        # SELECCIONAR LA MEMORIA USB

        $usbDrives = @(Get-UsbDrives)

        if ($usbDrives.Count -eq 0) {
            Write-Host "`nNo se detecto ninguna memoria USB o disco externo conectado." -ForegroundColor Yellow
            Write-Host "Conecte una memoria USB e intente nuevamente." -ForegroundColor Yellow
            return
        }

        Write-Host "`n========== UNIDADES USB DETECTADAS ==========" -ForegroundColor Cyan

        for ($i = 0; $i -lt $usbDrives.Count; $i++) {
            $drive = $usbDrives[$i]
            $label = if ($drive.FileSystemLabel) { $drive.FileSystemLabel } else { "Sin etiqueta" }

            Write-Host ("{0}. {1}: [{2}]  Libre: {3} bytes ({4})" -f ($i + 1), $drive.DriveLetter, $label, $drive.SizeRemaining, (Format-Bytes $drive.SizeRemaining))
        }

        $choice = Read-MenuOption -Prompt "`nSeleccione la unidad USB de destino (0 para cancelar)" -Max $usbDrives.Count

        if ($choice -eq 0) {
            Write-Host "`nBackup cancelado." -ForegroundColor Yellow
            return
        }

        $usb = $usbDrives[$choice - 1]
        $usbRoot = "$($usb.DriveLetter):\"

        # SELECCIONAR EL DIRECTORIO A RESPALDAR

        $sourceInput = (Read-Host "`nIngrese la ruta del directorio a respaldar").Trim().Trim('"')

        if (-not $sourceInput -or -not (Test-Path -LiteralPath $sourceInput -PathType Container)) {
            Write-Host "`nLa ruta especificada no existe o no es un directorio." -ForegroundColor Red
            return
        }

        $source = (Get-Item -LiteralPath $sourceInput -Force).FullName

        # Evitar respaldar la misma memoria USB sobre si misma
        if ($source.StartsWith($usbRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Write-Host "`nEl directorio a respaldar no puede estar dentro de la memoria USB de destino." -ForegroundColor Red
            return
        }

        # VERIFICAR ESPACIO DISPONIBLE

        Write-Host "`nCalculando el tamano del directorio..." -ForegroundColor Yellow

        $files = @(Get-ChildItem -LiteralPath $source -File -Recurse -Force -ErrorAction SilentlyContinue)
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum

        if ($null -eq $totalSize) {
            $totalSize = 0
        }

        Write-Host "Archivos encontrados: $($files.Count)"
        Write-Host "Tamano total:         $totalSize bytes ($(Format-Bytes $totalSize))"

        if ($totalSize -gt $usb.SizeRemaining) {
            Write-Host "`nNo hay espacio suficiente en la memoria USB." -ForegroundColor Red
            Write-Host "Espacio libre: $($usb.SizeRemaining) bytes - Se requieren: $totalSize bytes" -ForegroundColor Red
            return
        }

        # CREAR LA CARPETA DEL BACKUP EN LA USB
        # Estructura: <USB>:\Backups\<Directorio>_<fecha>\archivos\  y  catalogo.csv

        $folderName = Split-Path $source -Leaf

        if (-not $folderName -or $folderName -match ":") {
            $folderName = "Unidad_$($source.Substring(0, 1))"
        }

        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupDir = Join-Path $usbRoot ("Backups\{0}_{1}" -f $folderName, $timestamp)
        $dataDir = Join-Path $backupDir "archivos"

        New-Item -ItemType Directory -Path $dataDir -Force -ErrorAction Stop | Out-Null

        # COPIAR LOS ARCHIVOS

        Write-Host "`nCopiando archivos a $dataDir ..." -ForegroundColor Yellow

        Get-ChildItem -LiteralPath $source -Force -ErrorAction SilentlyContinue |
            Copy-Item -Destination $dataDir -Recurse -Force -ErrorAction SilentlyContinue -ErrorVariable copyErrors

        # GENERAR EL CATALOGO (nombre y fecha de ultima modificacion)

        $catalogPath = Join-Path $backupDir "catalogo.csv"
        $prefixLength = $source.TrimEnd("\").Length + 1

        if ($files.Count -gt 0) {
            $files |
                Sort-Object -Property FullName |
                Select-Object `
                    @{Name = "Nombre"; Expression = { $_.Name }},
                    @{Name = "Ultima modificacion"; Expression = { $_.LastWriteTime.ToString("dd/MM/yyyy HH:mm:ss") }},
                    @{Name = "Tamano (bytes)"; Expression = { $_.Length }},
                    @{Name = "Ruta en el backup"; Expression = { $_.FullName.Substring($prefixLength) }} |
                Export-Csv -LiteralPath $catalogPath -NoTypeInformation -Encoding UTF8 -Delimiter ";"
        }
        else {
            Set-Content -LiteralPath $catalogPath -Value '"Nombre";"Ultima modificacion";"Tamano (bytes)";"Ruta en el backup"' -Encoding UTF8
        }

        # VERIFICAR Y MOSTRAR RESULTADOS

        $copiedCount = @(Get-ChildItem -LiteralPath $dataDir -File -Recurse -Force -ErrorAction SilentlyContinue).Count

        Write-Host "`n========== BACKUP FINALIZADO ==========" -ForegroundColor Cyan
        Write-Host "Origen:            $source"
        Write-Host "Destino:           $backupDir"
        Write-Host "Archivos copiados: $copiedCount de $($files.Count)"
        Write-Host "Catalogo:          $catalogPath"

        $copyErrors = @($copyErrors)

        if ($copyErrors.Count -gt 0 -or $copiedCount -lt $files.Count) {
            Write-Host "`nAlgunos archivos no se pudieron copiar (pueden estar en uso o sin permisos)." -ForegroundColor Yellow

            foreach ($err in $copyErrors | Select-Object -First 5) {
                Write-Host " - $($err.Exception.Message)" -ForegroundColor Yellow
            }

            Write-Log -Level "WARN" -Message "Backup incompleto de '$source' a '$backupDir': $copiedCount de $($files.Count) archivos"
        }
        else {
            Write-Host "`nBackup realizado correctamente." -ForegroundColor Green
            Write-Log -Message "Backup de '$source' a '$backupDir': $copiedCount archivos, $totalSize bytes"
        }
    }
    catch {
        Write-Host "`nError al realizar el backup: $($_.Exception.Message)" -ForegroundColor Red
        Write-Log -Level "ERROR" -Message "Error en backup: $($_.Exception.Message)"
    }
}
