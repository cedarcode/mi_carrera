import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  start() {
    var foregroundLayer = document.createElement("div");
    foregroundLayer.classList.add("bg-gray-300", "min-h-full", "w-full", "absolute", "top-0", "opacity-40");
    foregroundLayer.setAttribute("id", "foreground-layer");;
    foregroundLayer.addEventListener("click", function(event) {
      event.preventDefault();
    });
    this.element.append(foregroundLayer);
  }
}
