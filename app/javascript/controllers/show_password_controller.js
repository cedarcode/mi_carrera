import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["password", "eye", "eyeSlash"];

  toggle() {
    if (this.passwordTarget.type === "password") {
      this.passwordTarget.type = "text";
      this.eyeTarget.classList.toggle("hidden");
      this.eyeSlashTarget.classList.toggle("hidden");
    } else {
      this.passwordTarget.type = "password";
      this.eyeTarget.classList.toggle("hidden");
      this.eyeSlashTarget.classList.toggle("hidden");
    }
  }
}
