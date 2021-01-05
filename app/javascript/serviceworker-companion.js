if (navigator.serviceWorker) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/serviceworker.js', { scope: './' })
  });
}
