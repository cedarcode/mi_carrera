import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.lastKnownScrollPosition = window.scrollY;
  }

  toggle(data) {
    if (this.lastKnownScrollPosition > window.scrollY) {
      this.element.classList.add("sticky", "top-14", "sm:top-16");
      this.element.classList.remove("relative");
    } else {
      this.element.classList.add("relative");
      this.element.classList.remove("sticky", "top-14", "sm:top-16");
    }

    this.lastKnownScrollPosition = window.scrollY;
  }
}

