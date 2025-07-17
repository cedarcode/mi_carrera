import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.scrollTo({ top: document.body.scrollHeight, behavior: "smooth" });
  }
}
