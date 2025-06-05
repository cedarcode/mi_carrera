import { Controller } from "@hotwired/stimulus";
import { MDCBanner } from "@material/banner";

export default class extends Controller {
  dismiss() {
    this.element.remove();
  }
}
