import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "collapsable", "button" ]

  toggle() {
    if (!this.collapsableTarget.classList.contains("hidden")) {
      this.buttonTarget.innerHTML = "chevron_right"
    } else {
      this.buttonTarget.innerHTML = "expand_more";
    }

    this.collapsableTarget.classList.toggle("hidden");
  }
}
