import { Controller } from "stimulus";
import { MDCDialog } from "@material/dialog";

export default class extends Controller {
  open() {
    const dialog = new MDCDialog(document.querySelector(".mdc-dialog"));
    dialog.open();
  }
}
