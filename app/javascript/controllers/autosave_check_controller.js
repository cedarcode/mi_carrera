import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  update(e) {
    e.preventDefault();
    Turbo.navigator.submitForm(this.element)
  }
}
