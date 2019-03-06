import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkbox" ]

  approvalChange(event) {
    let ableToEnrollExam
    let url = '/subjects/' + this.examTarget.dataset.info + '/able_to_enroll';
    let exam = this.examTargets[0];
    let checkbox = this.checkboxTargets[0];

    fetch(url)
      .then(function(response) {
        return response.json();
      })
      .then(function(myJson) {
        ableToEnrollExam = myJson.exam

        exam.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);

        if (ableToEnrollExam) {
          checkbox.removeAttribute("disabled");
        } else {
          checkbox.setAttribute("disabled", "disabled");
        }
      });
  }
}
