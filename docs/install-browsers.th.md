# คู่มือติดตั้งตามเบราว์เซอร์

[English](install-browsers.en.md) · ภาษาไทย · [กลับหน้าหลัก](../README.md)

ทำตามทีละข้อ ไม่ต้องมีความรู้ด้านโปรแกรมมิ่ง ใช้เวลาประมาณ 3 นาที

> **สถานะตรงๆ:** ทดสอบแล้วว่าใช้ได้เฉพาะ **Microsoft Edge** ส่วนเบราว์เซอร์อื่นผมเตรียมตัวติดตั้งไว้ให้ แต่ **ยังไม่ได้ยืนยัน**ว่า flag ได้ผล คู่มือนี้มีขั้นตอน "เช็กว่าได้ผลไหม" ให้ทุกเบราว์เซอร์ ถ้าไม่ได้ผล บอกเราได้ที่ [Issues](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml)

## ก่อนเริ่ม

- ใช้ได้กับ **Windows เท่านั้น**
- ไม่ต้องปิดเบราว์เซอร์ก่อน (ถ้าเปิดอยู่ ตัวติดตั้งจะถามเมื่อถึงเวลาเปิดใหม่)
- **เลือกโฟลเดอร์ถาวรให้โปรเจกต์ก่อนแตกไฟล์** เช่น `C:\Tools` เพราะ extension จะอ้างอิงโฟลเดอร์นี้ ถ้าลบหรือย้ายทีหลัง extension จะหาย

## ขั้นที่ 1: ดาวน์โหลดและแตกไฟล์ (ทุกเบราว์เซอร์เหมือนกัน)

