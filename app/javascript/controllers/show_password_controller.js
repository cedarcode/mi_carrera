import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "icon"];

  toggle() {
    if (this.passwordTarget.type === "password") {
      this.passwordTarget.type = "text";
      this.iconTarget.innerHTML = "visibility_off";
    } else {
      this.passwordTarget.type = "password";
      this.iconTarget.innerHTML = "visibility";
    }
  }
}
