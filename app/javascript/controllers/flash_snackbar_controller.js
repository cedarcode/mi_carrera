import { Controller } from "stimulus";
import { MDCSnackbar } from "@material/snackbar";

export default class extends Controller {
  connect() {
    const snackbar = new MDCSnackbar(document.querySelector(".mdc-snackbar"));
    snackbar.open();
  }
}
