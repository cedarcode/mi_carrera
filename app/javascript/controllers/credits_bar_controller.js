import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.lastKnownScrollPosition = window.scrollY;
  }

  toggle(data) {
    if (this.lastKnownScrollPosition > window.scrollY) {
      this.element.classList.add("sticky");
    } else {
      this.element.classList.remove("sticky");
    }

    this.lastKnownScrollPosition = window.scrollY;
  }
}

