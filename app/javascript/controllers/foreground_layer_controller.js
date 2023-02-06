import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"];

  add() {
    for (const checkbox of this.checkboxTargets) {
      checkbox.disabled = true;
    }
  }
}
