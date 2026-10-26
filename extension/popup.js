const $ = (id) => document.getElementById(id);

function row(label, on, onText, offText) {
  const li = document.createElement('li');
  const a = document.createElement('span');
  a.textContent = label;
  const b = document.createElement('span');
  b.textContent = on ? onText : offText;
  b.className = on ? 'on' : 'off';
  li.append(a, b);
  return li;
}

async function init() {
  const r = await self.StreamSafeProbe.probeDrm();
  const verdict = $('verdict');
  if (r.hardwareDrm) {
    verdict.textContent = 'Hardware DRM is ON: screen share may go black';
    verdict.className = 'verdict warn';
    $('explain').textContent = 'Netflix, Disney+ and similar sites play through a protected video path that Windows hides from screen capture, including Discord.';
    $('fix').hidden = false;
  } else {
    verdict.textContent = 'Stream-safe: hardware DRM is OFF';
    verdict.className = 'verdict ok';
    $('explain').textContent = r.prSw || r.wvSw
      ? 'Protected video should be capturable. If Discord still shows black, check Discord’s own settings (see the README).'
      : 'No DRM support detected at all. Hardware acceleration may be off, which also blocks some DRM playback.';
  }
  const d = $('details');
  d.append(
    row('PlayReady hardware (SL3000)', r.prHw, 'available', 'off'),
    row('PlayReady software (SL2000)', r.prSw, 'available', 'unavailable'),
    row('Widevine hardware', r.wvHw, 'available', 'off'),
    row('Widevine software (L3)', r.wvSw, 'available', 'unavailable')
  );
}

$('copy').addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText($('flag').textContent);
    $('copy').textContent = 'Copied';
  } catch (e) {
    $('copy').textContent = 'Select and copy manually';
  }
});

const bannerBox = $('banner');
chrome.storage.sync.get('bannerEnabled').then((s) => { bannerBox.checked = s.bannerEnabled !== false; }).catch(() => { bannerBox.checked = true; });
bannerBox.addEventListener('change', () => {
  chrome.storage.sync.set({ bannerEnabled: bannerBox.checked }).catch(() => {});
});

init();
