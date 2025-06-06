import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];

  connect() {
    let contentHeight = this.contentTarget.offsetHeight;
    this.element.style.setProperty("height", `${contentHeight}px`);
  }

  dismiss() {
    this.element.remove();
  }
}
