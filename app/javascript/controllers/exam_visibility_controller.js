import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam" ]

  approvalChange(event) {
    let able_to_enroll_exam = event.detail[0]["able_to_enroll_exam"];

    this.examTargets.forEach((element, i) => {
      element.classList.toggle('exam-hidden', !able_to_enroll_exam);
    })
  }
}
