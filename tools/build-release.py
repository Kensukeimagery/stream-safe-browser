"""Builds dist/stream-safe-browser-windows.zip (the file the Download button serves)."""
import os
import zipfile

root = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
os.chdir(root)
os.makedirs('dist', exist_ok=True)
out = os.path.join('dist', 'stream-safe-browser-windows.zip')
if os.path.exists(out):
    os.remove(out)

top = ['Install.bat', 'Uninstall.bat', 'README.md', 'README.en.md', 'LICENSE']
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for f in top:
        z.write(f, 'stream-safe-browser/' + f)
    for d in ('scripts', 'extension'):
        for r, _, files in os.walk(d):
            for f in files:
                p = os.path.join(r, f).replace(os.sep, '/')
                z.write(p, 'stream-safe-browser/' + p)
print('built', out)
