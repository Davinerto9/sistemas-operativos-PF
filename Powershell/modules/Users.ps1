# Consulta los usuarios del sistema y su último inicio de sesión.

function Get-SystemUsers {

    try {
        # Obtener usuarios locales del sistema
        $users = Get-LocalUser -ErrorAction Stop

        if (-not $users) {
            Write-Host "`nNo se encontraron usuarios en el sistema." -ForegroundColor Yellow
            return
        }

        # Organizar información
        $userList = $users | Select-Object `
            @{Name = "Usuario"; Expression = { $_.Name } },
            @{Name = "Estado"; Expression = {
                if ($_.Enabled) { "Habilitado" } else { "Deshabilitado" }
            }},
            @{Name = "Ultimo Login"; Expression = {
                if ($_.LastLogon) {
                    $_.LastLogon.ToString("dd/MM/yyyy HH:mm:ss")
                }
                else {
                    "Nunca ha iniciado sesion"
                }
            }}

        # Mostrar resultados
        Write-Host "`n========== USUARIOS DEL SISTEMA ==========" -ForegroundColor Cyan

        $userList | Format-Table -AutoSize

        Write-Host "Total de usuarios: $($users.Count)" -ForegroundColor Green
    }
    catch {
        Write-Host "`nError al consultar los usuarios: $($_.Exception.Message)" -ForegroundColor Red
    }
}