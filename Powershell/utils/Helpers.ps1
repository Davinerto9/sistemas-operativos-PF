# Contiene funciones auxiliares reutilizables.

# Convierte una cantidad de bytes a un texto legible (KB, MB, GB, TB)
function Format-Bytes {

    param(
        [double]$Bytes
    )

    $units = @("bytes", "KB", "MB", "GB", "TB")
    $index = 0

    while ($Bytes -ge 1024 -and $index -lt ($units.Count - 1)) {
        $Bytes = $Bytes / 1024
        $index++
    }

    return "{0:N2} {1}" -f $Bytes, $units[$index]
}

# Pide un numero entre 0 y Max hasta que el usuario ingrese un valor valido
function Read-MenuOption {

    param(
        [string]$Prompt,
        [int]$Max
    )

    while ($true) {
        $answer = Read-Host $Prompt
        $number = 0

        if ([int]::TryParse($answer, [ref]$number) -and $number -ge 0 -and $number -le $Max) {
            return $number
        }

        Write-Host "Opcion no valida. Ingrese un numero entre 0 y $Max." -ForegroundColor Red
    }
}
