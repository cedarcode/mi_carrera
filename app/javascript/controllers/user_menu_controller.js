import { Controller } from "@hotwired/stimulus";
import { MDCMenu } from '@material/menu';
import { Corner } from '@material/menu-surface/constants';

export default class extends Controller {
  static targets = ["menu", "trigger"];

  connect() {
    this.menu = new MDCMenu(this.menuTarget);
    this.menu.setAnchorCorner(Corner.BOTTOM_START);
  }

  open() {
    this.menu.open = true;

    // When the menu is open and the toggle is clicked to close it, the menu closes and then rapidly reopens again.
    // This piece of code serves as workaround to fix that for the moment.
    // Extracted from https://github.com/material-components/material-components-web/issues/6188
    document.body.addEventListener('click', (event) => {
      if (this.triggerTarget.contains(event.target)) {
        event.stopPropagation()
      }
    }, { capture: true, once: true })
  }
}
