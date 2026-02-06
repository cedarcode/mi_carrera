import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "unsupportedMessage"];

  hide() {
    this.element.classList.add("hidden");
  }

  disableButton() {
    this.buttonTarget.disabled = true;
    this.unsupportedMessageTarget.hidden = false;
  }
}
