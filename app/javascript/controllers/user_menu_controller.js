import { Controller } from "@hotwired/stimulus";
import { MDCMenu } from '@material/menu';
import { Corner } from '@material/menu-surface/constants';

export default class extends Controller {
  static targets = ["menu", "trigger"];

  connect() {
    this.menu = new MDCMenu(this.menuTarget);
    this.menu.setAnchorCorner(Corner.BOTTOM_START);

    // If the JS takes some time to load, it is possible to click on the
    // account circle button without the menu showing up. This is pronounced in
    // the system tests, resulting in a lot of flakiness.
    //
    // This workaround help us to at least remove the flakiness of the tests.
    // Basically, when the controller has finished connecting it adds a data
    // attribute to the element which we will use in the CSS matcher for
    // finding the button – that way capybara will only click on it when the
    // controller it's connected.
    this.triggerTarget.setAttribute('data-controller-connected', 'true');
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
