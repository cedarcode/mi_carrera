import { Controller } from "stimulus"
import {MDCMenu} from '@material/menu';

export default class extends Controller {
  static targets = ["content"]

  openMenu(){
    const menu = new MDCMenu(this.contentTarget);
    menu.open = true;
  }
}
