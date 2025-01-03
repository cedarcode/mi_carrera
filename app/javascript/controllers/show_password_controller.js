import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "toggleButton"];

  toggle() {
    if (this.passwordTarget.type === "password") {
      this.passwordTarget.type = "text";
      this.toggleButtonTarget.innerHTML = '<span class="material-icons">visibility_off</span>';
    } else {
      this.passwordTarget.type = "password";
      this.toggleButtonTarget.innerHTML = '<span class="material-icons">visibility</span>';
    }
  }
}
