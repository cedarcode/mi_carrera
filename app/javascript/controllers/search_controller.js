import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["appBar", "searchbar", "searchInput"];

  toggle() {
    this.appBarTarget.classList.toggle("d-none")
    this.searchbarTarget.classList.toggle("d-none")
    if (!this.searchbarTarget.classList.contains("d-none")) {
      this.searchInputTarget.focus()
    }
  }
}
