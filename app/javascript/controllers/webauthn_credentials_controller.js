import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["credentialHiddenInput"]

  async create({ params: { options } }) {
    try {
      const credentialOptions = PublicKeyCredential.parseCreationOptionsFromJSON(options);
      const credential = await navigator.credentials.create({ publicKey: credentialOptions });

      this.credentialHiddenInputTarget.value = JSON.stringify(credential);

      this.element.submit();
    } catch (error) {
      if (error.name === "NotAllowedError") {
        alert("La operación fue cancelada o su tiempo se agotó.");
      } else if (error.name === "InvalidStateError") {
        alert("Ya registraste esta passkey con tu cuenta.");
      } else {
        alert(error.message || error);
      }
    }
  }

  async get({ params: { options } }) {
    try {
      const credentialOptions = PublicKeyCredential.parseRequestOptionsFromJSON(options);
      const credential = await navigator.credentials.get({ publicKey: credentialOptions });

      this.credentialHiddenInputTarget.value = JSON.stringify(credential);

      this.element.submit();
    } catch (error) {
      if (error.name === "NotAllowedError") {
        alert("La operación fue cancelada o su tiempo se agotó.");
      } else {
        alert(error.message || error);
      }
    }
  }
}
