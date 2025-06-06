import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "collapsable", "chevronRight", "chevronDown" ]

  toggle() {
    if (this.collapsableTarget.style.display == "block") {
      this.collapsableTarget.style.display = "none";
      this.chevronRightTarget.classList.toggle("hidden");
      this.chevronDownTarget.classList.toggle("hidden");
    } else {
      this.collapsableTarget.style.display = "block";
      this.chevronRightTarget.classList.toggle("hidden");
      this.chevronDownTarget.classList.toggle("hidden");
    }
  }
}
