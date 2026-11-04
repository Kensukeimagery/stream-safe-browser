<#
.SYNOPSIS
  Makes Microsoft Edge start in Stream-safe mode every time, however it is opened
  (desktop/taskbar/Start icon, startup boost at login, optionally links from other apps).
  Everything it changes is backed up and undone by -Disable.

.DESCRIPTION
  1. Appends the stream-safe flags to the Arguments of every Edge shortcut you own
     (Desktop, your Start menu, pinned taskbar/Start items). The original .lnk is backed up.
  2. Appends the flags to Edge's auto-start entry (HKCU Run, MicrosoftEdgeAutoLaunch_*),
     so the background Edge started at login also has them.
  3. With -IncludeLinks: adds per-user (HKCU) overrides for the Edge link handlers
     (MSEdgeHTM, MSEdgeMHT, microsoft-edge) so links from other apps get the flags too.

  Run with -WhatIf first to see exactly what would change. Nothing needs administrator rights;
  all-users shortcuts are reported and skipped.

.EXAMPLE
  .\Enable-AutoStreamSafe.ps1 -WhatIf
  .\Enable-AutoStreamSafe.ps1 -Mode compat -IncludeLinks
  .\Enable-AutoStreamSafe.ps1 -Disable
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [ValidateSet('standard', 'compat')]
  [string]$Mode = 'standard',
  [switch]$IncludeLinks,
  [switch]$Disable,
  # Test hook: scan only these folders for shortcuts and skip registry changes.
  [string[]]$ShortcutDirs,
  [string]$StateDir = (Join-Path $env:LOCALAPPDATA 'StreamSafeBrowser')
)

$ErrorActionPreference = 'Stop'
$marker = '--enable-features=msDisablePlayReadyHardwareDrm'
$flags = $marker
if ($Mode -eq 'compat') { $flags += ' --disable-direct-composition' }

$statePath = Join-Path $StateDir 'auto-state.json'
$lnkBackup = Join-Path $StateDir 'lnk-backup'
New-Item -ItemType Directory -Force $lnkBackup -WhatIf:$false | Out-Null
$state = if (Test-Path $statePath) { Get-Content $statePath -Raw | ConvertFrom-Json } else { $null }
if (-not $state) { $state = [pscustomobject]@{ shortcuts = @(); run = @(); links = @() } }
$state.shortcuts = @($state.shortcuts); $state.run = @($state.run); $state.links = @($state.links)
function Save-State { $state | ConvertTo-Json -Depth 6 | Set-Content -Path $statePath -Encoding UTF8 }

$shell = New-Object -ComObject WScript.Shell
$testing = [bool]$ShortcutDirs

function Insert-Flags([string]$command) {
  # Put the flags right after the executable, keep everything else (e.g. --single-argument %1).
  if ($command -match '^\s*("[^"]+"|\S+)\s*(.*)$') {
    $exe = $Matches[1]; $rest = $Matches[2]
    return ("$exe $flags $rest").Trim()
  }
  return $command
}

