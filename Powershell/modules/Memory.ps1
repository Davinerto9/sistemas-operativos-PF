# Consulta la memoria RAM disponible y el espacio de paginación utilizado.

function Get-SystemMemory {

    try {
        # CONSULTAR MEMORIA RAM

        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

        # Los valores de Win32_OperatingSystem estan en KB
        $totalMemory = [double]$os.TotalVisibleMemorySize * 1KB
        $freeMemory = [double]$os.FreePhysicalMemory * 1KB

        # Calcular porcentaje de memoria libre
        $freeMemoryPercentage = if ($totalMemory -gt 0) {
            ($freeMemory / $totalMemory) * 100
        }
        else {
            0
        }

        # CONSULTAR ESPACIO SWAP (PAGEFILE)

        $pageFiles = @(Get-CimInstance Win32_PageFileUsage -ErrorAction Stop)

        # Los valores de Win32_PageFileUsage estan en MB
        $totalSwap = ($pageFiles | Measure-Object -Property AllocatedBaseSize -Sum).Sum
        $usedSwap = ($pageFiles | Measure-Object -Property CurrentUsage -Sum).Sum

        # Evitar valores nulos cuando no existen archivos de paginacion
        if ($null -eq $totalSwap) {
            $totalSwap = 0
        }

        if ($null -eq $usedSwap) {
            $usedSwap = 0
        }

        # Convertir MB a bytes
        $totalSwapBytes = [double]$totalSwap * 1MB
        $usedSwapBytes = [double]$usedSwap * 1MB

        # Calcular porcentaje de SWAP utilizado
        $usedSwapPercentage = if ($totalSwapBytes -gt 0) {
            ($usedSwapBytes / $totalSwapBytes) * 100
        }
        else {
            0
        }

        # MOSTRAR RESULTADOS

        Write-Host "`n========== MEMORY INFORMATION ==========" -ForegroundColor Cyan

        Write-Host "`nRAM" -ForegroundColor Yellow

        Write-Host "Memoria total:       $([math]::Round($totalMemory, 2)) bytes"
        Write-Host "Memoria libre:       $([math]::Round($freeMemory, 2)) bytes"
        Write-Host "Porcentaje libre:    $([math]::Round($freeMemoryPercentage, 2)) %"

        Write-Host "`nSWAP (PAGEFILE)" -ForegroundColor Yellow

        Write-Host "Espacio asignado:    $([math]::Round($totalSwapBytes, 2)) bytes"
        Write-Host "Espacio utilizado:   $([math]::Round($usedSwapBytes, 2)) bytes"
        Write-Host "Porcentaje utilizado: $([math]::Round($usedSwapPercentage, 2)) %"

        Write-Host "`n========================================" -ForegroundColor Cyan

    }
    catch {
        Write-Host "`nError al consultar la memoria: $($_.Exception.Message)" -ForegroundColor Red
    }
}