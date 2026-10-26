// Optional notice on streaming sites when hardware DRM is active.
(async () => {
  const KEY = 'bannerEnabled';
  let enabled = true;
  try {
    const stored = await chrome.storage.sync.get(KEY);
    if (stored[KEY] === false) enabled = false;
  } catch (e) { /* storage unavailable: keep default */ }
  if (!enabled || sessionStorage.getItem('ssc-dismissed')) return;

  const result = await self.StreamSafeProbe.probeDrm();
  if (!result.hardwareDrm) return;

  const host = document.createElement('div');
  host.style.cssText = 'all:initial;position:fixed;z-index:2147483647;right:16px;bottom:16px;';
  const root = host.attachShadow({ mode: 'closed' });
  root.innerHTML = `
    <style>
      .box{font:13px/1.45 system-ui,Segoe UI,sans-serif;background:#1f1f23;color:#f2f2f2;
        border:1px solid #ffb74d;border-radius:10px;padding:12px 14px;max-width:320px;
        box-shadow:0 6px 24px rgba(0,0,0,.5)}
      b{color:#ffb74d}
      .row{display:flex;gap:8px;margin-top:10px}
      button{font:inherit;cursor:pointer;border:0;border-radius:6px;padding:5px 10px;
        background:#3a3a40;color:#f2f2f2}
      button:hover{background:#4a4a52}
    </style>
    <div class="box">
      <b>Hardware DRM is on.</b> Sharing this tab on Discord may show a black screen.
      Open the Stream-safe Check popup for the fix.
      <div class="row"><button id="x">Dismiss</button><button id="n">Don't show again</button></div>
    </div>`;
  root.getElementById('x').onclick = () => {
    try { sessionStorage.setItem('ssc-dismissed', '1'); } catch (e) {}
    host.remove();
  };
  root.getElementById('n').onclick = async () => {
    try { await chrome.storage.sync.set({ [KEY]: false }); } catch (e) {}
    host.remove();
  };
  document.documentElement.appendChild(host);
})();
