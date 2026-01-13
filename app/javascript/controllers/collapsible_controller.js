import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "collapsible", "button" ]

  toggle() {
    const icon = this.collapsibleTarget.classList.contains("hidden") ? "expand_more" : "chevron_right";

    this.buttonTarget.innerHTML = icon;
    this.collapsibleTarget.classList.toggle("hidden");
  }

  preventToggle(event) {
    const { attributeName } = event.detail;
    if (attributeName === "class") event.preventDefault();
  }
}
