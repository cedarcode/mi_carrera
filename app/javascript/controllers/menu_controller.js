import { Controller } from "stimulus"
import {MDCMenu} from '@material/menu';

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.menu = new MDCMenu(this.contentTarget);

    /*
      * This help us make sure the menu will be closed on restoration visits
      * while clicking on the browser's back button, and will not be half-way
      * open on turbolinks cache.
    */
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
      const screen = document.getElementById('menu-background');
      if (screen != null) {
        screen.remove();
      }
    });
  }
}
