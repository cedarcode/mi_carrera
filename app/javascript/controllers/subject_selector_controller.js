import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "dropdown",
    "buttonText",
    "menu",
    "searchInput",
    "hiddenInput",
    "option",
    "categoryHeader",
    "submitButton",
    "arrow",
  ];

  toggle(event) {
    event.preventDefault();
    this.menuTarget.classList.toggle("hidden");

    if (this.menuTarget.classList.contains("hidden")) {
      this.resetDropdown();
    } else {
      this.arrowTarget.style.transform = "rotate(180deg)";
      this.searchInputTarget.focus();
      document.addEventListener("click", this.handleOutsideClick.bind(this));
    }
  }

  handleOutsideClick(event) {
    if (!this.dropdownTarget.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
      this.resetDropdown();
    }
  }

  select(event) {
    const { subjectId, subjectName } = event.currentTarget.dataset;

    this.hiddenInputTarget.value = subjectId;
    this.buttonTextTarget.textContent = subjectName;
    this.submitButtonTarget.disabled = false;
    this.menuTarget.classList.add("hidden");
    this.resetDropdown();
  }

  search(event) {
    const searchTerm = event.target.value.toLowerCase().trim();

    this.optionTargets.forEach((option) => {
      option.style.display = option.textContent
        .toLowerCase()
        .includes(searchTerm)
        ? "block"
        : "none";
    });

    this.categoryHeaderTargets.forEach((category) => {
      const nextOption = category.nextElementSibling;
      category.style.display =
        nextOption && nextOption.style.display === "block" ? "block" : "none";
    });
  }

  resetDropdown() {
    this.arrowTarget.style.transform = "rotate(0deg)";
    this.searchInputTarget.value = "";
    [...this.optionTargets, ...this.categoryHeaderTargets].forEach(
      (el) => (el.style.display = "block")
    );
    document.removeEventListener("click", this.handleOutsideClick.bind(this));
  }
}
