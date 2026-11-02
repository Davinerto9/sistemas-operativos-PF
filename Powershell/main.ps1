# Punto de entrada. Importa los módulos y ejecuta el menú principal.
. "$PSScriptRoot/modules/Users.ps1"
. "$PSScriptRoot/utils/Menu.ps1"

do {

    Show-MainMenu

    $option = Read-Host "`nSeleccione una opcion"

    switch ($option) {

        "1" {
            Clear-Host
            Get-SystemUsers
        }

        "2" {
            Write-Host "`nFuncionalidad en desarrollo..." -ForegroundColor Yellow
        }

        "3" {
            Write-Host "`nFuncionalidad en desarrollo..." -ForegroundColor Yellow
        }

        "4" {
            Write-Host "`nFuncionalidad en desarrollo..." -ForegroundColor Yellow
        }

        "5" {
            Write-Host "`nFuncionalidad en desarrollo..." -ForegroundColor Yellow
        }

        "0" {
            Write-Host "`nCerrando Data Center Manager..." -ForegroundColor Green
        }

        default {
            Write-Host "`nOpcion no valida." -ForegroundColor Red
        }
    }

    if ($option -ne "0") {
        Read-Host "`nPresione ENTER para continuar"
    }

} while ($option -ne "0")