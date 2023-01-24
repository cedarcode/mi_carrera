import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update({ detail: credits }) {
    this.element.innerHTML = credits;
  }
}
