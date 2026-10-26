<#
.SYNOPSIS
  Starts Edge (or another Chromium browser) with hardware DRM turned off so
  Discord screen share is not black, while GPU acceleration stays ON.

.NOTES
  Browser flags only apply when the browser starts from scratch. If it is already
  running (Startup boost / background apps count), it must be fully closed first.
  This script offers to do that; tabs are restored afterwards.
#>
[CmdletBinding()]
param(
  [ValidateSet('edge', 'chrome', 'brave', 'vivaldi', 'custom')]
  [string]$Browser = 'edge',
  # Only for -Browser custom: full path to the browser exe and the flag to start it with.
  [string]$ExePath,
  [string]$Flag,
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Rest
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms

$profiles = @{
  edge   = @{ Exe = 'msedge.exe';  Proc = 'msedge';  Name = 'Microsoft Edge'
              Flag = '--enable-features=msDisablePlayReadyHardwareDrm' }
  chrome = @{ Exe = 'chrome.exe';  Proc = 'chrome';  Name = 'Google Chrome'
              Flag = '--disable-features=HardwareSecureDecryption' }
  brave  = @{ Exe = 'brave.exe';   Proc = 'brave';   Name = 'Brave'
              Flag = '--disable-features=HardwareSecureDecryption' }
  vivaldi = @{ Exe = 'vivaldi.exe'; Proc = 'vivaldi'; Name = 'Vivaldi'
              Flag = '--disable-features=HardwareSecureDecryption' }
}
if ($Browser -eq 'custom') {
  if (-not $ExePath -or -not $Flag) { throw '-Browser custom needs both -ExePath and -Flag.' }
  $leaf = [IO.Path]::GetFileName($ExePath)
  $p = @{ Exe = $leaf; Proc = [IO.Path]::GetFileNameWithoutExtension($leaf); Name = $leaf; Flag = $Flag }
} else {
  $p = $profiles[$Browser]
}

function Find-BrowserExe([string]$exe) {
  foreach ($root in 'HKCU', 'HKLM') {
    $key = "${root}:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$exe"
    $v = (Get-ItemProperty -Path $key -ErrorAction SilentlyContinue).'(default)'
    if ($v -and (Test-Path $v)) { return $v }
  }
  return $null
}

$exePath = if ($Browser -eq 'custom') { if (Test-Path $ExePath) { $ExePath } else { $null } } else { Find-BrowserExe $p.Exe }
if (-not $exePath) {
  [void][System.Windows.Forms.MessageBox]::Show("$($p.Name) was not found on this PC.", 'Stream-safe browser', 'OK', 'Error')
  exit 1
}

function Get-Running { Get-Process -Name $p.Proc -ErrorAction SilentlyContinue }

$flagName = ($p.Flag -split '=')[1]
$alreadyOk = $false
$running = Get-Running
if ($running) {
  $cmd = Get-CimInstance Win32_Process -Filter "Name='$($p.Exe)'" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -and $_.CommandLine -notmatch '--type=' } |
    Select-Object -First 1 -ExpandProperty CommandLine
  $alreadyOk = ($cmd -and $cmd -like "*$flagName*")
}

$extra = @()
if ($running -and -not $alreadyOk) {
  $answer = [System.Windows.Forms.MessageBox]::Show(
    "$($p.Name) is already running, so the stream-safe setting cannot apply yet.`n`n" +
    "Restart it now? Your tabs will be restored.`n`n" +
    "Yes = restart stream-safe`nNo = open normally (screen share may stay black)",
    'Stream-safe browser', 'YesNo', 'Question')
  if ($answer -eq 'Yes') {
    foreach ($proc in $running) { if ($proc.MainWindowHandle -ne 0) { [void]$proc.CloseMainWindow() } }
    $deadline = (Get-Date).AddSeconds(10)
    while ((Get-Running) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 300 }
    # Background / startup-boost processes have no window; end whatever is left.
    Get-Running | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 800
    $extra += '--restore-last-session'
  } else {
    Start-Process -FilePath $exePath -ArgumentList $Rest
    exit 0
  }
}

Start-Process -FilePath $exePath -ArgumentList (@($p.Flag) + $extra + $Rest)
