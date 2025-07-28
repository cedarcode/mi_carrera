import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  start() {
    var foregroundLayer = document.createElement("div");
    foregroundLayer.classList.add("bg-gray-300", "min-h-full", "w-full", "absolute", "top-0", "opacity-40");
    foregroundLayer.setAttribute("id", "foreground-layer");;
    this.element.append(foregroundLayer);
  }
}
