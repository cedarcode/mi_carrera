import { Controller } from "@hotwired/stimulus";
import { MDCDialog } from '@material/dialog';

export default class extends Controller {
  static targets = ["dialog", "trigger"];

  connect() {
    this.dialog = new MDCDialog(this.dialogTarget);
  }

  open() {
    this.dialog.open();
  }
}
