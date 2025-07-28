import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["foregroundLayer"]

  start() {
    this.foregroundLayerTarget.classList.remove("hidden");
  }
}
