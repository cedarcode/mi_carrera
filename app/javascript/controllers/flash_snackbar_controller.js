import { Controller } from "@hotwired/stimulus"
import { MDCSnackbar } from "@material/snackbar";

export default class extends Controller {
  connect() {
    new MDCSnackbar(this.element).open();
  }
}
