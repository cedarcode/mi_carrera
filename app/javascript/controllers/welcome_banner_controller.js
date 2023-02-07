import { Controller } from "@hotwired/stimulus";
import { MDCBanner } from "@material/banner";

export default class extends Controller {
  connect() {
    new MDCBanner(this.element).open();
  }
}
