import { Controller } from "stimulus"

export default class extends Controller {
  approvalChange(){
    this.loadList();
  }

  loadList(){
    fetch('/subjects/list')
      .then(response => response.text())
      .then(text => {
        this.element.innerHTML = text;
        window.initializeCheckboxes();
      });
  }
}