1. เปิด [หน้า Releases](https://github.com/Kensukeimagery/stream-safe-browser/releases/latest) แล้วกด `stream-safe-browser-windows.zip`
2. คลิกขวาที่ไฟล์ zip ที่ดาวน์โหลดมา → **Extract All…** → เลือกโฟลเดอร์ถาวร เช่น `C:\Tools` → **Extract**
   อย่าดับเบิลคลิกไฟล์ใน zip โดยตรง จะรันไม่ได้
3. เปิดโฟลเดอร์ `stream-safe-browser` ที่แตกออกมา คุณจะเห็นไฟล์ `Install...bat` หลายตัว ตัวไหนใช้กับเบราว์เซอร์ไหนอยู่ในหัวข้อถัดไป

## เลือกเบราว์เซอร์ของคุณ

| เบราว์เซอร์ | ไปที่ | สถานะ |
|---|---|---|
| Microsoft Edge | [Edge](#microsoft-edge) | ✅ ทดสอบแล้ว |
| Google Chrome | [Chrome](#google-chrome) | ⚪ ยังไม่ทดสอบ |
| Brave | [Brave](#brave) | 🟡 ตัดสินไม่ได้ |
| Vivaldi | [Vivaldi](#vivaldi) | ⚪ ยังไม่ทดสอบ |
| Opera / Opera GX | [Opera](#opera--opera-gx) | ⚪ ยังไม่ทดสอบ |
| Edge Beta/Dev/Canary หรือตัวอื่นที่ใช้ Chromium | [ตัวอื่นๆ](#เบราว์เซอร์อื่นที่ใช้-chromium) | ⚪ ยังไม่ทดสอบ |
| Firefox | [Firefox](#firefox) | ❌ ไม่รองรับ |

---

## Microsoft Edge

**สร้างทางลัด**
1. ดับเบิลคลิก **`Install.bat`**
2. ถ้าขึ้นหน้าต่างสีน้ำเงิน *Windows protected your PC* ให้กด **More info** แล้ว **Run anyway** (ไฟล์เป็นสคริปต์ข้อความ เปิดอ่านได้ทุกบรรทัด)
3. หน้าต่างดำจะขึ้นข้อความ `Created ...` และ `Done` แล้วกดปุ่มใดก็ได้เพื่อปิด
4. บน Desktop จะมีไอคอน **Microsoft Edge (Stream-safe)**

**เปิดใช้**
5. ปิด Edge ที่เปิดอยู่ แล้วเปิด Edge จากไอคอน **Stream-safe** นี้เท่านั้น
   ถ้า Edge เปิดค้างอยู่ จะมีกล่องถามว่าจะรีสตาร์ตไหม กด **Yes** (แท็บเดิมกลับมา)

**ติดตั้ง extension ตรวจสถานะ (ไม่บังคับ แต่แนะนำ)**
6. พิมพ์ `edge://extensions` ที่แถบที่อยู่ แล้วกด Enter
7. เปิดสวิตช์ **Developer mode** (ซ้ายล่างหรือขวาบน แล้วแต่รุ่น)
8. กด **Load unpacked** แล้วเลือกโฟลเดอร์ `extension` ที่อยู่ในโฟลเดอร์ที่แตกไฟล์
9. กดไอคอน extension (ถ้าไม่เห็น ให้กดไอคอนจิ๊กซอว์ แล้วปักหมุด)

**เช็กว่าได้ผล:** popup ต้องขึ้นแถบเขียว **Stream-safe: hardware DRM is OFF** ถ้าเป็นแถบเหลือง **ON** ดู[แก้ปัญหา](#แก้ปัญหา)

---

## Google Chrome

> Chrome ไม่มี PlayReady จึงอาจ **ไม่เจอปัญหานี้อยู่แล้ว** ให้ติดตั้ง extension ก่อน (ขั้น 5–8 ข้างล่าง) แล้วดู popup ถ้าขึ้น OFF อยู่แล้ว ไม่ต้องทำขั้นทางลัด

**ติดตั้ง extension ก่อนเพื่อเช็ก**
1. พิมพ์ `chrome://extensions` ที่แถบที่อยู่
2. เปิด **Developer mode** (มุมขวาบน)
3. กด **Load unpacked** แล้วเลือกโฟลเดอร์ `extension`
4. กดไอคอน extension ดู popup
   - **OFF (เขียว):** จบ ไม่ต้องทำอะไรเพิ่ม ถ้า Discord ยังดำ ดู[แก้ปัญหา](#discord-ยังดำ)
   - **ON (เหลือง):** ทำต่อข้อล่าง

**สร้างทางลัด** (flag ยังไม่ยืนยัน)
5. ดับเบิลคลิก **`Install-Chrome.bat`** (ถ้าขึ้น SmartScreen ทำเหมือนข้อ Edge)
6. ปิด Chrome ให้หมด แล้วเปิดจากไอคอน **Google Chrome (Stream-safe)**
7. เปิด popup อีกครั้ง ถ้าเปลี่ยนเป็น OFF แปลว่า flag ได้ผล ถ้ายัง ON แปลว่า flag นี้ไม่ได้ผลใน Chrome ของคุณ กรุณา[แจ้งผล](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml)

**ที่ควรรู้:** Chrome อาจขึ้นกล่อง *Disable developer mode extensions* ทุกครั้งที่เปิด เป็นเรื่องปกติของ extension ที่โหลดเอง กด **Cancel** หรือปิดกล่องได้

---

## Brave

> ทดสอบแล้วแต่ **ตัดสินไม่ได้** เพราะ Brave ปิด Widevine ไว้จนคุณเปิดเอง ถ้ายังไม่เปิด Netflix/Disney+ ก็เล่นไม่ได้อยู่แล้ว

**เปิด Widevine ก่อน (ถ้ายังไม่เคย)**
1. พิมพ์ `brave://settings/extensions` → เปิด **Widevine** → รีสตาร์ต Brave

**ติดตั้ง extension เพื่อเช็ก**
2. พิมพ์ `brave://extensions` → เปิด **Developer mode** → **Load unpacked** → เลือกโฟลเดอร์ `extension`
3. ดู popup: **OFF** = ไม่ต้องทำอะไรเพิ่ม, **ON** = ทำต่อ

**สร้างทางลัด** (flag ยังไม่ยืนยัน)
4. ดับเบิลคลิก **`Install-Brave.bat`**
5. ปิด Brave ให้หมด (ดูที่ถาดระบบมุมขวาล่างด้วย) แล้วเปิดจากไอคอน **Brave (Stream-safe)**
6. เช็ก popup อีกครั้ง

---

## Vivaldi

1. ดับเบิลคลิก **`Install-Vivaldi.bat`**
2. ปิด Vivaldi ให้หมด แล้วเปิดจากไอคอน **Vivaldi (Stream-safe)**
3. ติดตั้ง extension: พิมพ์ `vivaldi://extensions` → เปิด **Developer mode** → **Load unpacked** → เลือกโฟลเดอร์ `extension`
4. เช็ก popup: ต้องเป็น OFF (flag ยังไม่ยืนยัน)

---

## Opera / Opera GX

Opera ไม่มีตัวติดตั้งเฉพาะ ใช้วิธี **ลากไฟล์มาวาง**

1. หาไฟล์โปรแกรมของ Opera: คลิกขวาที่ไอคอน Opera บน Desktop หรือ Start → **Properties** → ช่อง **Target** คือ path ของไฟล์ (หรือกด **Open file location**) ไฟล์นั้นลงท้าย `.exe` (มักชื่อ `launcher.exe` หรือ `opera.exe`)
2. เปิดโฟลเดอร์ `stream-safe-browser` ไว้ข้างๆ ลากไฟล์ `.exe` ของ Opera ไป **วางทับ** ไฟล์ **`Install-Other-Browser.bat`**
3. ขึ้นข้อความ `Created ...` แปลว่าสำเร็จ จะมีไอคอน **(Stream-safe)** บน Desktop
4. **ปิด Opera ให้สนิทก่อน** (คลิกขวาไอคอน Opera ที่ถาดระบบ → Exit) เพราะตัวติดตั้งตรวจไม่เจอว่า Opera เปิดค้างอยู่ แล้วเปิดจากไอคอนใหม่
5. ติดตั้ง extension: `opera://extensions` → **Developer mode** → **Load unpacked** → เลือกโฟลเดอร์ `extension`
6. เช็ก popup ต้องเป็น OFF (flag ยังไม่ยืนยัน)

---

## เบราว์เซอร์อื่นที่ใช้ Chromium

(Edge Beta / Dev / Canary, Chromium, Arc, Thorium ฯลฯ) ใช้วิธีเดียวกับ Opera:
1. หาไฟล์ `.exe` ของเบราว์เซอร์ (คลิกขวาไอคอน → Properties → Target)
2. ลากไปวางทับ **`Install-Other-Browser.bat`**
3. ถ้า path มีคำว่า `msedge` จะใช้ flag ของ Edge ให้เอง ถ้าไม่ใช่ จะใช้ flag แบบ Chrome (ยังไม่ยืนยัน)
4. ปิดเบราว์เซอร์ให้สนิท เปิดจากไอคอนใหม่ ติดตั้ง extension จากหน้า extensions ของเบราว์เซอร์นั้น แล้วเช็ก popup

---

## Firefox

**ไม่รองรับ** Firefox เป็นคนละเอนจิน ไม่มี flag นี้ และยังไม่มีสวิตช์เทียบเท่าที่ยืนยันแล้ว ถ้าต้องการแชร์จอที่มี DRM ให้ใช้ Edge แทนชั่วคราว

---

## แก้ปัญหา

**Windows ขึ้น "Windows protected your PC"**
กด **More info** → **Run anyway** นี่เป็นคำเตือนมาตรฐานสำหรับไฟล์ที่ดาวน์โหลดมาและไม่มีลายเซ็นดิจิทัล เปิดไฟล์ `.bat` และ `scripts\*.ps1` ด้วย Notepad เพื่ออ่านก่อนได้

**ดับเบิลคลิก .bat แล้วหน้าต่างวูบหายไป**
ปกติหน้าต่างจะค้างรอให้กดปุ่มก่อนปิด ถ้าวูบหายไปเลย ให้แตกไฟล์ zip ใหม่ไปไว้โฟลเดอร์ที่ path สั้นๆ เช่น `C:\Tools`

**popup ยังขึ้น ON หลังเปิดจากทางลัด**
เรียงตามความน่าจะเป็น:
1. เปิดจากไอคอนเดิมแทนไอคอน **(Stream-safe)** → ใช้ไอคอนใหม่
2. เบราว์เซอร์ยังเปิดค้างอยู่เบื้องหลัง (Startup boost ของ Edge, ไอคอนที่ถาดระบบ) → ปิดให้สนิท ใน Edge ปิด **Startup boost** ที่ `edge://settings/system` ด้วย
3. flag ไม่ได้ผลกับเบราว์เซอร์นี้ → แจ้งผลที่ Issues พร้อมชื่อและเวอร์ชันเบราว์เซอร์

**extension หายไปหลังรีสตาร์ต / ขึ้นว่าไฟล์เสียหาย**
คุณลบหรือย้ายโฟลเดอร์ `extension` → วางโฟลเดอร์กลับที่เดิม หรือ Load unpacked ใหม่จากที่ใหม่

**Discord ยังดำ ทั้งที่ popup เป็น OFF** <a id="discord-ยังดำ"></a>
ไปที่ Discord → Settings → Voice & Video (เสียงและวิดีโอ) → หัวข้อ "กำลังสตรีม" แล้วลองสลับ **ใช้เทคโนโลยีอันล้ำหน้าของเราเพื่อจับภาพหน้าจอของคุณ** (ลองทั้งเปิดและปิด) และเปิด **Hardware Acceleration** ของ Discord ไว้ (Settings → Advanced) ลองแชร์ "หน้าต่าง" แทน "หน้าจอ" หรือกลับกัน แล้วบอกผลที่ Issues

## ถอนการติดตั้ง

- ดับเบิลคลิก **`Uninstall.bat`** (ลบทางลัดของ Edge, Chrome, Brave, Vivaldi)
- เบราว์เซอร์ที่ติดตั้งแบบลากไฟล์ (Opera ฯลฯ): ลากไฟล์ `.exe` เดิมไปวางทับ **`Uninstall-Other-Browser.bat`**
- ลบ extension: หน้า extensions ของเบราว์เซอร์ → **Remove**
- แล้วลบโฟลเดอร์ `stream-safe-browser` ได้เลย ไม่มีอะไรตกค้างในระบบ (ตัวติดตั้งเก็บไฟล์เดียวใน `%LOCALAPPDATA%\StreamSafeBrowser` และถูกลบตอนถอนการติดตั้ง)

## แจ้งผลการทดสอบ

[เปิด Issue](https://github.com/Kensukeimagery/stream-safe-browser/issues/new?template=test-result.yml) เลือกเบราว์เซอร์และบอกว่า popup เปลี่ยนจาก ON เป็น OFF ไหม และ Discord จอดำหรือเห็นภาพ ผลของคุณจะถูกเพิ่มในตารางหน้าหลัก
