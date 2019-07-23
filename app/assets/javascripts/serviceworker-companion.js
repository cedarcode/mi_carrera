if (navigator.serviceWorker) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
      .then(function(reg) {
        console.log('[Companion]', 'Service worker registered!');
      });
  });
}
