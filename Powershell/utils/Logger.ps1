# Registra las operaciones y los errores del programa.

# Archivo de log: Powershell/logs/datacenter.log
$script:LogFile = Join-Path (Split-Path $PSScriptRoot -Parent) "logs\datacenter.log"

function Write-Log {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    try {
        $logDir = Split-Path $script:LogFile -Parent

        if (-not (Test-Path -LiteralPath $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }

        $line = "{0} [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
        Add-Content -LiteralPath $script:LogFile -Value $line -Encoding UTF8
    }
    catch {
        # Si el log falla no se interrumpe la ejecucion del programa
    }
}
