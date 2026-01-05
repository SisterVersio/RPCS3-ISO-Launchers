# Admin Elevation --------------------------------------------------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "Restarting script with Administrator privileges..."
    
    $argsQuoted = ($args | ForEach-Object { '"' + $_ + '"' }) -join ' '
    Start-Process powershell `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $argsQuoted" `
        -Verb RunAs

    exit
}

# Config ------------------------------------------
$driveLetter = "P:"
$emuPath = "C:\Games\Emulators\RPCS3\rpcs3.exe"

# ISO Mount ---------------------------------------------------
$isoImg = $args[0]
$isoImg = Resolve-Path $isoImg
DisMount-DiskImage -ImagePath $isoImg  
$diskImg = Mount-DiskImage -ImagePath $isoImg  -NoDriveLetter
$volInfo = $diskImg | Get-Volume
mountvol $driveLetter $volInfo.UniqueId

# RPCS3 Launch -------------------------------------------------
$driveRoot = "$($driveLetter)\"
$ebootPath = Join-Path $driveRoot "PS3_GAME\USRDIR\EBOOT.BIN"

if (-not (Test-Path $emuPath)) {
    throw "RPCS3 executable not found at: $emuPath"
}

if (-not (Test-Path $ebootPath)) {
    throw "EBOOT.BIN not found or invalid: $ebootPath"
}

Write-Host "Launching RPCS3..."
Write-Host "EBOOT: $ebootPath"

Start-Process `
    -FilePath $emuPath `
    -ArgumentList "--no-gui `"$ebootPath`"" `
    -WorkingDirectory (Split-Path $emuPath)