# Gestiona la interacción con el usuario y la navegación del menú.

function Show-MainMenu {

    Clear-Host

    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "             DATA CENTER MANAGER            " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan

    Write-Host "1. Consultar usuarios del sistema"
    Write-Host "2. Consultar discos y filesystems"
    Write-Host "3. Consultar archivos mas grandes"
    Write-Host "4. Consultar memoria RAM y SWAP"
    Write-Host "5. Realizar backup"
    Write-Host "0. Salir"

    Write-Host "============================================" -ForegroundColor Cyan
}