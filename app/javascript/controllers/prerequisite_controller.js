import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "collapsable", "button" ]

  toggle() {
    if (this.collapsableTarget.style.display == "block") {
      this.collapsableTarget.style.display = "none";
      this.buttonTarget.innerHTML = "chevron_right"
    } else {
      this.collapsableTarget.style.display = "block";
      this.buttonTarget.innerHTML = "expand_more";
    }
  }
}
