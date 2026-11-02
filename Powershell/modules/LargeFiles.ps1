# Busca los diez archivos más grandes dentro de una unidad especificada.

function Get-LargestFiles {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    try {
        # Validar que la ruta exista
        if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
            Write-Host "`nLa ruta especificada no existe o no es valida." -ForegroundColor Red
            return
        }

        # Obtener archivos del filesystem recursivamente
        Write-Host "`nBuscando archivos... Esto puede tardar dependiendo del tamano del disco." -ForegroundColor Yellow

        $files = Get-ChildItem -LiteralPath $Path `
            -File `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        if (-not $files) {
            Write-Host "`nNo se encontraron archivos en la ruta especificada." -ForegroundColor Yellow
            return
        }

        # Ordenar archivos por tamano y seleccionar los diez mayores
        $largestFiles = $files |
            Sort-Object -Property Length -Descending |
            Select-Object -First 10

        # Organizar informacion
        $fileList = $largestFiles | Select-Object `
            @{Name = "Nombre"; Expression = { $_.Name }},
            @{Name = "Tamano (bytes)"; Expression = { $_.Length }},
            @{Name = "Trayectoria completa"; Expression = { $_.FullName }}

        # Mostrar resultados
        Write-Host "`n========== DIEZ ARCHIVOS MAS GRANDES ==========" -ForegroundColor Cyan

        $fileList | Format-Table -AutoSize -Wrap

        Write-Host "`nArchivos encontrados: $($files.Count)" -ForegroundColor Green
        Write-Host "Archivos mostrados: $($largestFiles.Count)" -ForegroundColor Green

    }
    catch {
        Write-Host "`nError al buscar archivos: $($_.Exception.Message)" -ForegroundColor Red
    }
}