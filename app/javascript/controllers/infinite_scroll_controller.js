import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.createObserver();
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }

  createObserver() {
    const options = {
      root: null, // viewport
      rootMargin: '700px', // starts loading page 700px before it enters the viewport
    };

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadContent();
        }
      });
    }, options);

    this.observer.observe(this.element);
  }

  loadContent() {
    this.observer.disconnect();
    this.element.removeAttribute('loading');
  }
}
