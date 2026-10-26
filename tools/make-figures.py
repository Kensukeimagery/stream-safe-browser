"""Renders assets/before-after.png and assets/steps.png.
Run tools/shoot-popup.mjs first (it produces the real popup screenshots used here).
Every value in the before/after figure was measured on Edge 156 / Windows 11 / GTX 1070.
"""
import os
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(HERE, '..', 'assets')
FONT_DIR = os.environ.get('FONT_DIR', os.path.expanduser('~/.claude/skills/canvas-design/canvas-fonts'))
S = 2
BG, INK, MUTE, LINE = (11, 13, 18), (243, 244, 246), (128, 134, 148), (48, 53, 66)
BLUE, AMBER, GREEN = (10, 132, 255), (255, 183, 77), (76, 175, 80)

def font(name, size):
    return ImageFont.truetype(os.path.join(FONT_DIR, name), int(size * S))

def new(w, h):
    img = Image.new('RGB', (w * S, h * S), BG)
    return img, ImageDraw.Draw(img)

def save(img, name, w, h):
    img.resize((w, h), Image.LANCZOS).save(os.path.join(ASSETS, name), optimize=True)
    print('wrote', name)

def paste_scaled(img, path, x, y, target_w):
    im = Image.open(path).convert('RGB')
    r = target_w * S / im.size[0]
    im = im.resize((int(im.size[0] * r), int(im.size[1] * r)), Image.LANCZOS)
    img.paste(im, (x * S, y * S))
    return im.size[1] // S

def facts(d, x, y, rows):
    lf, vf = font('GeistMono-Regular.ttf', 13), font('InstrumentSans-Bold.ttf', 17)
    for label, value, color in rows:
        d.text((x * S, y * S), label, font=lf, fill=MUTE)
        d.text((x * S, (y + 20) * S), value, font=vf, fill=color)
        y += 58

# ---------------- before / after
W, H = 1280, 650
img, d = new(W, H)
d.text((72 * S, 48 * S), 'BEFORE / AFTER', font=font('GeistMono-Regular.ttf', 15), fill=MUTE)
d.text((72 * S, 72 * S), 'Same PC, same Edge, same Netflix title', font=font('InstrumentSans-Bold.ttf', 36), fill=INK)

pw = 300
for x0, shot, tag, col in ((72, 'popup-before.png', 'NORMAL EDGE', AMBER), (688, 'popup-after.png', 'STREAM-SAFE', GREEN)):
    d.text((x0 * S, 150 * S), tag, font=font('GeistMono-Regular.ttf', 15), fill=col)
    h = paste_scaled(img, os.path.join(ASSETS, shot), x0, 180, pw)
    d.rectangle((x0 * S - 1, 180 * S - 1, (x0 + pw) * S, (180 + h) * S), outline=LINE, width=S)

facts(d, 392, 190, [('GPU ACCELERATION', 'ON', INK), ('PLAYREADY HARDWARE DRM', 'ON', AMBER),
                    ('NETFLIX VIDEO WHEN CAPTURED', 'BLACK', AMBER), ('NETFLIX QUALITY', '1080p', INK)])
facts(d, 1012, 190, [('GPU ACCELERATION', 'ON', INK), ('PLAYREADY HARDWARE DRM', 'OFF', GREEN),
                     ('NETFLIX VIDEO WHEN CAPTURED', 'VISIBLE', GREEN), ('NETFLIX QUALITY', '1080p', INK)])
# arrow between the two columns
ay = 330
d.line([(618 * S, ay * S), (660 * S, ay * S)], fill=MUTE, width=2 * S)
d.polygon([(672 * S, ay * S), (658 * S, (ay - 7) * S), (658 * S, (ay + 7) * S)], fill=MUTE)
d.text((72 * S, 606 * S), 'Left: real popup screenshots from Edge. Capture result: same capture tool, same title, 1080p with DRM active.',
       font=font('InstrumentSans-Regular.ttf', 15), fill=MUTE)
save(img, 'before-after.png', W, H)

# ---------------- steps
W, H = 1280, 330
img, d = new(W, H)
steps = [('1', 'Download', 'Get the zip from Releases and extract it'),
         ('2', 'Install.bat', 'Double-click it. Creates a shortcut'),
         ('3', 'Open Stream-safe', 'Start Edge from the new Desktop icon'),
         ('4', 'Share on Discord', 'Watch Netflix or Disney+ and share the Edge window')]
cw, gap, x = 272, 24, 72
for n, title, sub in steps:
    d.rounded_rectangle((x * S, 48 * S, (x + cw) * S, 282 * S), radius=16 * S, outline=LINE, width=2 * S, fill=(17, 20, 27))
    d.text(((x + 24) * S, 66 * S), n, font=font('InstrumentSans-Bold.ttf', 70), fill=BLUE)
    d.text(((x + 24) * S, 168 * S), title, font=font('InstrumentSans-Bold.ttf', 23), fill=INK)
    # wrap subtitle
    words, line, y = sub.split(), '', 206
    f = font('InstrumentSans-Regular.ttf', 16)
    for wd in words:
        t = (line + ' ' + wd).strip()
        if d.textlength(t, font=f) > (cw - 48) * S:
            d.text(((x + 24) * S, y * S), line, font=f, fill=MUTE); y += 22; line = wd
        else:
            line = t
    d.text(((x + 24) * S, y * S), line, font=f, fill=MUTE)
    x += cw + gap
save(img, 'steps.png', W, H)
