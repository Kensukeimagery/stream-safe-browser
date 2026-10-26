# Install guide by browser

English · [ภาษาไทย](install-browsers.th.md) · [Back to README](../README.md)

Follow it step by step. No programming knowledge needed. About 3 minutes.

> **Honest status:** only **Microsoft Edge** is confirmed to work. For other browsers there is an installer, but the flag is **not verified**. Every section includes a "check it worked" step. If it does not work for you, tell us in [Issues](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml).

## Before you start

- **Windows only.**
- You do not need to close your browser first (if it is open, you are asked at launch time).
- **Pick a permanent folder before extracting**, for example `C:\Tools`. The extension points at that folder; if you delete or move it later, the extension disappears.

## Step 1: Download and extract (same for every browser)

1. Open the [Releases page](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest) and click `stream-safe-browser-windows.zip`.
2. Right-click the downloaded zip → **Extract All…** → choose your permanent folder, e.g. `C:\Tools` → **Extract**.
   Do not double-click files inside the zip; they will not run.
3. Open the extracted `stream-safe-browser` folder. You will see several `Install...bat` files. The next section says which one is yours.

## Pick your browser

| Browser | Go to | Status |
|---|---|---|
| Microsoft Edge | [Edge](#microsoft-edge) | ✅ Tested |
| Google Chrome | [Chrome](#google-chrome) | ⚪ Untested |
| Brave | [Brave](#brave) | 🟡 Inconclusive |
| Vivaldi | [Vivaldi](#vivaldi) | ⚪ Untested |
| Opera / Opera GX | [Opera](#opera--opera-gx) | ⚪ Untested |
| Edge Beta/Dev/Canary or any other Chromium browser | [Other](#other-chromium-browsers) | ⚪ Untested |
| Firefox | [Firefox](#firefox) | ❌ Not supported |

---

## Microsoft Edge

**Create the shortcut**
1. Double-click **`Install.bat`**.
2. If a blue *Windows protected your PC* window appears, click **More info** → **Run anyway** (the file is a plain-text script you can read).
3. A black window shows `Created ...` and `Done`. Press any key to close it.
4. A **Microsoft Edge (Stream-safe)** icon appears on your Desktop.

**Use it**
5. Close Edge, then open Edge only from this **Stream-safe** icon.
   If Edge is already running you get a box asking to restart it. Click **Yes** (your tabs come back).

**Install the check extension (optional but recommended)**
6. Type `edge://extensions` in the address bar and press Enter.
7. Turn on **Developer mode**.
8. Click **Load unpacked** and choose the `extension` folder inside the folder you extracted.
9. Click the extension icon (if hidden, click the puzzle-piece icon and pin it).

**Check it worked:** the popup must show a green bar **Stream-safe: hardware DRM is OFF**. A yellow **ON** bar: see [Troubleshooting](#troubleshooting).

---

## Google Chrome

> Chrome has no PlayReady, so it may **not have this problem at all**. Install the extension first (steps 1–4), look at the popup, and skip the shortcut if it already says OFF.

**Install the extension first, to check**
1. Type `chrome://extensions` in the address bar.
2. Turn on **Developer mode** (top right).
3. Click **Load unpacked** and choose the `extension` folder.
4. Click the extension icon.
   - **OFF (green):** done. If Discord is still black, see [Discord is still black](#discord-is-still-black).
   - **ON (yellow):** continue.

**Create the shortcut** (flag unverified)
5. Double-click **`Install-Chrome.bat`** (SmartScreen: same as the Edge section).
6. Close Chrome completely, then open it from **Google Chrome (Stream-safe)**.
7. Open the popup again. If it now says OFF, the flag works. If it still says ON, the flag does not work in your Chrome; please [report it](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml).

**Good to know:** Chrome may show *Disable developer mode extensions* at every start. That is normal for side-loaded extensions; click **Cancel** or close it.

---

## Brave

> Tested but **inconclusive**: Brave ships Widevine off until you enable it, and without Widevine Netflix/Disney+ do not play anyway.

**Enable Widevine first (if you have not)**
1. Open `brave://settings/extensions` → turn on **Widevine** → restart Brave.

**Install the extension to check**
2. Open `brave://extensions` → **Developer mode** → **Load unpacked** → choose the `extension` folder.
3. Read the popup: **OFF** = nothing more to do, **ON** = continue.

**Create the shortcut** (flag unverified)
4. Double-click **`Install-Brave.bat`**.
5. Close Brave completely (check the system tray bottom right too), then open **Brave (Stream-safe)**.
6. Check the popup again.

---

## Vivaldi

1. Double-click **`Install-Vivaldi.bat`**.
2. Close Vivaldi completely, then open **Vivaldi (Stream-safe)**.
3. Install the extension: `vivaldi://extensions` → **Developer mode** → **Load unpacked** → choose the `extension` folder.
4. Check the popup. It must say OFF (flag unverified).

---

## Opera / Opera GX

Opera has no dedicated installer; use **drag and drop**.

1. Find Opera's program file: right-click the Opera icon on your Desktop or Start menu → **Properties** → the **Target** box is the file path (or click **Open file location**). The file ends in `.exe` (often `launcher.exe` or `opera.exe`).
2. Keep the `stream-safe-browser` folder open next to it. Drag Opera's `.exe` and **drop it on** **`Install-Other-Browser.bat`**.
3. `Created ...` means success. A **(Stream-safe)** icon appears on your Desktop.
4. **Fully close Opera first** (right-click the Opera tray icon → Exit), because the installer cannot detect a running Opera. Then open the new icon.
5. Install the extension: `opera://extensions` → **Developer mode** → **Load unpacked** → choose the `extension` folder.
6. Check the popup. It must say OFF (flag unverified).

---

## Other Chromium browsers

(Edge Beta / Dev / Canary, Chromium, Arc, Thorium and so on.) Same method as Opera:
1. Find the browser's `.exe` (right-click its icon → Properties → Target).
2. Drag it onto **`Install-Other-Browser.bat`**.
3. If the path contains `msedge`, the Edge flag is used automatically; otherwise the Chrome-style flag is used (unverified).
4. Fully close the browser, open the new icon, install the extension from that browser's extensions page, then check the popup.

---

## Firefox

**Not supported.** Firefox is a different engine, has no such flag, and no verified equivalent switch. Use Edge for screen sharing DRM content for now.

---

## Troubleshooting

**Windows shows "Windows protected your PC"**
Click **More info** → **Run anyway**. This is the standard warning for downloaded files without a paid digital signature. You can open the `.bat` and `scripts\*.ps1` files in Notepad and read them first.

**The .bat window flashes and disappears**
It normally waits for a key press. If it vanishes, extract the zip again to a short folder such as `C:\Tools`.

**The popup still says ON after opening from the shortcut**
Most likely first:
1. You opened the normal icon instead of the **(Stream-safe)** one. Use the new icon.
2. The browser is still running in the background (Edge's Startup boost, a tray icon). Close it fully. In Edge also turn off **Startup boost** in `edge://settings/system`.
3. The flag does not work for this browser. Report it in Issues with the browser name and version.

**The extension vanished after a restart / says it is corrupted**
You deleted or moved the `extension` folder. Put it back, or **Load unpacked** again from its new place.

**Discord is still black although the popup says OFF** <a id="discord-is-still-black"></a>
Discord → Settings → Voice & Video → "Streaming" section. Toggle **Use our latest technology to capture your screen** (try both states) and keep Discord's own **Hardware Acceleration** on (Settings → Advanced). Try sharing the "window" instead of the "screen", or the reverse, then report the result in Issues.

## Uninstall

- Double-click **`Uninstall.bat`** (removes the Edge, Chrome, Brave and Vivaldi shortcuts).
- For browsers installed by drag and drop (Opera etc.): drag the same `.exe` onto **`Uninstall-Other-Browser.bat`**.
- Remove the extension: the browser's extensions page → **Remove**.
- Then delete the `stream-safe-browser` folder. Nothing else is left on the system (the installer keeps one file in `%LOCALAPPDATA%\StreamSafeBrowser`, removed by the uninstaller).

## Report your result

[Open an Issue](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml), pick your browser, and say whether the popup changed from ON to OFF and whether Discord shows black or a picture. Your result goes into the README table.
