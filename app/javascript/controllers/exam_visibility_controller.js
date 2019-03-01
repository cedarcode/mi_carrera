import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam", "checkbox" ]

  approvalChange(event) {
    let ableToEnrollExam = event.detail[0]["able_to_enroll_exam"];

    this.examTargets.forEach((element) => {
      element.classList.toggle("mdc-list-item--disabled", !ableToEnrollExam);
    })

    this.checkboxTargets.forEach((element) => {
      if (ableToEnrollExam) {
        element.removeAttribute("disabled");
      } else {
        element.setAttribute("disabled", "disabled");
      }
    })
  }
}
