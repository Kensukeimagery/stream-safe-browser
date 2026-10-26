"""Renders assets/banner.png (1280x640, also usable as the GitHub social preview).

Concept: the same screen twice. Left, protected video as capture sees it (black, hatched).
Right, the same screen lit. Everything else is quiet.
Fonts are from the canvas-design skill's font folder; set FONT_DIR to run elsewhere.
"""
import os
from PIL import Image, ImageDraw, ImageFont

FONT_DIR = os.environ.get('FONT_DIR', os.path.expanduser('~/.claude/skills/canvas-design/canvas-fonts'))
S = 3  # supersample
W, H = 1280 * S, 640 * S
BG, INK, MUTE = (11, 13, 18), (243, 244, 246), (128, 134, 148)
BLUE, AMBER = (10, 132, 255), (255, 183, 77)

def font(name, size):
    return ImageFont.truetype(os.path.join(FONT_DIR, name), int(size * S))

img = Image.new('RGB', (W, H), BG)
d = ImageDraw.Draw(img)

# faint dot grid
for x in range(0, W, 32 * S):
    for y in range(0, H, 32 * S):
        d.ellipse((x - 1, y - 1, x + 1, y + 1), fill=(24, 27, 35))

# ---- text block (left)
x0 = 72 * S
d.text((x0, 74 * S), 'STREAM-SAFE / EDGE', font=font('GeistMono-Regular.ttf', 15), fill=MUTE)
d.text((x0, 128 * S), 'Stream-safe', font=font('InstrumentSans-Bold.ttf', 86), fill=INK)
d.text((x0, 222 * S), 'Browser', font=font('InstrumentSans-Bold.ttf', 86), fill=INK)
d.text((x0, 346 * S), 'Share Netflix and Disney+ on Discord', font=font('InstrumentSans-Regular.ttf', 27), fill=(205, 208, 216))
d.text((x0, 384 * S), 'without the black screen. GPU stays on.', font=font('InstrumentSans-Regular.ttf', 27), fill=(205, 208, 216))

# status chips
def chip(x, y, label, color):
    f = font('GeistMono-Regular.ttf', 15)
    w = d.textlength(label, font=f) + 36 * S
    d.rounded_rectangle((x, y, x + w, y + 36 * S), radius=18 * S, outline=color, width=2 * S)
    d.ellipse((x + 14 * S, y + 14 * S, x + 22 * S, y + 22 * S), fill=color)
    d.text((x + 30 * S, y + 8 * S), label, font=f, fill=INK)
    return x + w + 14 * S

cx = chip(x0, 474 * S, 'GPU ACCELERATION  ON', BLUE)
chip(cx, 474 * S, 'HARDWARE DRM  OFF', AMBER)

# ---- two screens (right)
def screen(box, lit):
    x, y, x1, y1 = box
    d.rounded_rectangle(box, radius=14 * S, fill=(5, 6, 9), outline=(48, 53, 66), width=2 * S)
    inner = (x + 10 * S, y + 10 * S, x1 - 10 * S, y1 - 10 * S)
    ix, iy, ix1, iy1 = inner
    if lit:
        grad = Image.new('RGB', (ix1 - ix, iy1 - iy))
        gd = ImageDraw.Draw(grad)
        h = iy1 - iy
        for row in range(h):
            t = row / h
            gd.line([(0, row), (ix1 - ix, row)], fill=(int(20 + 40 * t), int(90 + 60 * (1 - t)), int(255 - 70 * t)))
        mask = Image.new('L', grad.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle((0, 0, grad.size[0], grad.size[1]), radius=8 * S, fill=255)
        img.paste(grad, (ix, iy), mask)
        cxm, cym, r = (ix + ix1) // 2, (iy + iy1) // 2, 34 * S
        d.ellipse((cxm - r, cym - r, cxm + r, cym + r), fill=(255, 255, 255))
        d.polygon([(cxm - 10 * S, cym - 16 * S), (cxm - 10 * S, cym + 16 * S), (cxm + 18 * S, cym)], fill=(20, 60, 160))
    else:
        pane = Image.new('RGB', (ix1 - ix, iy1 - iy), (0, 0, 0))
        pd = ImageDraw.Draw(pane)
        ph, pw = pane.size[1], pane.size[0]
        for k in range(-ph, pw, 22 * S):  # hatch = protected video path
            pd.line([(k, ph), (k + ph, 0)], fill=(30, 33, 42), width=S)
        mask = Image.new('L', pane.size, 0)
        ImageDraw.Draw(mask).rounded_rectangle((0, 0, pw, ph), radius=8 * S, fill=255)
        img.paste(pane, (ix, iy), mask)

sy0, sy1 = 214 * S, 374 * S
screen((668 * S, sy0, 918 * S, sy1), False)
screen((958 * S, sy0, 1208 * S, sy1), True)

# seam + labels
mx = 938 * S
d.line([(mx, sy0 - 28 * S), (mx, sy1 + 28 * S)], fill=(70, 76, 92), width=S)
lf = font('GeistMono-Regular.ttf', 14)
d.text((668 * S, sy1 + 24 * S), 'WHAT DISCORD SEES', font=lf, fill=MUTE)
d.text((958 * S, sy1 + 24 * S), 'WITH STREAM-SAFE', font=lf, fill=INK)
d.text((668 * S, sy0 - 40 * S), 'DEFAULT', font=lf, fill=AMBER)
d.text((958 * S, sy0 - 40 * S), 'FIXED', font=lf, fill=BLUE)

os.makedirs(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets'), exist_ok=True)
out = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'assets', 'banner.png')
img.resize((1280, 640), Image.LANCZOS).save(out, optimize=True)
print('wrote', out)
