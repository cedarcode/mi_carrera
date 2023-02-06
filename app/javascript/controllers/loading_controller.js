import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "spinnerTemplate"];

  start({ target }) {
    const spinner = this.spinnerTemplateTarget.content.firstElementChild.cloneNode(true);
    target.parentElement.replaceChildren(spinner)

    for (const checkbox of this.checkboxTargets) {
      checkbox.disabled = true;
    }
  }
}
