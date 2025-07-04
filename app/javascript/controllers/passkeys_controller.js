import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json/browser-ponyfill"

export default class extends Controller {
  async create({ params: { publicKey } }) {
    try{
      const passkeyOptions = WebAuthnJSON.parseCreationOptionsFromJSON({ publicKey });
      const passkeyPublicKey = await WebAuthnJSON.create(passkeyOptions);

      let hiddenPasskeyInput = this.element.querySelector("input[name='passkey_public_key']");
      if (!hiddenPasskeyInput) {
        hiddenPasskeyInput = document.createElement("input");
        hiddenPasskeyInput.type = "hidden";
        hiddenPasskeyInput.name = "passkey_public_key";
        this.element.appendChild(hiddenPasskeyInput);
      }
      hiddenPasskeyInput.value = JSON.stringify(passkeyPublicKey);

      this.element.submit();

    } catch (error) {
      if (error.name === "NotAllowedError") {
        alert("No seleccionaste el autenticador o cancelaste la operación.");
      } else if (error.name === "InvalidStateError") {
        alert("Ya registraste esta passkey con tu cuenta.");
      } else {
        alert(error.message || error);
      }
    }
  }
}
