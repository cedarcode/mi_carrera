import { Controller } from "@hotwired/stimulus";
import { MDCDialog } from "@material/dialog";

export default class extends Controller {
  static targets = ["trigger", "dialog"];

  open() {
    const dialog = new MDCDialog(this.dialogTarget);
    dialog.open();
    this.triggerTarget.blur();
  }
}
