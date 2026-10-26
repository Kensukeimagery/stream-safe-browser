// Detects which DRM security levels this browser exposes.
// "hardware" levels are what Windows blocks from screen capture (black video).
(function (root) {
  const VIDEO = 'video/mp4; codecs="avc1.640028"';
  const AUDIO = 'audio/mp4; codecs="mp4a.40.2"';

  async function supports(keySystem, robustness) {
    try {
      await navigator.requestMediaKeySystemAccess(keySystem, [{
        initDataTypes: ['cenc'],
        videoCapabilities: [{ contentType: VIDEO, robustness }],
        audioCapabilities: [{ contentType: AUDIO }]
      }]);
      return true;
    } catch (e) {
      return false;
    }
  }

  async function probeDrm() {
    const [prHw, prSw, wvAll, wvDec, wvSw] = await Promise.all([
      supports('com.microsoft.playready.recommendation.3000', ''),
      supports('com.microsoft.playready.recommendation', ''),
      supports('com.widevine.alpha', 'HW_SECURE_ALL'),
      supports('com.widevine.alpha', 'HW_SECURE_DECODE'),
      supports('com.widevine.alpha', 'SW_SECURE_DECODE')
    ]);
    const hardwareDrm = prHw || wvAll || wvDec;
    return { prHw, prSw, wvHw: wvAll || wvDec, wvSw, hardwareDrm };
  }

  root.StreamSafeProbe = { probeDrm };
})(typeof self !== 'undefined' ? self : this);
