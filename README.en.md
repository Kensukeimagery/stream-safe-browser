<p align="center"><img src="assets/banner.png" alt="Stream-safe Browser: share Netflix and Disney+ on Discord without the black screen" width="100%"></p>

# Stream-safe Browser

**Discord screen share shows a black screen on Netflix / Disney+? Fix it without turning off GPU acceleration.**

English · [ภาษาไทย](README.md)

[![Download](https://img.shields.io/badge/%E2%AC%87%20Download%20(Windows)-0a84ff?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest/download/stream-safe-browser-windows.zip)
[![Release](https://img.shields.io/github/v/release/Kensukeimagery/stream-safe-browser?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

> For **Microsoft Edge on Windows** (tested on Edge 156). Chrome / Brave are supported but untested.

## Install in 3 steps

1. Click **Download** above and extract the zip (right-click → Extract All).
2. Double-click **`Install.bat`** (if Windows warns, choose *More info → Run anyway*).
3. Start Edge from the new **Microsoft Edge (Stream-safe)** icon on your Desktop, then share your screen on Discord.

If Edge is already running, the shortcut offers to restart it. Choose **Yes**; your tabs are restored.

Uninstall: double-click `Uninstall.bat`.

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
