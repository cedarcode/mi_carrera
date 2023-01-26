import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  add() {
    var foregroundLayer = document.createElement("div");
    foregroundLayer.className = "foreground-layer";
    foregroundLayer.addEventListener("click", function(event) {
      event.preventDefault();
    });
    this.element.append(foregroundLayer);
  }
}
