import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  initialize() {
    this.isOpen = false;
    this.hide();
  }

  connect() {
    console.log("toggle_review_form controller connected");
  }

  toggle() {
    console.log("toggling review formm");
    
    this.isOpen ? this.hide() : this.show();
    this.isOpen = !this.isOpen;
  }

  show() {
    this.formTarget.style.display = "block";
  }

  hide() {
    this.formTarget.style.display = "none";
  }
}