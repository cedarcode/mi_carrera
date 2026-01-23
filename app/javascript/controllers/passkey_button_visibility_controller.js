import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["createPasskeyButton", "unsupportedMessage"];

  hide() {
    this.element.classList.add("hidden");
  }

  disable() {
    this.createPasskeyButtonTarget.disabled = true;
    this.unsupportedMessageTarget.hidden = false;
  }
}
