import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "collapsable", "button" ]

  toggle() {
    const icon = this.collapsableTarget.classList.contains("hidden") ? "expand_more" : "chevron_right";

    this.buttonTarget.innerHTML = icon;
    this.collapsableTarget.classList.toggle("hidden");
  }
}
