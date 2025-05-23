import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["drawer", "overlay"]

  toggle() {
    this.drawerTarget.classList.toggle("-translate-x-full")
    this.overlayTarget.classList.toggle("hidden")
  }
}
