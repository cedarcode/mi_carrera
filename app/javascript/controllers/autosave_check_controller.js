import { Controller } from "stimulus"

export default class extends Controller {
  update() {
    Rails.fire(this.element, 'submit');
  }

  notifyCreditsChange(event) {
    let updateCreditsEvent = new CustomEvent('credits-change', { detail: event.detail[0]["credits"] });
    document.querySelector(".js-credits-count").dispatchEvent(updateCreditsEvent);
  }
}
