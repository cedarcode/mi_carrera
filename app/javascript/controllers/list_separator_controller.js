import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["separator"];

  connect() {
    // get text in h3 inside target separator
    const headerText = this.separatorTarget.querySelector("h3.list-separator-header");
    if (!headerText) {
      return;
    }
    const headerTextContent = headerText.textContent.trim();

    // check that the header is already present in the DOM and not hidden
    const headers = document.querySelectorAll("h3.list-separator-header");
    const existingHeader = Array.from(headers).find(
      h3 => h3.textContent.trim() === headerTextContent && !h3.closest("div.separator").classList.contains("hidden")
    );

    if (existingHeader) {
      return;
    }

    // remove class hidden and add flex
    this.separatorTarget.classList.remove("hidden");
    this.separatorTarget.classList.add("flex");
  }
}
