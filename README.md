# Stream-safe Browser

**Discord screen share shows a black screen on Netflix / Disney+? Fix it without turning off GPU acceleration.**

แชร์จอ Discord ตอนดู Netflix / Disney+ แล้วจอดำ? แก้ได้โดยไม่ต้องปิด Graphics acceleration

## Why the screen goes black / ทำไมจอดำ

Streaming sites use DRM. When GPU acceleration is on, Edge uses **PlayReady hardware DRM (SL3000)**,
a protected video path that Windows hides from every screen-capture tool, Discord included.
Turning GPU acceleration off "fixes" it only because it also kills hardware DRM, at the cost of a slower browser.

Measured on Edge 156 (`edge://gpu` + `requestMediaKeySystemAccess`):

| Setup | GPU accel | PlayReady hardware | PlayReady software | Widevine L3 |
|---|---|---|---|---|
| Default | on | **yes (black capture)** | yes | yes |
| GPU acceleration off (your current workaround) | off | no | **no** | yes |
| **This project** | **on** | **no** | **yes** | yes |

So you keep Canvas, rasterization, video decode and WebGL on the GPU, and DRM falls back to
software levels that Discord can capture.

## What is in here

| Part | Purpose |
|---|---|
| `scripts/` Stream-safe shortcut | Starts Edge with `--enable-features=msDisablePlayReadyHardwareDrm`. **This is the actual fix.** |
| `extension/` Stream-safe Check | Popup that tells you whether hardware DRM is currently on, plus an optional notice on streaming sites. A browser extension cannot change this setting itself; it can only check and remind. |

## Install (Windows, Edge)

1. Download or clone this repo.
2. In PowerShell, from the repo folder:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Install-StreamSafeShortcut.ps1
   ```
   This creates **Microsoft Edge (Stream-safe)** on your Desktop and Start menu and copies one launcher
   script to `%LOCALAPPDATA%\StreamSafeBrowser`. Nothing else on the system is modified.
3. Open Edge using that shortcut. If Edge is already running (Startup boost and "continue running
   background apps" keep it alive), the shortcut asks to restart it; tabs are restored. Flags only apply
   on a fresh start.
4. Optional: load `extension/` via `edge://extensions` → Developer mode → **Load unpacked**, then click its icon.
   It should say *Stream-safe: hardware DRM is OFF*.

Tip: if you want every launch to be stream-safe, turn off **Startup boost** in `edge://settings/system`,
otherwise a boosted background Edge may start without the flag.

Uninstall: `.\scripts\Install-StreamSafeShortcut.ps1 -Uninstall`, and remove the extension.

### Other Chromium browsers (untested)

`-Browser chrome` or `-Browser brave` uses `--disable-features=HardwareSecureDecryption` (Widevine hardware DRM).
Not tested by the author; try and report. The extension is plain Manifest V3 and loads in Chrome/Brave too.

## If Discord is still black

1. Discord → Settings → Voice & Video → turn **off** "Use our latest technology to capture your screen" and retry.
2. Share the **window** rather than the whole screen, or the other way round.
3. Make sure you started the browser from the Stream-safe shortcut (extension popup must show OFF).
4. Compare with `edge://gpu`: "PlayReady Hardware DRM disabled" should be `true`.

## Trade-offs and honesty

- The switch is an internal, undocumented Edge feature and may change in future versions. Verified on
  Edge 156.0.4314.42, Windows 11, NVIDIA GTX 1070. The popup will warn if it stops working.
- Netflix 4K / HDR needs hardware DRM, so those qualities are unavailable in this mode. Lower resolutions are
  not guaranteed to match normal Edge; check on your own account.
- Not verified end to end with live Netflix/Disney+ accounts and Discord; the DRM state change itself was verified.
- Use stream-safe mode to share your own screen with friends. It does not bypass DRM for copying content.

## Repo layout

```
extension/   MV3 extension (popup + optional banner)
scripts/     Install-StreamSafeShortcut.ps1, Start-StreamSafeBrowser.ps1
tools/       make-icons.mjs (regenerates icons, no dependencies)
```

License: MIT
