import { Controller } from "stimulus"

export default class extends Controller {
  approvalChange() {
    this.updateSubjects();
  }

  updateSubjects() {
    fetch('/subjects/list')
      .then(response => response.text())
      .then(text => {
        this.element.outerHTML = text;
        window.initializeCheckboxes();
      });
  }
}
