import { Controller } from "@hotwired/stimulus"
import * as WebAuthnJSON from "@github/webauthn-json"

export default class extends Controller {
  #getCSRFToken() {
    var CSRFSelector = document.querySelector('meta[name="csrf-token"]')
    if (CSRFSelector) {
      return CSRFSelector.getAttribute("content")
    } else {
      return null
    }
  }

  #callback(url, body) {
    fetch(url, {
      method: "POST",
      body: JSON.stringify(body),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": this.#getCSRFToken()
    },
    credentials: 'same-origin'
    }).then(function(response) {
      if (response.ok) {
        window.location.replace("/usuarios/passkeys")
      } else if (response.status < 500) {
        response.text().then(text => alert(text));
      } else {
        alert("Ocurrió un problema al registrar tu passkey");
      }
    });
  }

  create(event) {
    var [data, status, xhr] = event.detail;
    var credentialOptions = data;
    var credential_name = event.target.querySelector("input[name='credential[name]']").value;
    var callback_url = `/usuarios/passkeys/callback?credential_name=${credential_name}`

    //Server knows identity of the user asking this passkey
    WebAuthnJSON.create({ "publicKey": credentialOptions })
      .then((credential) => {
        this.#callback(encodeURI(callback_url), credential);
      }).catch(error => {
        if (error.name === "NotAllowedError") {
          alert("No seleccionaste el autenticador o cancelaste la operación.");
        } else if (error.name === "InvalidStateError") {
          alert("Ya registraste esta passkey con tu cuenta.");
        } else {
          alert(error.message || error);
        }
      });
  }
}
