<#
.SYNOPSIS
  Creates a "Stream-safe" shortcut (Desktop + Start menu). Nothing else on the
  system is changed. Remove it with -Uninstall.
#>
[CmdletBinding()]
param(
  [ValidateSet('edge', 'chrome', 'brave')]
  [string]$Browser = 'edge',
  [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$names = @{ edge = 'Microsoft Edge'; chrome = 'Google Chrome'; brave = 'Brave' }
$exes  = @{ edge = 'msedge.exe'; chrome = 'chrome.exe'; brave = 'brave.exe' }
$title = "$($names[$Browser]) (Stream-safe)"

$targets = @(
  [Environment]::GetFolderPath('Desktop'),
  (Join-Path ([Environment]::GetFolderPath('Programs')) '')
)

$installDir = Join-Path $env:LOCALAPPDATA 'StreamSafeBrowser'

if ($Uninstall) {
  foreach ($dir in $targets) {
    $lnk = Join-Path $dir "$title.lnk"
    if (Test-Path -LiteralPath $lnk) { Remove-Item -LiteralPath $lnk -Force; Write-Host "Removed $lnk" }
  }
  # The launcher is shared by every browser's shortcut; drop it only when none are left.
  $others = $targets | ForEach-Object { Get-ChildItem -LiteralPath $_ -Filter '*(Stream-safe).lnk' -ErrorAction SilentlyContinue }
  if (-not $others -and (Test-Path $installDir)) { Remove-Item $installDir -Recurse -Force; Write-Host "Removed $installDir" }
  return
}

$source = Join-Path $PSScriptRoot 'Start-StreamSafeBrowser.ps1'
if (-not (Test-Path $source)) { throw "Missing $source" }

# Shortcuts cannot reliably store non-ASCII paths, so the launcher lives in an ASCII
# folder. This also lets you move or delete the downloaded repo afterwards.
if ($installDir -match '[^ -~]') { throw "Install path '$installDir' contains non-ASCII characters; not supported." }
New-Item -ItemType Directory -Force $installDir | Out-Null
$launcher = Join-Path $installDir 'Start-StreamSafeBrowser.ps1'
Copy-Item -LiteralPath $source -Destination $launcher -Force

$iconExe = $null
foreach ($root in 'HKCU', 'HKLM') {
  $v = (Get-ItemProperty "${root}:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$($exes[$Browser])" -ErrorAction SilentlyContinue).'(default)'
  if ($v -and (Test-Path $v)) { $iconExe = $v; break }
}
if (-not $iconExe) { throw "$($names[$Browser]) is not installed." }

$shell = New-Object -ComObject WScript.Shell
foreach ($dir in $targets) {
  $lnk = Join-Path $dir "$title.lnk"
  # WScript.Shell cannot save into non-ASCII folders (e.g. a localized Desktop),
  # so build the shortcut in the temp folder and move it.
  $tmp = Join-Path ([IO.Path]::GetTempPath()) ("ssb-" + [guid]::NewGuid().ToString('N') + '.lnk')
  $s = $shell.CreateShortcut($tmp)
  $s.TargetPath = (Get-Command powershell.exe).Source
  $s.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$launcher`" -Browser $Browser"
  $s.IconLocation = "$iconExe,0"
  $s.WorkingDirectory = $installDir
  $s.Description = 'Starts the browser with hardware DRM off so Discord screen share is not black. GPU acceleration stays on.'
  $s.Save()
  Move-Item -LiteralPath $tmp -Destination $lnk -Force
  Write-Host "Created $lnk"
}
Write-Host "`nDone. Launcher installed to $installDir"
