import { Controller } from "stimulus"

export default class extends Controller {
  update() {
    this.element.submit();
  }
}
