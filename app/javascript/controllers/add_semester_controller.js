/**
 * Controller para manejar la funcionalidad de agregar semestres
 * - Deshabilita el botón durante el envío
 * - Hace scroll automático al final después de la carga
 * - Maneja el estado de scroll entre navegaciones de Turbo
 */
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.shouldScrollToBottom = false;
    document.addEventListener("turbo:load", this.scrollToBottom.bind(this));
  }

  disconnect() {
    document.removeEventListener("turbo:load", this.scrollToBottom.bind(this));
  }

  submit() {
    this.shouldScrollToBottom = true;
  }

  scrollToBottom() {
    if (this.shouldScrollToBottom) {
      setTimeout(() => {
        window.scrollTo({
          top: document.body.scrollHeight,
          behavior: "smooth",
        });
      }, 100);
      this.shouldScrollToBottom = false;
    }
  }
}
