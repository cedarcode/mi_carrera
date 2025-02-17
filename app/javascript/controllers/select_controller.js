import { Controller } from "@hotwired/stimulus";
import { MDCMenu } from '@material/menu';
import { MDCSelect } from '@material/select';

export default class extends Controller {
  static targets = ["menu", "select"];

  connect() {
    this.select = new MDCSelect(this.selectTarget);
    this.menu = new MDCMenu(this.menuTarget);
  }

  open(e) {
    e.preventDefault();
  }
}
