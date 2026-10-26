// Takes real screenshots of the extension popup in Edge: default vs stream-safe flag.
// Uses a throwaway profile; chrome.storage is stubbed because the popup runs from localhost here.
// Usage: node tools/shoot-popup.mjs   (run from a short working directory on Windows)
import { spawn } from 'node:child_process';
import http from 'node:http';
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const repo = join(dirname(fileURLToPath(import.meta.url)), '..');
const extDir = join(repo, 'extension');
const outDir = join(repo, 'assets');
mkdirSync(outDir, { recursive: true });
const exe = process.env.EDGE_EXE || 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const sleep = ms => new Promise(r => setTimeout(r, ms));

const srv = http.createServer((q, r) => {
  try {
    const f = q.url.split('?')[0].replace(/^\//, '');
    let b = readFileSync(join(extDir, f));
    if (f === 'probe.js') b = Buffer.concat([Buffer.from('window.chrome={storage:{sync:{get:async()=>({}),set:async()=>{}}}};\n'), b]);
    r.setHeader('content-type', f.endsWith('.js') ? 'text/javascript' : f.endsWith('.css') ? 'text/css' : 'text/html');
    r.end(b);
  } catch { r.statusCode = 404; r.end(); }
}).listen(8765);

async function shoot(label, extra, file) {
  const port = 9300 + Math.floor(Math.random() * 500);
  const dir = join(process.env.TEMP, 'edgeshot', label + Date.now());
  const p = spawn(exe, [`--remote-debugging-port=${port}`, `--user-data-dir=${dir}`, '--no-first-run', '--no-default-browser-check', 'about:blank', ...extra], { stdio: 'ignore' });
  try {
    let targets;
    for (let i = 0; i < 40; i++) { try { targets = await (await fetch(`http://127.0.0.1:${port}/json`)).json(); if (targets.some(t => t.type === 'page')) break; } catch {} await sleep(500); }
    const ws = new WebSocket(targets.find(t => t.type === 'page').webSocketDebuggerUrl);
    await new Promise(r => ws.onopen = r);
    let id = 0;
    const call = (method, params) => new Promise(r => { const n = ++id; const h = e => { const m = JSON.parse(e.data); if (m.id === n) { ws.removeEventListener('message', h); r(m); } }; ws.addEventListener('message', h); ws.send(JSON.stringify({ id: n, method, params })); });
    await call('Emulation.setDeviceMetricsOverride', { width: 372, height: 900, deviceScaleFactor: 2, mobile: false });
    await call('Emulation.setEmulatedMedia', { features: [{ name: 'prefers-color-scheme', value: 'dark' }] });
    await call('Page.navigate', { url: 'http://localhost:8765/popup.html' });
    for (let i = 0; i < 30; i++) {
      await sleep(1000);
      const r = await call('Runtime.evaluate', { expression: "document.getElementById('verdict').className", returnByValue: true });
      if (!/wait/.test(r.result.result.value)) break;
    }
    await sleep(500);
    const h = (await call('Runtime.evaluate', { expression: 'document.body.scrollHeight', returnByValue: true })).result.result.value;
    await call('Emulation.setDeviceMetricsOverride', { width: 372, height: h, deviceScaleFactor: 2, mobile: false });
    await sleep(300);
    const shot = await call('Page.captureScreenshot', { format: 'png', clip: { x: 0, y: 0, width: 372, height: h, scale: 1 } });
    writeFileSync(join(outDir, file), Buffer.from(shot.result.data, 'base64'));
    console.log('wrote', file, h);
  } finally { spawn('taskkill', ['/F', '/T', '/PID', String(p.pid)], { stdio: 'ignore' }); }
}

try {
  await shoot('before', [], 'popup-before.png');
  await shoot('after', ['--enable-features=msDisablePlayReadyHardwareDrm'], 'popup-after.png');
} finally { srv.close(); }
process.exit(0);
