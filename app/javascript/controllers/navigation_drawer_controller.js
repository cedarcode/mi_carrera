import { Controller } from "stimulus";
import { MDCDrawer } from "@material/drawer";

export default class extends Controller {
  static targets = ["drawer"];

  connect() {
    this.drawer = MDCDrawer.attachTo(this.drawerTarget);
  }

  open() {
    this.drawer.open = true;
  }

  close() {
    this.drawer.open = false;
  }
}
