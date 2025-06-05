import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["banner"];

  connect() {
    let contentHeight = this.bannerTarget.offsetHeight;
    this.element.style.setProperty("height", `${contentHeight}px`);
  }

  dismiss() {
    this.element.remove();
  }
}
