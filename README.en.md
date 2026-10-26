<p align="center"><img src="assets/banner.png" alt="Stream-safe Browser: share Netflix and Disney+ on Discord without the black screen" width="100%"></p>

# Stream-safe Browser

**Discord screen share shows a black screen on Netflix / Disney+? Fix it without turning off GPU acceleration.**

English · [ภาษาไทย](README.md)

[![Download](https://img.shields.io/badge/%E2%AC%87%20Download%20(Windows)-0a84ff?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest/download/stream-safe-browser-windows.zip)
[![Release](https://img.shields.io/github/v/release/Kensukeimagery/stream-safe-browser?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

> Tested on **Microsoft Edge (Windows 11)**. For other browsers see the [compatibility table](#which-browsers-work).

## Install in 3 steps

1. Click **Download** above and extract the zip (right-click → Extract All).
2. Double-click **`Install.bat`** (if Windows warns, choose *More info → Run anyway*).
3. Start Edge from the new **Microsoft Edge (Stream-safe)** icon on your Desktop, then share your screen on Discord.

If Edge is already running, the shortcut offers to restart it. Choose **Yes**; your tabs are restored.

Uninstall: double-click `Uninstall.bat`.

## How it looks

![4 steps: download, Install.bat, open Stream-safe, share on Discord](assets/steps.png)

## Before / after

![Before and after: normal Edge vs Stream-safe](assets/before-after.png)

The popup shots are real screenshots from Edge. The capture result was measured on a real Netflix account (see "Test results" below). No Netflix frames are included because they are copyrighted.

## Why the screen goes black

Streaming sites use DRM. With GPU acceleration on, Edge uses **PlayReady hardware DRM**, a protected
video path Windows hides from every screen-capture tool, Discord included. Turning GPU acceleration off
"fixes" it only because it also disables that DRM, at the cost of a slower browser.

This project disables **only hardware DRM**; the GPU keeps working. Measured on Edge 156:

| | GPU | PlayReady hardware | PlayReady software |
|---|---|---|---|
| Default | on | on (black capture) | yes |
| GPU acceleration off | off | off | no |
| **Stream-safe** | **on** | **off** | **yes** |

## Check extension (optional)

`extension/` is a small extension showing whether hardware DRM is currently on, with an optional notice on
streaming sites. Install: `edge://extensions` → enable **Developer mode** → **Load unpacked** → pick the `extension` folder.
*Stream-safe: hardware DRM is OFF* means it is working.

## Test results (Edge 156, Windows 11, GTX 1070)

Tested on a real Netflix account, same title at 1080p with DRM active (`mediaKeys` set), same capture tool:

| Mode | PlayReady hardware | Captured video |
|---|---|---|
| Normal Edge (GPU on) | on | **black** |
| Stream-safe (GPU on + flag) | off | **picture visible** |

- Netflix still plays at **1080p** in Stream-safe mode.
- Disney+ plays with DRM active, but its start (480p intro) is not the hardware path, so it is not a clean comparison.
- Windows Graphics Capture on the test machine was not black even in normal mode, so the Discord outcome depends on
  Discord's capture mode (next section) and is not yet confirmed with real Discord. Please report results in Issues.

## Which browsers work

| Browser | Status | What is actually known |
|---|---|---|
| **Microsoft Edge** (Windows 11) | ✅ **Tested, works** | Measured on Netflix: black normally, picture in Stream-safe, still 1080p |
| Edge Beta / Dev / Canary | ⚪ Untested | Same engine, the same flag is expected to work. Try `custom` |
| Google Chrome | ⚪ Untested | Not installed on the test machine. Chrome has no PlayReady, so it may not have this problem at all. The flag in the script is unverified |
| Brave | 🟡 Tested, **inconclusive** | A fresh profile has no Widevine (Brave ships it off until enabled), so every DRM level was false and there was nothing to measure |
| Vivaldi | ⚪ Untested | Built-in mode uses the Chrome-style flag, unverified |
| Opera / Opera GX | ⚪ Untested | Use `custom` mode |
| Firefox and forks | ❌ Not supported | Different engine, no such flag, no verified equivalent |
| macOS / Linux / mobile | ❌ Not supported | Windows only (Windows 10 is also untested) |

### Try it on your browser (2 minutes)

1. Install `extension/` in that browser and open the popup.
2. If it already says **hardware DRM is OFF**, this browser does not have this cause. See "Still black?" instead.
3. If it says **ON**, create a shortcut:
   ```powershell
   # Chrome / Brave / Vivaldi (flag unverified)
   .\scripts\Install-StreamSafeShortcut.ps1 -Browser chrome

   # Any other browser: give the exe path and the flag yourself
   .\scripts\Install-StreamSafeShortcut.ps1 -Browser custom -ExePath "C:\path	orowser.exe" -Flag "--disable-features=HardwareSecureDecryption"
   ```
4. Start the browser from the new shortcut and check that the popup now says OFF. If it does, try the screen share.
5. Report the result in [Issues](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml) and pick your browser. The table above will be updated.

## Still black?

1. Make sure Edge was started from the Stream-safe shortcut (the extension must say OFF), and turn off
   **Startup boost** in `edge://settings/system`, otherwise a background Edge may start without the setting.
2. Discord → Settings → Voice & Video → toggle **Use our latest technology to capture your screen** (try both states; they capture differently) and keep Discord's own **Hardware Acceleration** on (Settings → Advanced).
3. Try sharing the window instead of the screen, or the reverse.
4. Open `edge://gpu`: *PlayReady Hardware DRM disabled* should be `true`.

## Honest limits

- The switch is an undocumented internal Edge feature and may change in future versions.
- Netflix 4K/HDR needs hardware DRM and is unavailable in this mode. Other resolutions are unverified.
- The DRM state change is verified; end-to-end tests with live streaming accounts and Discord are not.
  Please [open an issue](https://github.com/Kensukeimagery/stream-safe-browser/issues) with your results.
- Intended for sharing your own screen with friends, not for copying protected content.

## For developers

```
Install.bat / Uninstall.bat      double-click installer
scripts/                         PowerShell: shortcut + launcher
extension/                       Manifest V3 (popup + banner)
tools/make-icons.mjs             dependency-free icon generator
```

Switch: `msedge.exe --enable-features=msDisablePlayReadyHardwareDrm` (Chrome/Brave: `--disable-features=HardwareSecureDecryption`)

License: MIT
