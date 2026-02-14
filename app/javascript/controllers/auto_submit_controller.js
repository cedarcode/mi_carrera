import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  submit(e) {
    e.target.form.requestSubmit()
  }
}
