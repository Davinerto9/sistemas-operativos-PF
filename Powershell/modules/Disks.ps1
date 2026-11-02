# Obtiene los discos y filesystems conectados, su tamaño y espacio libre.

function Get-SystemDisks {

    try {
        # Obtener los volumenes disponibles en el sistema
        $volumes = Get-Volume -ErrorAction Stop |
            Where-Object {
                $_.DriveLetter -or $_.FileSystemLabel
            }

        if (-not $volumes) {
            Write-Host "`nNo se encontraron discos o filesystems." -ForegroundColor Yellow
            return
        }

        # Organizar informacion de los volumenes
        $diskList = $volumes | Select-Object `
            @{Name = "Unidad"; Expression = {
                if ($_.DriveLetter) {
                    "$($_.DriveLetter):"
                }
                else {
                    "Sin letra"
                }
            }},
            @{Name = "Etiqueta"; Expression = {
                if ($_.FileSystemLabel) {
                    $_.FileSystemLabel
                }
                else {
                    "Sin etiqueta"
                }
            }},
            @{Name = "Filesystem"; Expression = {
                if ($_.FileSystem) {
                    $_.FileSystem
                }
                else {
                    "Desconocido"
                }
            }},
            @{Name = "Tamano (bytes)"; Expression = {
                $_.Size
            }},
            @{Name = "Espacio libre (bytes)"; Expression = {
                $_.SizeRemaining
            }}

        # Mostrar resultados
        Write-Host "`n========== DISCOS Y FILESYSTEMS ==========" -ForegroundColor Cyan

        $diskList | Format-Table -AutoSize

        Write-Host "Total de volumenes encontrados: $($volumes.Count)" -ForegroundColor Green
    }
    catch {
        Write-Host "`nError al consultar los discos: $($_.Exception.Message)" -ForegroundColor Red
    }
}