# ---------------------------------------------------------------- shortcuts
$dirs = if ($testing) { $ShortcutDirs } else {
  @([Environment]::GetFolderPath('Desktop'),
    [Environment]::GetFolderPath('Programs'),
    (Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar'),
    (Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu'),
    (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs')) | Select-Object -Unique
}

function Read-Shortcut([string]$path) {
  # Same non-ASCII limitation applies to reading, so read a temp copy.
  $tmp = Join-Path ([IO.Path]::GetTempPath()) ('ssb-' + [guid]::NewGuid().ToString('N') + '.lnk')
  Copy-Item -LiteralPath $path -Destination $tmp -Force -WhatIf:$false
  try { $r = $shell.CreateShortcut($tmp); return [pscustomobject]@{ TargetPath = $r.TargetPath; Arguments = $r.Arguments } }
  finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue -WhatIf:$false }
}

function Set-ShortcutArguments([string]$path, [string]$newArgs) {
  # WScript.Shell cannot save into non-ASCII folders: edit a temp copy, then copy it back.
  $tmp = Join-Path ([IO.Path]::GetTempPath()) ('ssb-' + [guid]::NewGuid().ToString('N') + '.lnk')
  Copy-Item -LiteralPath $path -Destination $tmp -Force
  $s = $shell.CreateShortcut($tmp); $s.Arguments = $newArgs; $s.Save()
  Copy-Item -LiteralPath $tmp -Destination $path -Force
  Remove-Item -LiteralPath $tmp -Force
}

if ($Disable) {
  foreach ($e in $state.shortcuts) {
    if ((Test-Path -LiteralPath $e.backup) -and $PSCmdlet.ShouldProcess($e.path, 'restore original shortcut')) {
      Copy-Item -LiteralPath $e.backup -Destination $e.path -Force
      Write-Host "Restored shortcut: $($e.path)"
    }
  }
  $state.shortcuts = @()
} else {
  foreach ($d in $dirs) {
    if (-not (Test-Path -LiteralPath $d)) { continue }
    foreach ($f in Get-ChildItem -LiteralPath $d -Filter '*.lnk' -Recurse -Depth 1 -ErrorAction SilentlyContinue) {
      try { $s = Read-Shortcut $f.FullName } catch { continue }
      if ([IO.Path]::GetFileName($s.TargetPath) -ne 'msedge.exe') { continue }
      if ($s.Arguments -like "*$marker*") { Write-Host "Already set: $($f.FullName)"; continue }
      if ($state.shortcuts | Where-Object { $_.path -eq $f.FullName }) { continue }
      if ($PSCmdlet.ShouldProcess($f.FullName, "add flags to shortcut ($flags)")) {
        $bk = Join-Path $lnkBackup ([guid]::NewGuid().ToString('N') + '.lnk')
        Copy-Item -LiteralPath $f.FullName -Destination $bk -Force
        $new = ("$flags $($s.Arguments)").Trim()
        try {
          Set-ShortcutArguments $f.FullName $new
          $state.shortcuts += [pscustomobject]@{ path = $f.FullName; backup = $bk }
          Write-Host "Updated shortcut: $($f.FullName)"
        } catch { Write-Warning "Could not update $($f.FullName): $($_.Exception.Message)" }
      }
    }
  }
}

if ($testing) { Save-State; return }

# --------------------------------------------------------- auto-start (HKCU Run)
$runKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
if ($Disable) {
  foreach ($e in $state.run) {
    if ($PSCmdlet.ShouldProcess("$runKey\$($e.name)", 'restore original value')) {
      Set-ItemProperty -Path $runKey -Name $e.name -Value $e.value
      Write-Host "Restored auto-start entry: $($e.name)"
    }
  }
  $state.run = @()
} else {
  $props = (Get-Item $runKey).Property | Where-Object { $_ -like 'MicrosoftEdgeAutoLaunch*' }
  foreach ($n in $props) {
    $v = (Get-ItemProperty -Path $runKey -Name $n).$n
    if ($v -like "*$marker*") { Write-Host "Already set: auto-start $n"; continue }
    if ($PSCmdlet.ShouldProcess("$runKey\$n", "add flags ($flags)")) {
      $state.run += [pscustomobject]@{ name = $n; value = $v }
      Set-ItemProperty -Path $runKey -Name $n -Value (Insert-Flags $v)
      Write-Host "Updated auto-start entry: $n"
    }
  }
}

# ----------------------------------------------------------- link handlers (HKCU)
$classes = @('MSEdgeHTM', 'MSEdgeMHT', 'MSEdgePDF', 'microsoft-edge')
if ($Disable) {
  foreach ($c in $state.links) {
    $p = "HKCU:\Software\Classes\$c\shell\open\command"
    if ($PSCmdlet.ShouldProcess($p, 'remove per-user override')) {
      if (Test-Path $p) { Remove-Item -Path "HKCU:\Software\Classes\$c\shell\open\command" -Force }
      Write-Host "Removed link-handler override: $c"
    }
  }
  $state.links = @()
} elseif ($IncludeLinks) {
  foreach ($c in $classes) {
    $src = "Registry::HKEY_CLASSES_ROOT\$c\shell\open\command"
    if (-not (Test-Path $src)) { continue }
    $orig = (Get-ItemProperty -Path $src).'(default)'
    $dst = "HKCU:\Software\Classes\$c\shell\open\command"
    if ((Test-Path $dst) -and ((Get-ItemProperty -Path $dst).'(default)' -like "*$marker*")) { Write-Host "Already set: link handler $c"; continue }
    if ((Test-Path $dst)) { Write-Warning "Per-user handler for $c already exists; skipped."; continue }
    if ($PSCmdlet.ShouldProcess($dst, "create per-user override ($flags)")) {
      New-Item -Path $dst -Force | Out-Null
      Set-ItemProperty -Path $dst -Name '(default)' -Value (Insert-Flags $orig)
      $state.links += $c
      Write-Host "Created link-handler override: $c"
    }
  }
}

if ($WhatIfPreference) { Write-Host "`nDry run only: nothing was changed."; return }
Save-State
if ($Disable) { Write-Host "`nDone. Everything this script changed was restored." }
else { Write-Host "`nDone. Close Edge completely (also from the tray) and open it normally. Mode: $Mode" }
