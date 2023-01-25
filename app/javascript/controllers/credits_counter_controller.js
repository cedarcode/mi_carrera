import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  update(event) {
    let credits = event.detail;

    document.querySelector(".js-credits-count").innerHTML = credits;
  }
}
