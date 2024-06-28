// Borrowed from https://github.com/GoogleChromeLabs/sw-precache/issues/340#issuecomment-349982432
async function unregisterServiceWorkers() {
  if (navigator.serviceWorker) {
    try {
      const registrations = await navigator.serviceWorker.getRegistrations();
      for (let registration of registrations) {
        await registration.unregister();
      }
    } catch (err) {
      console.log('Service Worker unregistration failed: ', err);
    }
  }
}

unregisterServiceWorkers();
