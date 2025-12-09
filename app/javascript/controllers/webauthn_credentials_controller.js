import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json/browser-ponyfill"

export default class extends Controller {
  static targets = ["credentialHiddenInput"]

  async create({ params: { options } }) {
    try {
      const credentialOptions = WebAuthnJSON.parseCreationOptionsFromJSON({ publicKey: options });
      const credential = await WebAuthnJSON.create(credentialOptions);

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
      const credentialOptions = WebAuthnJSON.parseRequestOptionsFromJSON({ publicKey: options });
      const credential = await WebAuthnJSON.get(credentialOptions);

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
