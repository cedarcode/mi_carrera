import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkbox" ]

  approvalChange() {
    const bedel = this.bedelController;
    let ableToEnrollExam
    let url = '/subjects/' + this.examTarget.dataset.subjectId + '/able_to_enroll';
    let exam = this.examTarget;
    let examCheck = this.checkboxTarget.querySelector('input[type="checkbox"]');
    let examHiddenCheck = this.checkboxTarget.querySelector('input[type="hidden"]');

    fetch(url)
      .then(function(response) {
        return response.json();
      })
      .then(function(myJson) {
        ableToEnrollExam = myJson.exam

        exam.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);

        if (ableToEnrollExam) {
          [examCheck, examHiddenCheck].forEach(element => element.removeAttribute("disabled"));
        } else {
          [examCheck, examHiddenCheck].forEach(element => element.setAttribute("disabled", "disabled"));
          examCheck.checked = false;
        }
        bedel.finishUpdate();
      });
  }

  get bedelController() {
    return this.application.getControllerForElementAndIdentifier(this.element, "bedel")
  }
}
