import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkbox" ]

  approvalChange() {
    const bedel = this.bedelController;
    let ableToEnrollExam
    let url = '/subjects/' + this.examTarget.dataset.subjectId + '/able_to_enroll';
    let exam = this.examTarget;
    let examCheckbox = this.checkboxTarget;

    fetch(url)
      .then(function(response) {
        return response.json();
      })
      .then(function(myJson) {
        ableToEnrollExam = myJson.exam

        exam.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);

        if (ableToEnrollExam) {
          examCheckbox.removeAttribute("disabled");
        } else {
          examCheckbox.setAttribute("disabled", "disabled");
          examCheckbox.checked = false;
        }
        bedel.finishUpdate();
      });
  }

  get bedelController() {
    return this.application.getControllerForElementAndIdentifier(this.element, "bedel")
  }
}
