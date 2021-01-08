import { Controller } from "stimulus"
import {MDCMenu} from '@material/menu';

export default class extends Controller {
  static targets = ["content"]

  openMenu(){
    const menu = new MDCMenu(this.contentTarget);
    menu.open = true;
    const screen = document.createElement("div");
    screen.setAttribute("id", "menu-background");
    screen.setAttribute("onclick", "document.getElementById('menu-background').remove()");
    document.body.appendChild(screen);
  }
}
