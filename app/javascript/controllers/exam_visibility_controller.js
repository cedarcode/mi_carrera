import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkboxInputs", "checkbox" ]

  approvalChange() {
    let ableToEnrollExam
    let url = '/subjects/' + this.examTarget.dataset.subjectId + '/able_to_enroll';
    let exam = this.examTarget;
    let examCheckbox = this.checkboxTarget;
    let checkboxInputs = this.checkboxInputsTarget.querySelectorAll('input');

    fetch(url)
      .then(function(response) {
        return response.json();
      })
      .then(function(myJson) {
        ableToEnrollExam = myJson.exam

        exam.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);

        if (ableToEnrollExam) {
          checkboxInputs.forEach(element => element.removeAttribute("disabled"));
        } else {
          checkboxInputs.forEach(element => element.setAttribute("disabled", "disabled"));
          examCheckbox.checked = false;
        }
      });
  }
}
