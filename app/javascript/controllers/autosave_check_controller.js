import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  static targets = ["subjectSelect", "semesterSelect"];

  connect() {
    this.updateButtonVisibility();
  }

  toggleSemesterSelect() {
    const subjectSelected = this.subjectSelectTarget.value !== "";
    this.semesterSelectTarget.disabled = !subjectSelected;
  }

  submitIfSubjectSelected() {
    if (this.subjectSelectTarget.value !== "") {
      this.element.requestSubmit();
    }
  }

  update() {
    if (this.element.tagName === "FORM") {
      this.element.requestSubmit();
    } else {
      this.element.closest("form").requestSubmit();
    }
  }

  updateButtonVisibility() {
    if (this.hasAddButtonTarget) {
      const hasSubject = this.subjectSelectTarget.value !== "";
      this.addButtonTarget.style.display = hasSubject ? "block" : "none";
    }
  }

  stopPropagation(event) {
    event.stopPropagation();
  }
}
