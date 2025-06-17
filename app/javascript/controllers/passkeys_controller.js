import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json/browser-ponyfill"

export default class extends Controller {
  async create({ params: { publicKey } }) {
    try{
      const passkeyOptions = WebAuthnJSON.parseCreationOptionsFromJSON({ publicKey });
      const passkeyPublicKey = await WebAuthnJSON.create(passkeyOptions);
      const formData = new FormData(this.element);
      formData.append('passkey_public_key', JSON.stringify(passkeyPublicKey));

      const response = await fetch(this.element.action, {
        method: this.element.method,
        body: formData,
      });

      if (response.ok) {
        window.location.replace("/usuarios/passkeys");
      } else {
        alert("Ocurrió un error al registrar la llave de seguridad.");
      }
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

  async get({ params: {publicKey} }) {
    try {
      const passkeyOptions = WebAuthnJSON.parseRequestOptionsFromJSON({ publicKey });
      const passkeyPublicKey = await WebAuthnJSON.get(passkeyOptions);
      const formData = new FormData(this.element);
      formData.append('passkey_public_key', JSON.stringify(passkeyPublicKey));

      const response = await fetch(this.element.action, {
        method: this.element.method,
        body: formData,
        headers: {
          "accept": "application/json",
        },
      });

      if (response.ok) {
        window.location.href = response.headers.get("Location") || '/';
      }  else {
        const json = await response.json();
        alert(json.error || "Ocurrió un error al intentar ingresar con su llave de seguridad.");
      }
    } catch (error) {
      alert(error);
    }
  }
}
