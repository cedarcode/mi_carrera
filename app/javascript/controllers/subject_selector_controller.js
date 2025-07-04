import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = ["select", "submitButton"];

  connect() {
    this.choices = new Choices(this.selectTarget, {
      searchEnabled: true,
      searchPlaceholderValue: "Buscar materia...",
      placeholderValue: "Seleccionar materia para planificar...",
      itemSelectText: "",
      noResultsText: "No se encontraron materias",
      noChoicesText: "No hay materias disponibles",
      shouldSort: false,
      classNames: {
        containerOuter: ["choices", "!m-0", "!h-10", "flex-grow-1"],
        containerInner: [
          "choices__inner",
          "!min-h-10",
          "!h-10",
          "!flex",
          "!items-center",
          "!bg-white",
          "!rounded-md",
        ],
      },
    });
  }

  onChange() {
    const selectedValue = this.selectTarget.value;
    this.submitButtonTarget.disabled = !selectedValue || selectedValue === "";
  }

  disconnect() {
    if (this.choices) {
      this.choices.destroy();
    }
  }
}
