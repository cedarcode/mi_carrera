import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "button"];

  initialize() {
    this.isOpen = false;
    this.hide();
  }

  connect() {
    console.log("toggle_app_review_form controller connected");
  }

  toggle() {
    console.log("toggling app review formm");
    this.isOpen ? this.hide() : this.show();
    this.isOpen = !this.isOpen;
  }

  show() {
    this.buttonTarget.style.backgroundColor = "#6804ec";
    this.buttonTarget.style.color = "white";
    this.formTarget.style.display = "block";
  }

  hide() {
    this.buttonTarget.style.backgroundColor = "white";
    this.buttonTarget.style.color = "black";
    this.formTarget.style.display = "none";
  }
}
