import { Controller } from "stimulus"
import {MDCMenu} from '@material/menu';

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.menu = new MDCMenu(this.contentTarget);
    this.menu.open = false;
  }

  openMenu() {
    this.menu.open = true;
    const screen = document.createElement("div");
    screen.setAttribute("id", "menu-background");
    screen.addEventListener("click", function() {
      screen.remove();
    });
    document.querySelector(".mdc-menu-surface--anchor").prepend(screen);
    document.addEventListener("turbolinks:before-cache", function() {
      if (screen != null) {
            screen.remove();
      }
    });
  }
}
