<p align="center"><img src="assets/banner.png" alt="Stream-safe Browser: share Netflix and Disney+ on Discord without the black screen" width="100%"></p>

# Stream-safe Browser

**แชร์จอ Discord ตอนดู Netflix / Disney+ แล้วจอดำ? แก้ได้ โดยไม่ต้องปิด Graphics acceleration**

[English](README.en.md) · ภาษาไทย

[![Download](https://img.shields.io/badge/%E2%AC%87%20%E0%B8%94%E0%B8%B2%E0%B8%A7%E0%B8%99%E0%B9%8C%E0%B9%82%E0%B8%AB%E0%B8%A5%E0%B8%94%20(Windows)-0a84ff?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest/download/stream-safe-browser-windows.zip)
[![Release](https://img.shields.io/github/v/release/Kensukeimagery/stream-safe-browser?style=for-the-badge)](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

> ใช้กับ **Microsoft Edge บน Windows** (ทดสอบบน Edge 156). Chrome / Brave ใช้ได้แบบยังไม่ทดสอบ

## ติดตั้งใน 3 ขั้นตอน

1. กดปุ่ม **ดาวน์โหลด** ด้านบน แล้วแตกไฟล์ zip (คลิกขวา → Extract All)
2. ดับเบิลคลิก **`Install.bat`** (ถ้า Windows ขึ้นเตือน กด *More info → Run anyway*)
3. เปิด Edge จากไอคอนใหม่ชื่อ **Microsoft Edge (Stream-safe)** บน Desktop แล้วแชร์จอ Discord ได้เลย

ถ้า Edge เปิดค้างอยู่ ทางลัดจะถามว่าจะรีสตาร์ตไหม กด **Yes** (แท็บเดิมจะกลับมา)

ลบออก: ดับเบิลคลิก `Uninstall.bat`

## ทำไมจอถึงดำ

เว็บสตรีมมิ่งใช้ DRM เมื่อเปิด GPU, Edge จะใช้ **PlayReady hardware DRM** ซึ่ง Windows ซ่อนจากโปรแกรมจับภาพหน้าจอทุกตัว รวมถึง Discord
การปิด GPU แก้ได้เพราะไปปิด DRM ตัวนี้ด้วย แต่ทำให้บางเว็บกระตุก

ตัวนี้ปิด **เฉพาะ hardware DRM** ส่วน GPU ยังทำงานเต็มที่:

| | GPU | PlayReady hardware | PlayReady software |
|---|---|---|---|
| ปกติ | เปิด | เปิด (จอดำ) | มี |
| ปิด GPU | ปิด | ปิด | ไม่มี |
| **Stream-safe** | **เปิด** | **ปิด** | **มี** |

## Extension ตรวจสถานะ (ไม่บังคับ)

ใน `extension/` เป็น extension เล็กๆ ที่บอกว่าตอนนี้ hardware DRM เปิดหรือปิด และเตือนบนเว็บสตรีมมิ่ง
ติดตั้ง: เปิด `edge://extensions` → เปิด **Developer mode** → **Load unpacked** → เลือกโฟลเดอร์ `extension`
ถ้าขึ้น *Stream-safe: hardware DRM is OFF* แปลว่าใช้งานได้

## ยังดำอยู่?

1. ตรวจว่าเปิด Edge จากทางลัด Stream-safe (extension ต้องขึ้น OFF) และปิด **Startup boost** ที่ `edge://settings/system` ไม่เช่นนั้น Edge ที่รออยู่เบื้องหลังอาจเปิดโดยไม่มีการตั้งค่านี้
2. Discord → Settings → Voice & Video → ปิด **Use our latest technology to capture your screen** แล้วลองใหม่
3. ลองแชร์ "หน้าต่าง" แทน "หน้าจอ" หรือกลับกัน
4. เปิด `edge://gpu` ดูว่า *PlayReady Hardware DRM disabled* เป็น `true`

## ข้อจำกัด (ตรงไปตรงมา)

- สวิตช์นี้เป็นฟีเจอร์ภายในของ Edge ที่ไม่มีเอกสารทางการ อาจเปลี่ยนในเวอร์ชันหน้า
- Netflix 4K/HDR ต้องใช้ hardware DRM จึงดูไม่ได้ในโหมดนี้ ความละเอียดอื่นยังไม่ยืนยัน
- ยืนยันแล้วว่าสถานะ DRM เปลี่ยนจริง แต่ยังไม่ได้ทดสอบครบกับบัญชีสตรีมมิ่งและ Discord จริง ถ้าลองแล้วได้ผลหรือไม่ได้ผล เปิด [Issue](https://github.com/Kensukeimagery/stream-safe-browser/issues) บอกได้เลย
- ใช้เพื่อแชร์จอของตัวเองให้เพื่อนดู ไม่ได้ช่วยเลี่ยง DRM เพื่อคัดลอกเนื้อหา

## สำหรับนักพัฒนา

```
Install.bat / Uninstall.bat      ตัวติดตั้งแบบดับเบิลคลิก
scripts/                         PowerShell: สร้างทางลัด + launcher
extension/                       Manifest V3 (popup + banner)
tools/make-icons.mjs             สร้างไอคอน ไม่ต้องใช้ dependency
```

ตัวสวิตช์: `msedge.exe --enable-features=msDisablePlayReadyHardwareDrm` (Chrome/Brave: `--disable-features=HardwareSecureDecryption`)

License: MIT
