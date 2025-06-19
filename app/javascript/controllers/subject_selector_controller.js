import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["select", "submitButton"];

  connect() {
    this.choices = new Choices(this.selectTarget, {
      searchEnabled: true,
      searchPlaceholderValue: "Buscar materia...",
      itemSelectText: "",
      noResultsText: "No se encontraron materias",
      noChoicesText: "No hay materias disponibles",
      shouldSort: false,
      placeholder: true,
      placeholderValue: "Seleccionar materia...",
      classNames: {
        containerOuter: ["choices", "!m-0", "!h-10"],
        containerInner: [
          "choices__inner",
          "!min-h-10",
          "!h-10",
          "!flex",
          "!items-center",
        ],
      },
    });

    this.selectTarget.addEventListener("change", () => {
      this.submitButtonTarget.disabled = false;
    });
  }

  disconnect() {
    if (this.choices) {
      this.choices.destroy();
    }
  }
}
