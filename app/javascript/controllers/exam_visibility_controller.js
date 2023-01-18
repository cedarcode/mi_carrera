import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkbox" ]

  approvalChange() {
    let ableToEnrollExam
    let url = '/subjects/' + this.examTarget.dataset.subjectId + '/able_to_enroll';
    let exam = this.examTarget;
    let examCheckbox = this.checkboxTarget;
    let hiddenExamCheckbox = document.querySelector("input[name='"+examCheckbox.getAttribute("name")+"'][type='hidden']")

    fetch(url)
      .then(function(response) {
        return response.json();
      })
      .then(function(myJson) {
        ableToEnrollExam = myJson.exam

        exam.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);

        if (ableToEnrollExam) {
          examCheckbox.removeAttribute("disabled");
          hiddenExamCheckbox.removeAttribute("disabled");
        } else {
          examCheckbox.setAttribute("disabled", "disabled");
          hiddenExamCheckbox.setAttribute("disabled", "disabled");
          examCheckbox.checked = false;
        }
      });
  }
}
