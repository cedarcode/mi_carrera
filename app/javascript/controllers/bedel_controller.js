import { Controller } from "stimulus"

export default class extends Controller {

  prepareUpdate(){
    var foregroundLayer = document.createElement("div");
    foregroundLayer.className = "foreground-layer";
    foregroundLayer.addEventListener("click", function(event) {
      event.preventDefault();
    });
    document.body.append(foregroundLayer);
  }

  finishUpdate(){
    var foregroundLayer = document.getElementsByClassName("foreground-layer")[0];
    foregroundLayer.parentNode.removeChild(foregroundLayer);
  }

  approvalChange() {
    this.updateSubjects();
  }

  updateSubjects() {
    fetch('/subjects/list')
      .then(response => response.text())
      .then(text => {
        this.element.outerHTML = text;
        this.finishUpdate();
      });
  }
}
