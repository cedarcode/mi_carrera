import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["appBar", "searchbar"];

  toggle() {
    this.appBarTarget.classList.toggle("d-none")
    this.searchbarTarget.classList.toggle("d-none")
  }
}
