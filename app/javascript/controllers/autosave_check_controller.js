import { Controller } from "stimulus"

export default class extends Controller {
  update() {
    Rails.fire(this.element, 'submit');
  }

  updateCredits(event) {
    var update_credits_event = new Event('credits-change');
    update_credits_event.detail = event.detail;
    document.querySelector(".js-credits-count").dispatchEvent(update_credits_event)
  }
}
