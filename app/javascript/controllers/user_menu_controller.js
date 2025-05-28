import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "trigger"];
  static hiddenClass = "hidden";

  connect() {
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

  toggle() {
    if (this.menuTarget.classList.contains(this.constructor.hiddenClass)) {
      this.open();
    } else {
      this.close();
    }
  }

  open() {
    this.menuTarget.classList.remove(this.constructor.hiddenClass);
  }

  close() {
    this.menuTarget.classList.add(this.constructor.hiddenClass);
  }

  onClick() {
    if (!this.menuTarget.classList.contains(this.constructor.hiddenClass)) {
      this.menuTarget.classList.add(this.constructor.hiddenClass);
    }
  }
}
