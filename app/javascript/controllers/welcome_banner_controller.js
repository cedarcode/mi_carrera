import { Controller } from "@hotwired/stimulus";
import { MDCBanner } from "@material/banner";

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
