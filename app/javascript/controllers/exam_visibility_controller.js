import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "exam" ]

  approvalChange(event) {
    let ableToEnrollExam = event.detail[0]["able_to_enroll_exam"];

    this.examTargets.forEach((element) => {
      element.classList.toggle('exam-hidden', !ableToEnrollExam);
    })
  }
}
