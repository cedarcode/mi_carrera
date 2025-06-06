import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["appBar", "searchbar", "searchInput"];

  toggle() {
    this.appBarTarget.classList.toggle("hidden")
    this.searchInputTarget.value = ""
    this.searchbarTarget.classList.toggle("hidden")
    if (!this.searchbarTarget.classList.contains("hidden")) {
      this.searchInputTarget.focus()
    }
  }
}
