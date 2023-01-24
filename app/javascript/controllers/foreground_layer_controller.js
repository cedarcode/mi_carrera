import { Controller } from "stimulus"

export default class extends Controller {
  add() {
    var foregroundLayer = document.createElement("div");
    foregroundLayer.className = "foreground-layer";
    foregroundLayer.addEventListener("click", function(event) {
      event.preventDefault();
    });
    this.element.append(foregroundLayer);
  }

  remove() {
    document.getElementsByClassName("foreground-layer")[0].remove();
  }
}
