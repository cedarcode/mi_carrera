import { Controller } from "stimulus";
import { MDCDrawer } from "@material/drawer";

export default class extends Controller {
  connect() {
    this.drawer = MDCDrawer.attachTo(document.querySelector(".mdc-drawer"));
    this.drawer.open = false;
  }

  open() {
    this.drawer.open = true;
  }

  close() {
    this.drawer.open = false;
    const mainContentEl = document.querySelector(".main-content");
    mainContentEl.querySelector("input, button").focus();
  }
}
