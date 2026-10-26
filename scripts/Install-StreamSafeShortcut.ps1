<#
.SYNOPSIS
  Creates a "Stream-safe" shortcut (Desktop + Start menu). Nothing else on the
  system is changed. Remove it with -Uninstall.
#>
[CmdletBinding()]
param(
  [ValidateSet('edge', 'chrome', 'brave', 'vivaldi', 'custom')]
  [string]$Browser = 'edge',
  # Only for -Browser custom (e.g. Opera, Firefox forks): exe path and the start-up flag.
  [string]$ExePath,
  [string]$Flag,
  [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'
$names = @{ edge = 'Microsoft Edge'; chrome = 'Google Chrome'; brave = 'Brave'; vivaldi = 'Vivaldi'; custom = 'Custom browser' }
$exes  = @{ edge = 'msedge.exe'; chrome = 'chrome.exe'; brave = 'brave.exe'; vivaldi = 'vivaldi.exe'; custom = '' }
if ($Browser -eq 'custom' -and $ExePath) { $names['custom'] = [IO.Path]::GetFileNameWithoutExtension($ExePath) }
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
if ($Browser -eq 'custom') {
  if (-not $ExePath -or -not $Flag) { throw '-Browser custom needs both -ExePath and -Flag.' }
  if (-not (Test-Path $ExePath)) { throw "Not found: $ExePath" }
  $iconExe = $ExePath
}
if (-not $iconExe) { foreach ($root in 'HKCU', 'HKLM') {
  $v = (Get-ItemProperty "${root}:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$($exes[$Browser])" -ErrorAction SilentlyContinue).'(default)'
  if ($v -and (Test-Path $v)) { $iconExe = $v; break }
} }
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
  if ($Browser -eq 'custom') { $s.Arguments += " -ExePath `"$ExePath`" -Flag `"$Flag`"" }
  $s.IconLocation = "$iconExe,0"
  $s.WorkingDirectory = $installDir
  $s.Description = 'Starts the browser with hardware DRM off so Discord screen share is not black. GPU acceleration stays on.'
  $s.Save()
  Move-Item -LiteralPath $tmp -Destination $lnk -Force
  Write-Host "Created $lnk"
}
Write-Host "`nDone. Launcher installed to $installDir"
