import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "textarea", "stars"];

  // when user has written some text in the textarea and has also selected a rating
  // then the button should be enabled.

  initialize() {
    disable();
  }

  enable() {
    console.log('enabling button');
    this.buttonTarget.disabled = false;
    this.buttonTarget.style.backgroundColor = "#6804ec";
    this.buttonTarget.style.color = "white";
  }

  disable() {
    console.log('disabling button');
    this.buttonTarget.disabled = true;
    this.buttonTarget.style.backgroundColor = "white";
    this.buttonTarget.style.color = "black";
  }

  connect() {
    console.log("confirm_app_review_button controller connected");
  }
}
